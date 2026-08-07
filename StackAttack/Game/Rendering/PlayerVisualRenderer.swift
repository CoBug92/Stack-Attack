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

private struct ArmPose {
	let armX: CGFloat
	let armY: CGFloat
	let armHeight: CGFloat
	let handX: CGFloat
	let handY: CGFloat
}

private struct PlayerPose {
	let frontArm: ArmPose
	let backArm: ArmPose
}

@MainActor
enum PlayerVisualRenderer {
	private static let outline = GamePalette.Scene.outline
	private static let warningGold = GamePalette.Theme.warningGold
	private static let white = GamePalette.Theme.white
	private static let signalLime = GamePalette.Theme.signalLime
	private static let cyberDrone = UIColor.Player.cyberDrone
	private static let cyberScreen = UIColor.Player.cyberScreen
	private static let cyberVisor = UIColor.Player.cyberVisor
	private static let cyberAntenna = UIColor.Player.cyberAntenna
	private static let cyberAntennaGlow = UIColor.Player.cyberAntennaGlow
	private static let cyberDroneLight = UIColor.Player.cyberDroneLight
	private static let cyberDroneArm = UIColor.Player.cyberDroneArm

	// MARK: - Rendering

	static func build(in playerNode: SKNode, appearance: PlayerAppearance) {
		playerNode.removeAllChildren()
		let palette = palette(for: appearance)

		ScenePrimitives.rect(
			playerNode, CGSize(width: 27, height: 3), outline.withAlphaComponent(0.5),
			CGPoint(x: 0, y: -24), 0
		)
		if appearance == .cyberLoader {
			ScenePrimitives.rect(
				playerNode, CGSize(width: 12, height: 18), outline, CGPoint(x: -14, y: -4), 1)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 8, height: 15), cyberDrone,
				CGPoint(x: -14, y: -4), 2
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 5, height: 9), cyberScreen,
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
				playerNode, CGSize(width: 19, height: 12), cyberVisor,
				CGPoint(x: -3, y: 8), 5
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 7, height: 23), cyberAntenna,
				CGPoint(x: -12, y: 1), 4
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 5, height: 16), cyberAntennaGlow,
				CGPoint(x: -14, y: -3), 5
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 14, height: 5), cyberDrone,
				CGPoint(x: 0, y: -12), 7
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 9, height: 2), cyberDroneLight,
				CGPoint(x: 0, y: -14), 8
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 14, height: 4), cyberScreen,
				CGPoint(x: 0, y: 7), 10
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 8, height: 1), white,
				CGPoint(x: 1, y: 7), 11
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 2, height: 7), outline, CGPoint(x: -8, y: 22), 9)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 4, height: 4), signalLime,
				CGPoint(x: -8, y: 25), 10
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 5, height: 12), outline, CGPoint(x: -9, y: 3), 8)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 3, height: 10), cyberDroneArm,
				CGPoint(x: -9, y: 3), 9
			)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 5, height: 8), outline, CGPoint(x: -11, y: -2), 8)
			ScenePrimitives.rect(
				playerNode, CGSize(width: 3, height: 6), cyberDroneArm,
				CGPoint(x: -11, y: -2), 9
			)
			ScenePrimitives.circle(
				playerNode, radius: 1.8, fill: signalLime,
				position: CGPoint(x: 9, y: 1), z: 10
			)
		}
		playerNode.zPosition = 20
	}

	// MARK: - Animation

	static func updatePose(
		playerNode: SKNode,
		player: GameWorld.PlayerSnapshot,
		isPushing: Bool,
		jumpSquashRemaining: CGFloat,
		jumpLiftRemaining: CGFloat
	) {
		let isTakeoff = jumpSquashRemaining > 0 && player.isSupported
		let isJumping = jumpLiftRemaining > 0 || !player.isSupported
		let pose = pose(isTakeoff: isTakeoff, isJumping: isJumping, isPushing: isPushing)

		applyArmPose(
			pose.frontArm,
			outlineName: "frontArmOutline",
			armName: "frontArm",
			handName: "frontHand",
			in: playerNode
		)
		applyArmPose(
			pose.backArm,
			outlineName: "backArmOutline",
			armName: "backArm",
			handName: "backHand",
			in: playerNode
		)
	}

	// MARK: - Private methods

	private static func palette(for appearance: PlayerAppearance) -> PlayerSpritePalette {
		switch appearance {
		case .loader:
			PlayerSpritePalette(
				hardHat: UIColor.Player.loaderHardHat,
				hardHatHighlight: warningGold,
				skin: UIColor.Player.loaderSkin,
				uniform: UIColor.Player.loaderUniform,
				boots: UIColor.Player.loaderBoots,
				reflectiveStripe: UIColor.Player.loaderReflectiveStripe
			)
		case .nightLoader:
			PlayerSpritePalette(
				hardHat: UIColor.Player.nightLoaderHardHat,
				hardHatHighlight: UIColor.Player.nightLoaderHardHatHighlight,
				skin: UIColor.Player.nightLoaderSkin,
				uniform: UIColor.Player.nightLoaderUniform,
				boots: UIColor.Player.nightLoaderBoots,
				reflectiveStripe: signalLime
			)
		case .veteranLoader:
			PlayerSpritePalette(
				hardHat: UIColor.Player.veteranLoaderHardHat,
				hardHatHighlight: UIColor.Player.veteranLoaderHardHatHighlight,
				skin: UIColor.Player.veteranLoaderSkin,
				uniform: UIColor.Player.veteranLoaderUniform,
				boots: UIColor.Player.veteranLoaderBoots,
				reflectiveStripe: UIColor.Player.veteranLoaderReflectiveStripe
			)
		case .cyberLoader:
			PlayerSpritePalette(
				hardHat: UIColor.Player.cyberLoaderHardHat,
				hardHatHighlight: UIColor.Player.cyberLoaderHardHatHighlight,
				skin: UIColor.Player.cyberLoaderSkin,
				uniform: UIColor.Player.cyberLoaderUniform,
				boots: UIColor.Player.cyberLoaderBoots,
				reflectiveStripe: signalLime
			)
		}
	}

	private static func pose(
		isTakeoff: Bool,
		isJumping: Bool,
		isPushing: Bool
	) -> PlayerPose {
		if isTakeoff {
			return PlayerPose(
				frontArm: ArmPose(armX: 11, armY: -11, armHeight: 12, handX: 13, handY: -17),
				backArm: ArmPose(armX: -11, armY: -11, armHeight: 12, handX: -13, handY: -17)
			)
		}
		if isPushing {
			return PlayerPose(
				frontArm: ArmPose(armX: 18, armY: -5, armHeight: 15, handX: 21, handY: -10),
				backArm: ArmPose(armX: 11, armY: -4, armHeight: 15, handX: 15, handY: -8)
			)
		}
		if isJumping {
			return PlayerPose(
				frontArm: ArmPose(armX: 8, armY: 4, armHeight: 16, handX: 10, handY: 12),
				backArm: ArmPose(armX: -8, armY: 4, armHeight: 16, handX: -10, handY: 12)
			)
		}
		return PlayerPose(
			frontArm: ArmPose(armX: 13, armY: -7, armHeight: 14, handX: 15, handY: -13),
			backArm: ArmPose(armX: -13, armY: -7, armHeight: 14, handX: -15, handY: -13)
		)
	}

	private static func applyArmPose(
		_ pose: ArmPose,
		outlineName: String,
		armName: String,
		handName: String,
		in playerNode: SKNode
	) {
		guard
			let outlineNode = playerNode.childNode(withName: outlineName) as? SKSpriteNode,
			let armNode = playerNode.childNode(withName: armName) as? SKSpriteNode,
			let handNode = playerNode.childNode(withName: handName) as? SKSpriteNode
		else { return }

		for node in [outlineNode, armNode] {
			node.position = CGPoint(x: pose.armX, y: pose.armY)
			node.size.height = pose.armHeight
		}
		handNode.position = CGPoint(x: pose.handX, y: pose.handY)
	}

}
