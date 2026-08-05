import CoreGraphics
@testable import StackAttack
import XCTest

final class GameWorldTests: XCTestCase {
	// MARK: - Tests

	func testPlayerStartsOnNearestCrateColumn() {
		let world = GameWorld()
		let config = GameWorld.Configuration.default
		let firstCenter = config.playfield.minX + config.crateSize.width / 2
		let midpointColumn = ((config.playfield.midX - firstCenter) / config.crateSize.width).rounded()
		let expectedX = firstCenter + midpointColumn * config.crateSize.width
		XCTAssertEqual(world.snapshot.player.frame.midX, expectedX, accuracy: 0.001)
	}

	func testMovementIsContinuousAndLastPressedDirectionWins() {
		var world = GameWorld()
		let startX = world.snapshot.player.frame.midX
		world.setInput(.left, pressed: true)
		world.setInput(.right, pressed: true)
		world.step(deltaTime: 0.05)
		XCTAssertGreaterThan(world.snapshot.player.frame.midX, startX)
		XCTAssertNotEqual(world.snapshot.player.frame.midX.rounded(), world.snapshot.player.frame.midX)
		world.setInput(.left, pressed: true)
		world.step(deltaTime: 0.1)
		XCTAssertLessThan(world.snapshot.player.velocity.dx, 0)
	}

	func testJumpWorksWithoutTouchingACrateAndHasAirControl() {
		var world = GameWorld()
		world.setInput(.jump, pressed: true)
		world.setInput(.right, pressed: true)
		world.step(deltaTime: 0.05)
		XCTAssertGreaterThan(world.snapshot.player.velocity.dy, 0)
		XCTAssertGreaterThan(world.snapshot.player.velocity.dx, 0)
		XCTAssertFalse(world.snapshot.player.isSupported)
	}

	func testFallingCrateKnocksPlayerOutButSideContactDoesNot() {
		var falling = GameWorld()
		let player = falling.snapshot.player.frame
		falling.spawnCrate(x: player.midX, y: player.maxY + 30, velocity: CGVector(dx: 0, dy: -300))
		falling.step(deltaTime: 0.1)
		XCTAssertEqual(falling.snapshot.state, .knockedOut)
		XCTAssertTrue(falling.drainEvents().contains(.playerKnockedOut))

		var side = GameWorld()
		let sidePlayer = side.snapshot.player.frame
		side.spawnCrate(x: sidePlayer.maxX + 19, y: sidePlayer.midY, velocity: CGVector(dx: -200, dy: 0))
		side.step(deltaTime: 0.03)
		XCTAssertEqual(side.snapshot.state, .playing)
	}

	func testSingleGroundedCrateCanBePushedContinuously() throws {
		var config = GameWorld.Configuration.default
		config.playfield = CGRect(x: 0, y: 0, width: 240, height: 400)
		var world = GameWorld(configuration: config)
		let player = world.snapshot.player.frame
		let id = world.spawnCrate(x: player.maxX + config.crateSize.width / 2 + 1,
								y: config.crateSize.height / 2)
		world.step(deltaTime: 0.01)
		let startCrate = try XCTUnwrap(world.snapshot.crates.first { $0.id == id })
		world.setInput(.right, pressed: true)
		world.step(deltaTime: 0.1)
		let pushedCrate = try XCTUnwrap(world.snapshot.crates.first { $0.id == id })
		XCTAssertGreaterThan(pushedCrate.frame.midX, startCrate.frame.midX)
	}

	func testCoverageClearsRowWithoutGridCoordinates() {
		var config = GameWorld.Configuration.default
		config.playfield = CGRect(x: 3.5, y: 0, width: 120, height: 300)
		config.crateSize = CGSize(width: 40.2, height: 40)
		var world = GameWorld(configuration: config)
		for x in [23.5, 63.5, 103.5] {
			world.spawnCrate(x: x, y: 20)
		}
		world.step(deltaTime: 0.01)
		XCTAssertTrue(world.snapshot.crates.isEmpty)
		XCTAssertTrue(world.drainEvents().contains(.linesCleared(count: 1)))
	}

	func testJumpTowardStackMovesTopCrateInsteadOfBottomCrate() throws {
		var config = GameWorld.Configuration.default
		config.playfield = CGRect(x: 0, y: 0, width: 300, height: 400)
		var world = GameWorld(configuration: config)
		let player = world.snapshot.player.frame
		let crateX = player.midX + config.crateSize.width
		let bottomID = world.spawnCrate(x: crateX, y: config.crateSize.height / 2)
		let topID = world.spawnCrate(x: crateX, y: config.crateSize.height * 1.5)
		world.step(deltaTime: 0.01)
		let bottomStart = try XCTUnwrap(world.snapshot.crates.first { $0.id == bottomID })
		let topStart = try XCTUnwrap(world.snapshot.crates.first { $0.id == topID })

		world.setInput(.jump, pressed: true)
		world.setInput(.right, pressed: true)
		world.step(deltaTime: 0.05)

		let bottomEnd = try XCTUnwrap(world.snapshot.crates.first { $0.id == bottomID })
		let topEnd = try XCTUnwrap(world.snapshot.crates.first { $0.id == topID })
		XCTAssertEqual(bottomEnd.frame.midX, bottomStart.frame.midX, accuracy: 0.001)
		XCTAssertGreaterThan(topEnd.frame.midX, topStart.frame.midX)
		XCTAssertLessThanOrEqual(world.snapshot.player.velocity.dy, 0)
	}
}
