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
	private static let outline = color(0.0902, 0.1451, 0.2078)
	private static let warningGold = color(0.9490, 0.7216, 0.2941)
	private static let white = color(1, 1, 1)
	private static let signalLime = color(0.8471, 1, 0.4471)
	private static let cyberDrone = color(0.3490, 0.2392, 0.6039)
	private static let cyberScreen = color(0.9882, 0.8784, 0.9451)
	private static let cyberVisor = color(0.1529, 0.1059, 0.2980)
	private static let cyberAntenna = color(0.2118, 0.1294, 0.3725)
	private static let cyberAntennaGlow = color(0.6627, 0.3882, 1)
	private static let cyberDroneLight = color(0.9412, 0.3569, 0.9373)
	private static let cyberDroneArm = color(0.3843, 0.1686, 0.4039)

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
				hardHat: color(0.8431, 0.6667, 0.2627),
				hardHatHighlight: warningGold,
				skin: color(0.8471, 0.6314, 0.4941),
				uniform: color(0.8431, 0.3725, 0.2627),
				boots: color(0.3804, 0.4902, 0.2627),
				reflectiveStripe: color(0.9569, 0.8980, 0.5490)
			)
		case .nightLoader:
			PlayerSpritePalette(
				hardHat: color(0.3059, 0.7176, 0.8549),
				hardHatHighlight: color(0.5529, 0.8824, 0.8549),
				skin: color(0.7216, 0.4784, 0.3765),
				uniform: color(0.2431, 0.3059, 0.5255),
				boots: color(0.1529, 0.1922, 0.2627),
				reflectiveStripe: signalLime
			)
		case .veteranLoader:
			PlayerSpritePalette(
				hardHat: color(0.7216, 0.4275, 0.1961),
				hardHatHighlight: color(0.8745, 0.6824, 0.2706),
				skin: color(0.5529, 0.3608, 0.2588),
				uniform: color(0.3804, 0.4863, 0.3059),
				boots: color(0.2157, 0.2275, 0.2118),
				reflectiveStripe: color(0.9255, 0.5569, 0.2118)
			)
		case .cyberLoader:
			PlayerSpritePalette(
				hardHat: color(0.3647, 0.3020, 0.6392),
				hardHatHighlight: color(0.5804, 0.4902, 0.8745),
				skin: color(0.7255, 0.4980, 0.4118),
				uniform: color(0.1608, 0.2196, 0.3529),
				boots: color(0.0941, 0.1333, 0.1961),
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

	private static func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
		UIColor(red: red, green: green, blue: blue, alpha: 1)
	}
}
