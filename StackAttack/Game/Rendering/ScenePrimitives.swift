import SpriteKit
import UIKit

enum GamePalette {
	enum Theme {
		static let clearSprite = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
		static let signalLime = UIColor(red: 0.8471, green: 1, blue: 0.4471, alpha: 1)
		static let warningGold = UIColor(red: 0.9490, green: 0.7216, blue: 0.2941, alpha: 1)
		static let white = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
	}

	enum Scene {
		static let backdrop = UIColor(red: 0.0510, green: 0.0902, blue: 0.1373, alpha: 1)
		static let groundEdge = UIColor(red: 0.5490, green: 0.6392, blue: 0.6000, alpha: 1)
		static let hudLabel = UIColor(red: 0.4706, green: 0.5647, blue: 0.5373, alpha: 1)
		static let outline = UIColor(red: 0.0902, green: 0.1451, blue: 0.2078, alpha: 1)
		static let particleDust = UIColor(red: 0.7137, green: 0.7843, blue: 0.7412, alpha: 1)
	}

	enum Cargo {
		static let crateBlue = UIColor(red: 0.5333, green: 0.6588, blue: 0.7804, alpha: 1)
		static let crateCoral = UIColor(red: 0.9490, green: 0.4745, blue: 0.2745, alpha: 1)
		static let crateRose = UIColor(red: 0.8196, green: 0.4196, blue: 0.4471, alpha: 1)
		static let crateTeal = UIColor(red: 0.4588, green: 0.7098, blue: 0.6039, alpha: 1)
		static let label = UIColor(red: 0.9255, green: 0.8941, blue: 0.7647, alpha: 1)
		static let labelLines = UIColor(red: 0.4078, green: 0.4510, blue: 0.4824, alpha: 1)
		static let metal = UIColor(red: 0.7882, green: 0.8275, blue: 0.8314, alpha: 1)
		static let stamp = UIColor(red: 0.7216, green: 0.2941, blue: 0.2118, alpha: 1)
		static let stampHighlight = UIColor(red: 1, green: 0.8784, blue: 0.6510, alpha: 1)
		static let strap = UIColor(red: 0.9059, green: 0.8314, blue: 0.6275, alpha: 1)
	}

	enum Delivery {
		static let magneticGlow = UIColor(red: 0.3725, green: 0.9098, blue: 1, alpha: 1)
	}

	enum Background {
		static let cityBuilding = UIColor(red: 0.0863, green: 0.1412, blue: 0.2706, alpha: 1)
		static let cityBuildingLight = UIColor(red: 0.1333, green: 0.2078, blue: 0.3922, alpha: 1)
		static let cityGlow = UIColor(red: 0.4314, green: 0.1725, blue: 0.4902, alpha: 1)
		static let cityHorizon = UIColor(red: 0.0863, green: 0.1098, blue: 0.2314, alpha: 1)
		static let cityNeonPink = UIColor(red: 1, green: 0.3529, blue: 0.8510, alpha: 1)
		static let cityRain = UIColor(red: 0.7176, green: 0.8314, blue: 1, alpha: 1)
		static let citySky = UIColor(red: 0.0353, green: 0.0431, blue: 0.0941, alpha: 1)
		static let cityWindow = UIColor(red: 0.0627, green: 0.0863, blue: 0.1647, alpha: 1)
		static let cyberGlow = UIColor(red: 0.8784, green: 0.4784, blue: 0.3373, alpha: 1)
		static let cyberHorizon = UIColor(red: 0.3686, green: 0.1922, blue: 0.3294, alpha: 1)
		static let cyberMoon = UIColor(red: 1, green: 0.8275, blue: 0.4196, alpha: 1)
		static let cyberRidge = UIColor(red: 0.2039, green: 0.1529, blue: 0.2314, alpha: 1)
		static let cyberRidgeDark = UIColor(red: 0.2745, green: 0.2039, blue: 0.2549, alpha: 1)
		static let cyberRidgeLight = UIColor(red: 0.4863, green: 0.3608, blue: 0.3294, alpha: 1)
		static let cyberSky = UIColor(red: 0.1412, green: 0.0902, blue: 0.1686, alpha: 1)
		static let portBuilding = UIColor(red: 0.1294, green: 0.2235, blue: 0.2824, alpha: 1)
		static let portBuildingLight = UIColor(red: 0.2824, green: 0.4431, blue: 0.5137, alpha: 1)
		static let portHorizon = UIColor(red: 0.1059, green: 0.1765, blue: 0.2431, alpha: 1)
		static let portLight = UIColor(red: 0.7216, green: 0.9059, blue: 0.9490, alpha: 1)
		static let portSky = UIColor(red: 0.0353, green: 0.0745, blue: 0.1098, alpha: 1)
		static let portWater = UIColor(red: 0.4941, green: 0.6667, blue: 0.7137, alpha: 1)
		static let portWindow = UIColor(red: 1, green: 0.4784, blue: 0.3294, alpha: 1)
		static let sunsetCrane = UIColor(red: 0.0902, green: 0.1961, blue: 0.2667, alpha: 1)
		static let sunsetCraneCool = UIColor(red: 0.2471, green: 0.4118, blue: 0.4902, alpha: 1)
		static let sunsetCraneWarm = UIColor(red: 0.7294, green: 0.4157, blue: 0.2314, alpha: 1)
		static let sunsetForeground = UIColor(red: 0.0392, green: 0.1255, blue: 0.1922, alpha: 1)
		static let sunsetGlow = UIColor(red: 0.8980, green: 0.5804, blue: 0.3412, alpha: 1)
		static let sunsetHorizon = UIColor(red: 0.0627, green: 0.1882, blue: 0.2941, alpha: 1)
		static let sunsetLamp = UIColor(red: 1, green: 0.7137, blue: 0.4196, alpha: 1)
		static let sunsetReflection = UIColor(red: 0.4824, green: 0.7686, blue: 0.8588, alpha: 1)
		static let sunsetRidgeDark = UIColor(red: 0.0941, green: 0.2078, blue: 0.2863, alpha: 1)
		static let sunsetRidgeHighlight = UIColor(red: 0.2000, green: 0.3647, blue: 0.4431, alpha: 1)
		static let sunsetRidgeLight = UIColor(red: 0.3098, green: 0.4902, blue: 0.5647, alpha: 1)
		static let sunsetRidgeMid = UIColor(red: 0.1490, green: 0.3059, blue: 0.3882, alpha: 1)
		static let sunsetSky = UIColor(red: 0.0314, green: 0.0824, blue: 0.1294, alpha: 1)
		static let sunsetStructure = UIColor(red: 0.0627, green: 0.1451, blue: 0.2039, alpha: 1)
		static let sunsetStructureLight = UIColor(red: 0.1725, green: 0.3725, blue: 0.4627, alpha: 1)
		static let sunsetWater = UIColor(red: 0.1412, green: 0.3098, blue: 0.4157, alpha: 1)
		static let warehouseBeam = UIColor(red: 0.2235, green: 0.3412, blue: 0.4039, alpha: 1)
		static let warehouseColumn = UIColor(red: 0.1216, green: 0.2078, blue: 0.2588, alpha: 1)
		static let warehouseFloor = UIColor(red: 0.0392, green: 0.0863, blue: 0.1294, alpha: 1)
		static let warehouseFloorMark = UIColor(red: 0.4549, green: 0.6471, blue: 0.7216, alpha: 1)
		static let warehouseLight = UIColor(red: 0.8431, green: 0.8980, blue: 0.9294, alpha: 1)
		static let warehouseSky = UIColor(red: 0.0275, green: 0.0627, blue: 0.0980, alpha: 1)
		static let warehouseWall = UIColor(red: 0.0549, green: 0.1059, blue: 0.1608, alpha: 1)
	}
}

@MainActor
enum ScenePrimitives {
	// MARK: - Drawing

	static func rect(
		_ parent: SKNode, _ size: CGSize, _ color: UIColor, _ position: CGPoint, _ z: CGFloat
	) {
		let node = SKSpriteNode(color: color, size: size)
		node.position = position
		node.zPosition = z
		parent.addChild(node)
	}

	static func rectNamed(
		_ parent: SKNode,
		_ name: String,
		_ size: CGSize,
		_ color: UIColor,
		_ position: CGPoint,
		_ z: CGFloat
	) {
		let node = SKSpriteNode(color: color, size: size)
		node.name = name
		node.position = position
		node.zPosition = z
		parent.addChild(node)
	}

	static func roundedRect(
		_ parent: SKNode,
		_ size: CGSize,
		_ fill: UIColor,
		_ position: CGPoint,
		cornerRadius: CGFloat,
		z: CGFloat,
		stroke: UIColor? = nil,
		lineWidth: CGFloat = 0
	) {
		let path = UIBezierPath(
			roundedRect: CGRect(
				x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height),
			cornerRadius: cornerRadius
		).cgPath
		let node = SKShapeNode(path: path)
		node.fillColor = fill
		node.strokeColor = stroke ?? GamePalette.Theme.clearSprite
		node.lineWidth = lineWidth
		node.position = position
		node.zPosition = z
		parent.addChild(node)
	}

	static func circle(
		_ parent: SKNode,
		radius: CGFloat,
		fill: UIColor,
		position: CGPoint,
		z: CGFloat,
		stroke: UIColor? = nil,
		lineWidth: CGFloat = 0
	) {
		let node = SKShapeNode(circleOfRadius: radius)
		node.fillColor = fill
		node.strokeColor = stroke ?? GamePalette.Theme.clearSprite
		node.lineWidth = lineWidth
		node.position = position
		node.zPosition = z
		parent.addChild(node)
	}

	static func line(
		_ parent: SKNode,
		from start: CGPoint,
		to end: CGPoint,
		color: UIColor,
		width: CGFloat,
		z: CGFloat
	) {
		let path = CGMutablePath()
		path.move(to: start)
		path.addLine(to: end)
		let node = SKShapeNode(path: path)
		node.strokeColor = color
		node.lineWidth = width
		node.lineCap = .round
		node.zPosition = z
		parent.addChild(node)
	}
}
