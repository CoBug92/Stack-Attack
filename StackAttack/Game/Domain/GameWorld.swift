import CoreGraphics
import Foundation

/// Deterministic, renderer-independent Stack Attack simulation.
struct GameWorld {
	// MARK: - Nested types

	struct Configuration: Sendable {
		var playfield: CGRect
		var playerSize: CGSize
		var crateSize: CGSize
		var gravity: CGFloat
		var runSpeed: CGFloat
		var groundAcceleration: CGFloat
		var airAcceleration: CGFloat
		var jumpSpeed: CGFloat
		var pushSpeed: CGFloat

		static let `default` = Configuration(
			playfield: CGRect(x: 0, y: 0, width: 360, height: 640),
			playerSize: CGSize(width: 28, height: 42),
			crateSize: CGSize(width: 55, height: 55),
			gravity: 1_500,
			runSpeed: 142,
			groundAcceleration: 1_400,
			airAcceleration: 650,
			jumpSpeed: 480,
			pushSpeed: 115
		)
	}

	enum Control: Sendable { case left, right, jump }
	enum State: Equatable, Sendable { case playing, knockedOut, gameOver }

	struct PlayerSnapshot: Sendable {
		let frame: CGRect
		let velocity: CGVector
		let isSupported: Bool
		let pushDirection: CGFloat
	}

	struct CrateSnapshot: Sendable, Identifiable {
		let id: Int
		let frame: CGRect
		let velocity: CGVector
		let isSupported: Bool
	}

	struct Snapshot: Sendable {
		let player: PlayerSnapshot
		let crates: [CrateSnapshot]
		let state: State
	}

	enum Event: Sendable, Equatable {
		case crateLanded(id: Int)
		case linesCleared(count: Int)
		case playerKnockedOut
		case stackReachedTop
	}

	private struct Body {
		var id: Int
		var position: CGPoint
		var velocity: CGVector = .zero
		var size: CGSize
		var supported = false

		var frame: CGRect {
			CGRect(
				x: position.x - size.width / 2,
				y: position.y - size.height / 2,
				width: size.width,
				height: size.height
			)
		}
	}

	// MARK: - Properties

	private let configuration: Configuration
	private var player: Body
	private var crates: [Body] = []
	private var state: State = .playing
	private var events: [Event] = []
	private var nextID = 1
	private var leftHeld = false
	private var rightHeld = false
	private var jumpHeld = false
	private var pendingJump = false
	private var pushDirection: CGFloat = 0
	private var pressSerial: UInt64 = 0
	private var leftSerial: UInt64 = 0
	private var rightSerial: UInt64 = 0

	// MARK: - Init

	init(configuration: Configuration = .default, seed: UInt64 = 0) {
		self.configuration = configuration
		let start = Self.initialPlayerPosition(for: configuration)
		player = Body(id: 0, position: start, size: configuration.playerSize, supported: true)
		// Kept in the API so a future randomized spawner can remain deterministic.
		_ = seed
	}

	// MARK: - Computed properties

	var snapshot: Snapshot {
		Snapshot(
			player: PlayerSnapshot(
				frame: player.frame,
				velocity: player.velocity,
				isSupported: player.supported,
				pushDirection: pushDirection
			),
			crates: crates.map {
				CrateSnapshot(id: $0.id, frame: $0.frame, velocity: $0.velocity, isSupported: $0.supported)
			},
			state: state
		)
	}

	// MARK: - Public methods

	mutating func start() {
		crates.removeAll(keepingCapacity: true)
		events.removeAll(keepingCapacity: true)
		state = .playing
		nextID = 1
		leftHeld = false
		rightHeld = false
		jumpHeld = false
		pendingJump = false
		pushDirection = 0
		player.position = Self.initialPlayerPosition(for: configuration)
		player.velocity = .zero
		player.supported = true
	}

	mutating func setInput(_ control: Control, pressed: Bool) {
		guard state == .playing else { return }
		switch control {
		case .left:
			leftHeld = pressed
			if pressed {
				pressSerial &+= 1
				leftSerial = pressSerial
			}
		case .right:
			rightHeld = pressed
			if pressed {
				pressSerial &+= 1
				rightSerial = pressSerial
			}
		case .jump:
			if pressed && !jumpHeld { pendingJump = true }
			jumpHeld = pressed
		}
	}

	@discardableResult
	mutating func spawnCrate(x: CGFloat, y: CGFloat, velocity: CGVector = .zero) -> Int {
		let id = nextID
		nextID += 1
		crates.append(
			Body(
				id: id, position: CGPoint(x: x, y: y), velocity: velocity,
				size: configuration.crateSize))
		return id
	}

	mutating func drainEvents() -> [Event] {
		defer { events.removeAll(keepingCapacity: true) }
		return events
	}

	mutating func step(deltaTime: TimeInterval) {
		guard state == .playing, deltaTime > 0 else { return }
		var remaining = min(CGFloat(deltaTime), 0.1)
		var shouldResolveRows = false
		while remaining > 0, state == .playing {
			let dt = min(remaining, 1 / 120)
			shouldResolveRows = simulate(dt: dt) || shouldResolveRows
			remaining -= dt
		}
		if shouldResolveRows, state == .playing {
			clearCompleteRows()
		}
	}

	// MARK: - Simulation

	private var horizontalIntent: CGFloat {
		switch (leftHeld, rightHeld) {
		case (true, false): -1
		case (false, true): 1
		case (true, true): leftSerial > rightSerial ? -1 : 1
		default: 0
		}
	}

	private mutating func simulate(dt: CGFloat) -> Bool {
		var intent = horizontalIntent
		pushDirection = 0
		var shiftedUpperCrate = false
		if pendingJump, player.supported {
			if !tryShiftUpperCrate(direction: intent) {
				player.velocity.dy = configuration.jumpSpeed
				player.supported = false
			} else {
				shiftedUpperCrate = true
			}
		}
		pendingJump = false
		if shiftedUpperCrate {
			intent = 0
			player.velocity.dx = 0
		}

		let targetX: CGFloat
		if intent == 0, player.supported {
			let gridX = nearestGridX(to: player.position.x)
			let remainingDistance = gridX - player.position.x
			if abs(remainingDistance) < 0.1 {
				player.position.x = gridX
				targetX = 0
			} else {
				targetX = max(-configuration.runSpeed, min(configuration.runSpeed, remainingDistance * 7))
			}
		} else {
			targetX = intent * configuration.runSpeed
		}
		let acceleration =
			player.supported ? configuration.groundAcceleration : configuration.airAcceleration
		player.velocity.dx = approach(player.velocity.dx, targetX, by: acceleration * dt)
		player.velocity.dy -= configuration.gravity * dt

		for index in crates.indices where !crates[index].supported || crates[index].velocity.dy > 0 {
			crates[index].velocity.dy -= configuration.gravity * dt
		}

		let previousPlayer = player.frame
		let previousCrates = crates.map(\.frame)
		player.position.x += player.velocity.dx * dt
		player.position.y += player.velocity.dy * dt
		for index in crates.indices {
			crates[index].position.x += crates[index].velocity.dx * dt
			crates[index].position.y += crates[index].velocity.dy * dt
		}

		let landedCrate = resolveCrates(previousFrames: previousCrates, dt: dt)
		detectKnockout(previousPlayer: previousPlayer, previousCrates: previousCrates)
		guard state == .playing else { return landedCrate }
		resolvePlayer(previousFrame: previousPlayer, dt: dt)
		clampBodiesToPlayfield()
		return landedCrate
	}

	private mutating func resolveCrates(previousFrames: [CGRect], dt: CGFloat) -> Bool {
		let floor = configuration.playfield.minY
		let order = crates.indices.sorted { crates[$0].frame.minY < crates[$1].frame.minY }
		var landedCrate = false
		for index in order {
			let wasSupported = crates[index].supported
			crates[index].supported = false
			var supportY = floor
			for other in crates.indices where other != index {
				let a = crates[index].frame
				let b = crates[other].frame
				guard horizontalOverlap(a, b) > 0,
					previousFrames[index].minY >= previousFrames[other].maxY - 1,
					a.minY <= b.maxY
				else { continue }
				supportY = max(supportY, b.maxY)
			}
			if crates[index].frame.minY <= supportY, crates[index].velocity.dy <= 0 {
				crates[index].position.y = supportY + crates[index].size.height / 2
				crates[index].velocity.dy = 0
				crates[index].supported = true
				if !wasSupported {
					landedCrate = true
					events.append(.crateLanded(id: crates[index].id))
				}
				if crates[index].frame.maxY >= configuration.playfield.maxY - 0.5 {
					state = .gameOver
					leftHeld = false
					rightHeld = false
					jumpHeld = false
					pendingJump = false
					events.append(.stackReachedTop)
					return landedCrate
				}
			}
			if crates[index].supported {
				crates[index].velocity.dx = approach(
					crates[index].velocity.dx,
					0,
					by: configuration.groundAcceleration * dt
				)
				let gridX = nearestGridX(to: crates[index].position.x)
				if abs(crates[index].velocity.dx) < 0.1,
					crateCanOccupy(index: index, x: gridX) {
					crates[index].position.x = approach(
						crates[index].position.x,
						gridX,
						by: configuration.pushSpeed * dt
					)
				}
			}
		}
		return landedCrate
	}

	// MARK: - Collision resolution

	private mutating func detectKnockout(previousPlayer: CGRect, previousCrates: [CGRect]) {
		for index in crates.indices {
			let crate = crates[index]
			guard crate.velocity.dy < -40,
				horizontalOverlap(crate.frame, player.frame) > 0,
				previousCrates[index].minY >= previousPlayer.maxY - 1,
				crate.frame.minY <= player.frame.maxY
			else { continue }
			state = .knockedOut
			player.velocity = .zero
			leftHeld = false
			rightHeld = false
			jumpHeld = false
			pendingJump = false
			events.append(.playerKnockedOut)
			return
		}
	}

	private mutating func resolvePlayer(previousFrame: CGRect, dt: CGFloat) {
		let floor = configuration.playfield.minY
		player.supported = false
		if player.frame.minY <= floor, player.velocity.dy <= 0 {
			player.position.y = floor + player.size.height / 2
			player.velocity.dy = 0
			player.supported = true
		}

		for index in crates.indices {
			let crateFrame = crates[index].frame
			guard player.frame.intersects(crateFrame) else { continue }
			if previousFrame.maxY <= crateFrame.minY + 1, player.velocity.dy > 0,
				horizontalOverlap(player.frame, crateFrame) > player.size.width * 0.35 {
				player.position.y = crateFrame.minY - player.size.height / 2
				player.velocity.dy = 0
				continue
			}
			if previousFrame.minY >= crateFrame.maxY - 1, player.velocity.dy <= 0 {
				player.position.y = crateFrame.maxY + player.size.height / 2
				player.velocity.dy = 0
				player.supported = true
				continue
			}
			guard verticalOverlap(player.frame, crateFrame) > 2 else { continue }
			let movingRight = player.velocity.dx > 0 && previousFrame.maxX <= crateFrame.minX + 2
			let movingLeft = player.velocity.dx < 0 && previousFrame.minX >= crateFrame.maxX - 2
			if movingRight || movingLeft {
				let direction: CGFloat = movingRight ? 1 : -1
				var canPush = false
				if crates[index].supported, !hasCrateAbove(index) {
					let proposedX = crates[index].position.x + direction * configuration.pushSpeed / 120
					if crateCanOccupy(index: index, x: proposedX) {
						crates[index].velocity.dx = direction * configuration.pushSpeed
						canPush = true
					}
				}
				let targetPlayerX =
					direction > 0
					? crates[index].frame.minX - player.size.width / 2
					: crates[index].frame.maxX + player.size.width / 2
				if canPush {
					pushDirection = direction
					player.position.x = approach(
						player.position.x, targetPlayerX, by: configuration.pushSpeed * dt)
					player.velocity.dx = min(abs(player.velocity.dx), configuration.pushSpeed) * direction
				} else {
					player.position.x = targetPlayerX
					player.velocity.dx = 0
				}
			}
		}
	}

	private mutating func tryShiftUpperCrate(direction: CGFloat) -> Bool {
		guard direction != 0 else { return false }
		let interactionReach = configuration.crateSize.width * 0.3
		let probeX =
			direction > 0
			? player.frame.maxX + interactionReach
			: player.frame.minX - interactionReach
		guard
			let base = crates.indices.first(where: {
				crates[$0].frame.minX <= probeX && crates[$0].frame.maxX >= probeX
					&& verticalOverlap(crates[$0].frame, player.frame) > 4
			})
		else { return false }

		var stack = [base]
		var current = base
		while let above = crates.indices.first(where: {
			$0 != current
				&& horizontalOverlap(crates[$0].frame, crates[current].frame) > crates[$0].size.width * 0.4
				&& abs(crates[$0].frame.minY - crates[current].frame.maxY) < 3
		}) {
			stack.append(above)
			current = above
		}
		guard stack.count >= 2 else { return false }
		let top = stack[stack.index(before: stack.endIndex)]
		let proposedX = crates[top].position.x + direction * configuration.crateSize.width
		guard crateCanOccupy(index: top, x: proposedX) else { return false }
		crates[top].velocity.dx = direction * configuration.pushSpeed
		crates[top].supported = false
		return true
	}

	private func hasCrateAbove(_ index: Int) -> Bool {
		crates.indices.contains {
			$0 != index
				&& horizontalOverlap(crates[$0].frame, crates[index].frame) > crates[index].size.width * 0.4
				&& abs(crates[$0].frame.minY - crates[index].frame.maxY) < 3
		}
	}

	private func crateCanOccupy(index: Int, x: CGFloat) -> Bool {
		var frame = crates[index].frame
		frame.origin.x = x - frame.width / 2
		guard frame.minX >= configuration.playfield.minX,
			frame.maxX <= configuration.playfield.maxX
		else { return false }
		return !crates.indices.contains { $0 != index && frame.intersects(crates[$0].frame) }
	}

	// MARK: - Row resolution

	private mutating func clearCompleteRows() {
		let minX = configuration.playfield.minX
		let maxX = configuration.playfield.maxX
		var rowsToRemove = Set<Int>()
		var clearedRowLevels: [CGFloat] = []
		for candidate in crates.indices where crates[candidate].supported {
			let scanY = crates[candidate].position.y
			let row = crates.indices.filter {
				crates[$0].supported && crates[$0].frame.minY < scanY && crates[$0].frame.maxY > scanY
			}
			let intervals = row.map {
				(max(minX, crates[$0].frame.minX), min(maxX, crates[$0].frame.maxX))
			}
			.sorted { $0.0 < $1.0 }
			guard var covered = intervals.first, covered.0 <= minX + 1 else { continue }
			for interval in intervals.dropFirst() where interval.0 <= covered.1 + 1 {
				covered.1 = max(covered.1, interval.1)
			}
			if covered.1 >= maxX - 1 {
				rowsToRemove.formUnion(row)
				let level = crates[candidate].position.y
				if !clearedRowLevels.contains(where: {
					abs($0 - level) < configuration.crateSize.height * 0.25
				}) {
					clearedRowLevels.append(level)
				}
			}
		}
		guard !rowsToRemove.isEmpty else { return }
		crates = crates.enumerated().compactMap { rowsToRemove.contains($0.offset) ? nil : $0.element }
		events.append(.linesCleared(count: clearedRowLevels.count))
	}

	private mutating func clampBodiesToPlayfield() {
		let bounds = configuration.playfield
		player.position.x = min(
			max(player.position.x, bounds.minX + player.size.width / 2),
			bounds.maxX - player.size.width / 2
		)
		for index in crates.indices {
			crates[index].position.x = min(
				max(crates[index].position.x, bounds.minX + crates[index].size.width / 2),
			bounds.maxX - crates[index].size.width / 2)
		}
	}

	// MARK: - Helpers

	private func nearestGridX(to x: CGFloat) -> CGFloat {
		let cellWidth = configuration.crateSize.width
		let firstCenter = configuration.playfield.minX + cellWidth / 2
		let column = ((x - firstCenter) / cellWidth).rounded()
		let lastCenter = configuration.playfield.maxX - cellWidth / 2
		return min(max(firstCenter + column * cellWidth, firstCenter), lastCenter)
	}

	private static func initialPlayerPosition(for configuration: Configuration) -> CGPoint {
		CGPoint(
			x: nearestGridX(to: configuration.playfield.midX, configuration: configuration),
			y: configuration.playfield.minY + configuration.playerSize.height / 2
		)
	}

	private static func nearestGridX(to x: CGFloat, configuration: Configuration) -> CGFloat {
		let cellWidth = configuration.crateSize.width
		let firstCenter = configuration.playfield.minX + cellWidth / 2
		let column = ((x - firstCenter) / cellWidth).rounded()
		let lastCenter = configuration.playfield.maxX - cellWidth / 2
		return min(max(firstCenter + column * cellWidth, firstCenter), lastCenter)
	}

	private func approach(_ value: CGFloat, _ target: CGFloat, by amount: CGFloat) -> CGFloat {
		if value < target { return min(value + amount, target) }
		return max(value - amount, target)
	}

	private func horizontalOverlap(_ lhs: CGRect, _ rhs: CGRect) -> CGFloat {
		max(0, min(lhs.maxX, rhs.maxX) - max(lhs.minX, rhs.minX))
	}

	private func verticalOverlap(_ lhs: CGRect, _ rhs: CGRect) -> CGFloat {
		max(0, min(lhs.maxY, rhs.maxY) - max(lhs.minY, rhs.minY))
	}
}
