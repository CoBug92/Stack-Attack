import SpriteKit
import UIKit

@MainActor
final class GameScene: SKScene {
	// MARK: - Nested types

	private enum Metrics {
		static let field = CGRect(x: 0, y: 48, width: 480, height: 528)
		static let cratesPerRow = 10
		static let playerSize = CGSize(width: 28, height: 42)
		static let crateSize = CGSize(width: field.width / CGFloat(cratesPerRow), height: 48)
		static let craneY: CGFloat = 608
		static let craneSpeed: CGFloat = 150
		static let payloadOffset: CGFloat = 53
		static let jumpSquashDuration: CGFloat = 0.06
		static let jumpLiftPoseDuration: CGFloat = 0.18
		static let pushPoseHoldDuration: CGFloat = 0.1
	}

	private enum Direction: CGFloat {
		case right = 1
		case left = -1
		var reversed: Direction { self == .right ? .left : .right }
	}

	private enum CraneState {
		case offscreen(TimeInterval, Direction)
		case entering(Direction, CGFloat)
		case dropping(Direction)
		case exiting(Direction)
	}

	// MARK: - Properties

	private weak var controller: GameController?
	private var world = GameWorld(
		configuration: .init(
			playfield: Metrics.field,
			playerSize: Metrics.playerSize,
			crateSize: Metrics.crateSize,
			gravity: 1_500,
			runSpeed: 150,
			groundAcceleration: 1_400,
			airAcceleration: 650,
			jumpSpeed: 430,
			pushSpeed: 115
		))
	private var lastUpdateTime: TimeInterval = 0
	private var craneStates: [CraneState] = []
	private var crateNodes: [Int: SKNode] = [:]
	private var cranePayloads: [SKNode?] = []
	private var nextSpawnedCrateID = 1
	private var isBuilt = false
	private var isKnockoutAnimating = false
	private var lastPlayerDirection: Direction = .right
	private var jumpSquashRemaining: CGFloat = 0
	private var jumpLiftRemaining: CGFloat = 0
	private var pushPoseRemaining: CGFloat = 0

	private let worldLayer = SKNode()
	private let backgroundLayer = SKNode()
	private let railLayer = SKNode()
	private let crateLayer = SKNode()
	private let effectsLayer = SKNode()
	private var craneNodes: [SKNode] = []
	private let playerNode = SKNode()
	private let craneMoveActionKey = "craneMove"
	private let colors: [UIColor] = [
		GamePalette.Cargo.crateCoral, GamePalette.Theme.warningGold, GamePalette.Cargo.crateTeal,
		GamePalette.Cargo.crateBlue, GamePalette.Cargo.crateRose,
	]

	// MARK: - Init

	init(size: CGSize, controller: GameController) {
		self.controller = controller
		super.init(size: size)
		backgroundColor = GamePalette.Scene.backdrop
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

	// MARK: - Overrides

	override func didMove(to view: SKView) {
		guard !isBuilt else { return }
		isBuilt = true
		view.ignoresSiblingOrder = true
		buildScene()
		render(world.snapshot)
	}

	// MARK: - Public methods

	func startNewGame() {
		world.start()
		clearInput()
		resetTiming()
		isKnockoutAnimating = false
		jumpSquashRemaining = 0
		jumpLiftRemaining = 0
		pushPoseRemaining = 0
		playerNode.removeAllActions()
		playerNode.alpha = 1
		playerNode.setScale(1)
		lastPlayerDirection = .right
		effectsLayer.removeAllChildren()
		crateLayer.removeAllChildren()
		crateNodes.removeAll(keepingCapacity: true)
		nextSpawnedCrateID = 1
		resetCrane()
		worldLayer.speed = 1
		render(world.snapshot)
	}

	func clearInput() {
		world.setInput(.left, pressed: false)
		world.setInput(.right, pressed: false)
		world.setInput(.jump, pressed: false)
	}

	func resetTiming() {
		lastUpdateTime = 0
		worldLayer.speed = 1
	}

	func setDirection(_ direction: Int, isPressed: Bool) {
		guard direction != 0 else { return }
		world.setInput(direction < 0 ? .left : .right, pressed: isPressed)
		if isPressed {
			lastPlayerDirection = direction < 0 ? .left : .right
			playerNode.xScale = lastPlayerDirection.rawValue
		}
	}

	func pressJump() {
		if world.snapshot.player.isSupported {
			jumpSquashRemaining = Metrics.jumpSquashDuration
			jumpLiftRemaining = Metrics.jumpLiftPoseDuration
		}
		world.setInput(.jump, pressed: true)
		world.setInput(.jump, pressed: false)
	}

	func setAppearances(
		player: PlayerAppearance,
		manipulator: ManipulatorAppearance,
		background: BackgroundAppearance
	) {
		guard isBuilt else { return }
		buildBackground(background)
		buildRail()
		buildPlayer(player)
		rebuildDeliveryVisuals()
	}

	override func update(_ currentTime: TimeInterval) {
		guard let controller else { return }
		guard controller.phase == .playing else {
			worldLayer.speed = controller.phase == .knockedOut ? 1 : 0
			lastUpdateTime = currentTime
			return
		}
		worldLayer.speed = 1
		let delta = lastUpdateTime == 0 ? 0 : min(0.05, currentTime - lastUpdateTime)
		lastUpdateTime = currentTime
		guard delta > 0 else { return }
		jumpSquashRemaining = max(0, jumpSquashRemaining - CGFloat(delta))
		jumpLiftRemaining = max(0, jumpLiftRemaining - CGFloat(delta))
		pushPoseRemaining = max(0, pushPoseRemaining - CGFloat(delta))
		updateCrane(delta)
		world.step(deltaTime: delta)
		handle(world.drainEvents())
		render(world.snapshot)
	}

	// MARK: - Scene building

	private func buildScene() {
		addChild(backgroundLayer)
		addChild(railLayer)
		buildBackground(controller?.selectedBackgroundAppearance ?? .port)
		buildRail()
		ScenePrimitives.rect(
			self,
			CGSize(width: size.width, height: 7),
			GamePalette.Scene.groundEdge,
			CGPoint(x: size.width / 2, y: 44.5),
			4
		)
		ScenePrimitives.rect(
			self,
			CGSize(width: size.width, height: 41),
			GamePalette.Scene.outline,
			CGPoint(x: size.width / 2, y: 20.5),
			-5
		)
		addChild(worldLayer)
		worldLayer.addChild(crateLayer)
		worldLayer.addChild(effectsLayer)
		ensureCraneCount(1)
		buildPlayer(controller?.selectedPlayerAppearance ?? .loader)
		let lines = label(hudLines(0), .left)
		lines.name = "linesLabel"
		lines.position = CGPoint(x: 20, y: 14)
		addChild(lines)
		let speed = label(hudSpeed(1), .right)
		speed.name = "speedLabel"
		speed.position = CGPoint(x: 460, y: 14)
		addChild(speed)
	}

	// MARK: - Crane

	private func ensureCraneCount(_ count: Int) {
		while craneNodes.count < count {
			let index = craneNodes.count
			let craneNode = SKNode()
			worldLayer.addChild(craneNode)
			buildDeliveryVisual(in: craneNode)
			craneNode.zPosition = 10
			let direction: Direction = index.isMultiple(of: 2) ? .right : .left
			craneNode.position = CGPoint(x: offscreen(direction), y: craneY(for: index))
			craneNodes.append(craneNode)
			cranePayloads.append(nil)
			craneStates.append(.offscreen(initialDelay(for: index), direction))
		}
	}

	private var usesDroneDelivery: Bool {
		controller?.selectedManipulatorAppearance == .drone
	}

	private var usesMagneticManipulator: Bool {
		controller?.selectedManipulatorAppearance == .magnetic
	}

	private func buildRail() {
		SceneBackgroundRenderer.buildRail(on: railLayer, size: size, railY: Metrics.craneY + 29)
	}

	private func buildBackground(_ appearance: BackgroundAppearance) {
		SceneBackgroundRenderer.buildBackground(on: backgroundLayer, size: size, appearance: appearance)
	}

	private func rebuildDeliveryVisuals() {
		for (index, craneNode) in craneNodes.enumerated() {
			let payload = cranePayloads[index]
			payload?.removeFromParent()
			craneNode.removeAllChildren()
			buildDeliveryVisual(in: craneNode)
			if let payload {
				payload.position = CGPoint(x: 0, y: -Metrics.payloadOffset)
				craneNode.addChild(payload)
			}
		}
	}

	private func buildDeliveryVisual(in carrier: SKNode) {
		DeliveryVisualRenderer.build(
			in: carrier, usesDrone: usesDroneDelivery, usesMagnetic: usesMagneticManipulator)
	}

	private func buildPlayer(_ appearance: PlayerAppearance) {
		PlayerVisualRenderer.build(in: playerNode, appearance: appearance)
		if playerNode.parent == nil { worldLayer.addChild(playerNode) }
	}

	private func resetCrane() {
		ensureCraneCount(controller?.level ?? 1)
		for index in craneNodes.indices {
			cranePayloads[index]?.removeFromParent()
			cranePayloads[index] = nil
			craneNodes[index].removeAction(forKey: craneMoveActionKey)
			let direction: Direction = (index == 0 || Bool.random()) ? .right : .left
			craneNodes[index].position = CGPoint(x: offscreen(direction), y: craneY(for: index))
			craneStates[index] = .offscreen(initialDelay(for: index), direction)
		}
	}

	private func updateCrane(_ deltaTime: TimeInterval) {
		ensureCraneCount(controller?.level ?? 1)
		let activeCraneCount = controller?.level ?? 1
		for index in craneNodes.indices {
			guard index < activeCraneCount else {
				cranePayloads[index]?.removeFromParent()
				cranePayloads[index] = nil
				craneNodes[index].removeAction(forKey: craneMoveActionKey)
				craneNodes[index].position = CGPoint(x: -120, y: craneY(for: index))
				continue
			}
			switch craneStates[index] {
			case .offscreen(let delay, let direction):
				if delay > deltaTime {
					craneStates[index] = .offscreen(delay - deltaTime, direction)
				} else {
					beginPass(index: index, direction: direction)
				}
			case .entering(let direction, let dropX):
				let didReachDrop =
					craneNodes[index].action(forKey: craneMoveActionKey) == nil
					|| abs(craneNodes[index].position.x - dropX) <= 0.5
				if didReachDrop {
					craneNodes[index].position.x = dropX
					craneStates[index] = .dropping(direction)
				}
			case .dropping(let direction):
				releasePayload(from: index)
				let exitX = direction == .right ? size.width + 64 : -64
				moveCrane(index: index, to: exitX)
				craneStates[index] = .exiting(direction)
			case .exiting(let direction):
				let didExit = craneNodes[index].action(forKey: craneMoveActionKey) == nil
				if didExit {
					let next = direction.reversed
					craneNodes[index].position.x = offscreen(next)
					let baseDelay = max(0.28, 0.78 - Double(controller?.level ?? 1) * 0.025)
					craneStates[index] = .offscreen(baseDelay + Double(index) * 0.18, next)
				}
			}
		}
	}

	private func beginPass(index: Int, direction: Direction) {
		craneNodes[index].position.x = offscreen(direction)
		let payload = makeCrate(colors[(nextSpawnedCrateID - 1) % colors.count])
		payload.position = CGPoint(x: 0, y: -Metrics.payloadOffset)
		craneNodes[index].addChild(payload)
		cranePayloads[index] = payload
		let dropX = chooseDropX()
		moveCrane(index: index, to: dropX)
		craneStates[index] = .entering(direction, dropX)
	}

	private func releasePayload(from index: Int) {
		guard let payload = cranePayloads[index] else { return }
		let position = payload.convert(CGPoint(x: 0, y: 0), to: worldLayer)
		payload.removeFromParent()
		cranePayloads[index] = nil
		let snappedX = nearestGridX(to: position.x)
		_ = world.spawnCrate(x: snappedX, y: position.y)
		nextSpawnedCrateID += 1
	}

	private func offscreen(_ direction: Direction) -> CGFloat {
		direction == .right ? -64 : size.width + 64
	}

	// MARK: - Events and rendering

	private func handle(_ events: [GameWorld.Event]) {
		for event in events {
			switch event {
			case .crateLanded(let id):
				controller?.registerBox()
				if let crate = world.snapshot.crates.first(where: { $0.id == id }) {
					dust(CGPoint(x: crate.frame.midX, y: crate.frame.minY))
				}
			case .linesCleared(let count):
				controller?.registerClearedLines(count)
			case .playerKnockedOut:
				knockout()
			case .stackReachedTop:
				controller?.endGame()
			}
		}
	}

	private func render(_ snapshot: GameWorld.Snapshot) {
		let ids = Set(snapshot.crates.map(\.id))
		let obsoleteIDs = crateNodes.keys.filter { !ids.contains($0) }
		for id in obsoleteIDs {
			crateNodes.removeValue(forKey: id)?.removeFromParent()
		}
		for crate in snapshot.crates {
			let node = crateNodes[crate.id] ?? makeCrate(colors[(crate.id - 1) % colors.count])
			if crateNodes[crate.id] == nil {
				crateLayer.addChild(node)
				crateNodes[crate.id] = node
			}
			node.position = CGPoint(x: crate.frame.midX, y: crate.frame.midY)
		}
		playerNode.position = CGPoint(x: snapshot.player.frame.midX, y: snapshot.player.frame.midY)
		if snapshot.player.isSupported, snapshot.player.pushDirection != 0 {
			pushPoseRemaining = Metrics.pushPoseHoldDuration
		}
		if !isKnockoutAnimating {
			playerNode.xScale = lastPlayerDirection.rawValue
			updatePlayerAnimation(snapshot.player)
		}
		(childNode(withName: "linesLabel") as? SKLabelNode)?.text =
			hudLines(controller?.clearedLines ?? 0)
		(childNode(withName: "speedLabel") as? SKLabelNode)?.text =
			hudSpeed(controller?.level ?? 1)
	}

	// MARK: - Animation

	private func knockout() {
		guard !isKnockoutAnimating else { return }
		isKnockoutAnimating = true
		controller?.beginKnockout()
		clearInput()
		playerNode.removeAllActions()
		for offset in -1...1 {
			let star = label("✦", .center)
			star.fontSize = 13
			star.fontColor = GamePalette.Theme.warningGold
			star.position = CGPoint(
				x: playerNode.position.x + CGFloat(offset * 15), y: playerNode.position.y + 31)
			effectsLayer.addChild(star)
			let orbit = SKAction.group([
				.moveBy(x: CGFloat(offset * 8), y: 12, duration: 0.72),
				.rotate(byAngle: .pi * 2, duration: 0.72),
			])
			star.run(.sequence([orbit, .fadeOut(withDuration: 0.25), .removeFromParent()]))
		}
		let direction: CGFloat = playerNode.xScale < 0 ? -1 : 1
		let faint = SKAction.group([
			.rotate(byAngle: direction * 1.1, duration: 0.2),
			.moveBy(x: direction * 6, y: -9, duration: 0.2),
			.fadeAlpha(to: 0.72, duration: 0.18),
		])
		let settle = SKAction.wait(forDuration: 0.34)
		playerNode.run(.sequence([faint, settle])) { [weak self] in
			guard let self, self.controller?.phase == .knockedOut else { return }
			self.playerNode.alpha = 1
			self.isKnockoutAnimating = false
			self.controller?.finishKnockout()
		}
	}

	private func hudLines(_ count: Int) -> String {
		String(format: "РЯДЫ %02d", count)
	}

	private func hudSpeed(_ count: Int) -> String {
		String(format: "СКОРОСТЬ %02d", count)
	}

	// MARK: - Helpers

	private func makeCrate(_ color: UIColor) -> SKNode {
		CargoVisualRenderer.makeCrate(side: Metrics.crateSize.width, color: color)
	}

	private func updatePlayerAnimation(_ player: GameWorld.PlayerSnapshot) {
		updatePlayerPose(player)
		playerNode.yScale = 1
		playerNode.zRotation = 0
	}

	private func moveCrane(index: Int, to targetX: CGFloat) {
		let craneNode = craneNodes[index]
		craneNode.removeAction(forKey: craneMoveActionKey)
		let distance = abs(targetX - craneNode.position.x)
		guard distance > 0 else { return }
		let duration = TimeInterval(distance / Metrics.craneSpeed)
		craneNode.run(.moveTo(x: targetX, duration: duration), withKey: craneMoveActionKey)
	}

	private func updatePlayerPose(_ player: GameWorld.PlayerSnapshot) {
		PlayerVisualRenderer.updatePose(
			playerNode: playerNode,
			player: player,
			isPushing: pushPoseRemaining > 0 && player.isSupported,
			jumpSquashRemaining: jumpSquashRemaining,
			jumpLiftRemaining: jumpLiftRemaining
		)
	}

	private func nearestGridX(to x: CGFloat) -> CGFloat {
		let cellWidth = Metrics.crateSize.width
		let firstCenter = Metrics.field.minX + cellWidth / 2
		let column = ((x - firstCenter) / cellWidth).rounded()
		let lastCenter = Metrics.field.maxX - cellWidth / 2
		return min(max(firstCenter + column * cellWidth, firstCenter), lastCenter)
	}

	private func chooseDropX() -> CGFloat {
		let centers = stride(
			from: Metrics.field.minX + Metrics.crateSize.width / 2,
			through: Metrics.field.maxX - Metrics.crateSize.width / 2,
			by: Metrics.crateSize.width
		).map { $0 }
		let crates = world.snapshot.crates
		let scored = centers.map { center -> (x: CGFloat, score: CGFloat, count: Int) in
			let columnCrates = crates.filter {
				abs($0.frame.midX - center) < Metrics.crateSize.width * 0.35
			}
			let top = columnCrates.map(\.frame.maxY).max() ?? Metrics.field.minY
			return (center, top, columnCrates.count)
		}
		let bestScore = scored.map(\.score).min() ?? Metrics.field.minY
		let relaxedColumns = scored.filter { $0.score <= bestScore + Metrics.crateSize.height * 1.5 }
		let lightestCount = relaxedColumns.map(\.count).min() ?? 0
		let candidateColumns = relaxedColumns.filter { $0.count <= lightestCount + 1 }
		return candidateColumns.randomElement()?.x
			?? relaxedColumns.randomElement()?.x
			?? scored.randomElement()?.x
			?? Metrics.field.midX
	}

	private func craneY(for index: Int) -> CGFloat {
		_ = index
		return Metrics.craneY
	}

	private func initialDelay(for index: Int) -> TimeInterval {
		0.65 + Double(index) * 0.18
	}

	private func dust(_ origin: CGPoint) {
		for _ in 0..<5 {
			let p = SKSpriteNode(
				color: GamePalette.Scene.particleDust, size: CGSize(width: 3, height: 3))
			p.position = origin
			effectsLayer.addChild(p)
			let movement = SKAction.group([
				.moveBy(x: CGFloat.random(in: -20...20), y: 20, duration: 0.22),
				.fadeOut(withDuration: 0.22),
			])
			p.run(.sequence([movement, .removeFromParent()]))
		}
	}

	private func label(_ text: String, _ alignment: SKLabelHorizontalAlignmentMode) -> SKLabelNode {
		let node = SKLabelNode(fontNamed: "Menlo-Bold")
		node.text = text
		node.fontSize = 9
		node.fontColor = GamePalette.Scene.hudLabel
		node.horizontalAlignmentMode = alignment
		node.verticalAlignmentMode = .center
		return node
	}
}
