import SpriteKit
import UIKit

private struct PlayerSpritePalette {
	let hardHat: UIColor
	let hardHatHighlight: UIColor
	let skin: UIColor
	let uniform: UIColor
	let boots: UIColor
	let reflectiveStripe: UIColor
}

@MainActor
enum PlayerVisualRenderer {
	// MARK: - Rendering

	static func build(in playerNode: SKNode, appearance: PlayerAppearance) {
		playerNode.removeAllChildren()
		let palette = palette(for: appearance)
		let outline = UIColor(resource: .Scene.outline)

		ScenePrimitives.rect(
			playerNode, CGSize(width: 27, height: 3), outline.withAlphaComponent(0.5),
			CGPoint(x: 0, y: -24), 0
		)
		if appearance == .cyberLoader {
			ScenePrimitives.rect(
				playerNode, CGSize(width: 12, height: 18), outline, CGPoint(x: -14, y: -4), 1)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 8, height: 15), UIColor(resource: .Player.cyberDrone),
				CGPoint(x: -14, y: -4), 2
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 5, height: 9), UIColor(resource: .Player.cyberScreen),
				CGPoint(x: -14, y: -4), 3
			)
		}
		ScenePrimitives.rect(
			playerNode, CGSize(width: 10, height: 13), outline, CGPoint(x: -6, y: -17), 1)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 10, height: 13), outline, CGPoint(x: 6, y: -17), 1)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 7, height: 11), palette.uniform, CGPoint(x: -6, y: -17), 2)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 7, height: 11), palette.uniform, CGPoint(x: 6, y: -17), 2)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 12, height: 7), outline, CGPoint(x: -7, y: -22), 3)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 12, height: 7), outline, CGPoint(x: 7, y: -22), 3)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 10, height: 5), palette.boots, CGPoint(x: -7, y: -22), 4)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 10, height: 5), palette.boots, CGPoint(x: 7, y: -22), 4)

		ScenePrimitives.rectNamed(
			playerNode, "backArmOutline", CGSize(width: 8, height: 14), outline, CGPoint(x: -13, y: -7), 2
		)
		ScenePrimitives.rectNamed(
			playerNode, "frontArmOutline", CGSize(width: 8, height: 14), outline, CGPoint(x: 13, y: -7), 2
		)
		ScenePrimitives.rectNamed(
			playerNode, "backArm", CGSize(width: 6, height: 11), palette.uniform, CGPoint(x: -13, y: -7),
			3
		)
		ScenePrimitives.rectNamed(
			playerNode, "frontArm", CGSize(width: 6, height: 11), palette.uniform, CGPoint(x: 13, y: -7),
			3
		)
		ScenePrimitives.rectNamed(
			playerNode, "backHand", CGSize(width: 7, height: 6), palette.skin, CGPoint(x: -15, y: -13), 4
		)
		ScenePrimitives.rectNamed(
			playerNode, "frontHand", CGSize(width: 7, height: 6), palette.skin, CGPoint(x: 15, y: -13), 4
		)

		ScenePrimitives.rect(
			playerNode, CGSize(width: 23, height: 18), outline, CGPoint(x: 0, y: -7), 3)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 20, height: 15), palette.uniform, CGPoint(x: 0, y: -7), 4)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 8, height: 15), palette.hardHatHighlight, CGPoint(x: 0, y: -7), 5
		)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 8, height: 3), palette.reflectiveStripe, CGPoint(x: 0, y: -9), 6
		)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 3, height: 4), palette.reflectiveStripe, CGPoint(x: -6, y: -2), 6
		)

		ScenePrimitives.rect(playerNode, CGSize(width: 17, height: 14), outline, CGPoint(x: 0, y: 6), 5)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 14, height: 11), palette.skin, CGPoint(x: 0, y: 6), 6)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 3, height: 4), palette.skin, CGPoint(x: 9, y: 5), 6)
		ScenePrimitives.rect(playerNode, CGSize(width: 2, height: 2), outline, CGPoint(x: 4, y: 8), 7)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 3, height: 1), outline.withAlphaComponent(0.7), CGPoint(x: 4, y: 2),
			7
		)

		ScenePrimitives.rect(playerNode, CGSize(width: 23, height: 9), outline, CGPoint(x: 0, y: 15), 7)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 20, height: 7), palette.hardHat, CGPoint(x: 0, y: 15), 8)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 13, height: 3), palette.hardHatHighlight, CGPoint(x: 2, y: 18), 9
		)
		ScenePrimitives.rect(playerNode, CGSize(width: 18, height: 4), outline, CGPoint(x: 3, y: 11), 8)
		ScenePrimitives.rect(
			playerNode, CGSize(width: 16, height: 2), palette.hardHat, CGPoint(x: 3, y: 11), 9)

		if appearance == .cyberLoader {
			ScenePrimitives.rect(
				playerNode, CGSize(width: 19, height: 12), UIColor(resource: .Player.cyberVisor),
				CGPoint(x: -3, y: 8), 5
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 7, height: 23), UIColor(resource: .Player.cyberAntenna),
				CGPoint(x: -12, y: 1), 4
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 5, height: 16), UIColor(resource: .Player.cyberAntennaGlow),
				CGPoint(x: -14, y: -3), 5
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 14, height: 5), UIColor(resource: .Player.cyberDrone),
				CGPoint(x: 0, y: -12), 7
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 9, height: 2), UIColor(resource: .Player.cyberDroneLight),
				CGPoint(x: 0, y: -14), 8
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 14, height: 4), UIColor(resource: .Player.cyberScreen),
				CGPoint(x: 0, y: 7), 10
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 8, height: 1), UIColor(resource: .Theme.white),
				CGPoint(x: 1, y: 7), 11
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 2, height: 7), outline, CGPoint(x: -8, y: 22), 9)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 4, height: 4), UIColor(resource: .Theme.signalLime),
				CGPoint(x: -8, y: 25), 10
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 5, height: 12), outline, CGPoint(x: -9, y: 3), 8)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 3, height: 10), UIColor(resource: .Player.cyberDroneArm),
				CGPoint(x: -9, y: 3), 9
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 5, height: 8), outline, CGPoint(x: -11, y: -2), 8)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 3, height: 6), UIColor(resource: .Player.cyberDroneArm),
				CGPoint(x: -11, y: -2), 9
			)
			ScenePrimitives.circle(
				playerNode, radius: 1.8, fill: UIColor(resource: .Theme.signalLime),
				position: CGPoint(x: 9, y: 1), z: 10
			)
		}
		playerNode.zPosition = 20
	}

	// MARK: - Animation

	static func updatePose(
		playerNode: SKNode,
		player: GameWorld.PlayerSnapshot,
		jumpSquashRemaining: CGFloat,
		jumpLiftRemaining: CGFloat
	) {
		let isPushing = player.pushDirection != 0
		let isJumping = jumpLiftRemaining > 0 || (!player.isSupported && player.velocity.dy > 0)
		let crouch = jumpSquashRemaining > 0
		let frontX: CGFloat = isPushing ? 17 : 13
		let backX: CGFloat = isPushing ? 10 : -13
		let armY: CGFloat = isJumping ? 7 : (crouch ? -11 : -7)
		let handY: CGFloat = isJumping ? 14 : (crouch ? -17 : -13)
		let armHeight: CGFloat = isJumping ? 20 : (isPushing ? 11 : 14)

		for (name, x) in [
			("frontArmOutline", frontX), ("frontArm", frontX), ("frontHand", frontX + 2),
			("backArmOutline", backX), ("backArm", backX), ("backHand", backX + 2),
		] {
			guard let node = playerNode.childNode(withName: name) as? SKSpriteNode else { continue }
			node.position.x = x
			if name.contains("Hand") {
				node.position.y = handY
			} else {
				node.position.y = armY
				node.size.height = armHeight
			}
		}
	}

	// MARK: - Private methods

	private static func palette(for appearance: PlayerAppearance) -> PlayerSpritePalette {
		switch appearance {
		case .loader:
			PlayerSpritePalette(
				hardHat: UIColor(resource: .Player.loaderHardHat),
				hardHatHighlight: UIColor(resource: .Theme.warningGold),
				skin: UIColor(resource: .Player.loaderSkin),
				uniform: UIColor(resource: .Player.loaderUniform),
				boots: UIColor(resource: .Player.loaderBoots),
				reflectiveStripe: UIColor(resource: .Player.loaderReflector)
			)
		case .nightLoader:
			PlayerSpritePalette(
				hardHat: UIColor(resource: .Player.nightHardHat),
				hardHatHighlight: UIColor(resource: .Player.nightHardHatHighlight),
				skin: UIColor(resource: .Player.nightSkin),
				uniform: UIColor(resource: .Player.nightUniform),
				boots: UIColor(resource: .Player.nightBoots),
				reflectiveStripe: UIColor(resource: .Theme.signalLime)
			)
		case .veteranLoader:
			PlayerSpritePalette(
				hardHat: UIColor(resource: .Player.veteranHardHat),
				hardHatHighlight: UIColor(resource: .Player.veteranHardHatHighlight),
				skin: UIColor(resource: .Player.veteranSkin),
				uniform: UIColor(resource: .Player.veteranUniform),
				boots: UIColor(resource: .Player.veteranBoots),
				reflectiveStripe: UIColor(resource: .Cargo.strap)
			)
		case .cyberLoader:
			PlayerSpritePalette(
				hardHat: UIColor(resource: .Player.cyberHardHat),
				hardHatHighlight: UIColor(resource: .Player.cyberHardHatHighlight),
				skin: UIColor(resource: .Player.cyberSkin),
				uniform: UIColor(resource: .Player.cyberUniform),
				boots: UIColor(resource: .Player.cyberBoots),
				reflectiveStripe: UIColor(resource: .Theme.signalLime)
			)
		}
	}
}
