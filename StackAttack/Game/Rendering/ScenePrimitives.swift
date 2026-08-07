import SpriteKit
import UIKit

enum GamePalette {
	enum Theme {
		static let clearSprite = UIColor.Theme.clearSprite
		static let signalLime = UIColor.Theme.signalLime
		static let warningGold = UIColor.Theme.warningGold
		static let white = UIColor.Theme.white
	}

	enum Scene {
		static let backdrop = UIColor.Scene.backdrop
		static let groundEdge = UIColor.Scene.groundEdge
		static let hudLabel = UIColor.Scene.hudLabel
		static let outline = UIColor.Scene.outline
		static let particleDust = UIColor.Scene.particleDust
	}

	enum Cargo {
		static let crateBlue = UIColor.Cargo.crateBlue
		static let crateCoral = UIColor.Cargo.crateCoral
		static let crateRose = UIColor.Cargo.crateRose
		static let crateTeal = UIColor.Cargo.crateTeal
		static let label = UIColor.Cargo.label
		static let labelLines = UIColor.Cargo.labelLines
		static let metal = UIColor.Cargo.metal
		static let stamp = UIColor.Cargo.stamp
		static let stampHighlight = UIColor.Cargo.stampHighlight
		static let strap = UIColor.Cargo.strap
	}

	enum Delivery {
		static let magneticGlow = UIColor.Delivery.magneticGlow
	}

	enum Background {
		static let cityBuilding = UIColor.Background.cityBuilding
		static let cityBuildingLight = UIColor.Background.cityBuildingLight
		static let cityGlow = UIColor.Background.cityGlow
		static let cityHorizon = UIColor.Background.cityHorizon
		static let cityNeonPink = UIColor.Background.cityNeonPink
		static let cityRain = UIColor.Background.cityRain
		static let citySky = UIColor.Background.citySky
		static let cityWindow = UIColor.Background.cityWindow
		static let cyberGlow = UIColor.Background.cyberGlow
		static let cyberHorizon = UIColor.Background.cyberHorizon
		static let cyberMoon = UIColor.Background.cyberMoon
		static let cyberRidge = UIColor.Background.cyberRidge
		static let cyberRidgeDark = UIColor.Background.cyberRidgeDark
		static let cyberRidgeLight = UIColor.Background.cyberRidgeLight
		static let cyberSky = UIColor.Background.cyberSky
		static let portBuilding = UIColor.Background.portBuilding
		static let portBuildingLight = UIColor.Background.portBuildingLight
		static let portHorizon = UIColor.Background.portHorizon
		static let portLight = UIColor.Background.portLight
		static let portSky = UIColor.Background.portSky
		static let portWater = UIColor.Background.portWater
		static let portWindow = UIColor.Background.portWindow
		static let sunsetCrane = UIColor.Background.sunsetCrane
		static let sunsetCraneCool = UIColor.Background.sunsetCraneCool
		static let sunsetCraneWarm = UIColor.Background.sunsetCraneWarm
		static let sunsetForeground = UIColor.Background.sunsetForeground
		static let sunsetGlow = UIColor.Background.sunsetGlow
		static let sunsetHorizon = UIColor.Background.sunsetHorizon
		static let sunsetLamp = UIColor.Background.sunsetLamp
		static let sunsetReflection = UIColor.Background.sunsetReflection
		static let sunsetRidgeDark = UIColor.Background.sunsetRidgeDark
		static let sunsetRidgeHighlight = UIColor.Background.sunsetRidgeHighlight
		static let sunsetRidgeLight = UIColor.Background.sunsetRidgeLight
		static let sunsetRidgeMid = UIColor.Background.sunsetRidgeMid
		static let sunsetSky = UIColor.Background.sunsetSky
		static let sunsetStructure = UIColor.Background.sunsetStructure
		static let sunsetStructureLight = UIColor.Background.sunsetStructureLight
		static let sunsetWater = UIColor.Background.sunsetWater
		static let warehouseBeam = UIColor.Background.warehouseBeam
		static let warehouseColumn = UIColor.Background.warehouseColumn
		static let warehouseFloor = UIColor.Background.warehouseFloor
		static let warehouseFloorMark = UIColor.Background.warehouseFloorMark
		static let warehouseLight = UIColor.Background.warehouseLight
		static let warehouseSky = UIColor.Background.warehouseSky
		static let warehouseWall = UIColor.Background.warehouseWall
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
