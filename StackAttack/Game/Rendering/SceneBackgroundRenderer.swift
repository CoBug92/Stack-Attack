import SpriteKit
import UIKit

@MainActor
enum SceneBackgroundRenderer {
	// MARK: - Public methods

	static func buildRail(on railLayer: SKNode, size: CGSize, railY: CGFloat) {
		railLayer.removeAllChildren()
		ScenePrimitives.rect(
			railLayer,
			CGSize(width: size.width, height: 18),
			UIColor(resource: .Background.portSky),
			CGPoint(x: size.width / 2, y: railY + 2),
			1
		)
		ScenePrimitives.rect(
			railLayer,
			CGSize(width: size.width, height: 10),
			UIColor(resource: .Background.portHorizon),
			CGPoint(x: size.width / 2, y: railY + 4),
			2
		)
		ScenePrimitives.rect(
			railLayer,
			CGSize(width: size.width, height: 3),
			UIColor(resource: .Background.portWater),
			CGPoint(x: size.width / 2, y: railY + 7),
			3
		)
		ScenePrimitives.line(
			railLayer,
			from: CGPoint(x: 0, y: railY + 11),
			to: CGPoint(x: size.width, y: railY + 11),
			color: UIColor(resource: .Background.portLight).withAlphaComponent(0.5),
			width: 1.5,
			z: 4
		)
		for x in stride(from: CGFloat(18), through: size.width - 18, by: 46) {
			ScenePrimitives.rect(
				railLayer,
				CGSize(width: 6, height: 18),
				UIColor(resource: .Background.portBuilding),
				CGPoint(x: x, y: railY + 2),
				2
			)
			ScenePrimitives.rect(
				railLayer,
				CGSize(width: 2, height: 18),
				UIColor(resource: .Background.portBuildingLight),
				CGPoint(x: x, y: railY + 2),
				3
			)
			if Int(x).isMultiple(of: 92) {
				ScenePrimitives.circle(
					railLayer,
					radius: 2.3,
					fill: UIColor(resource: .Background.portWindow),
					position: CGPoint(x: x, y: railY - 4),
					z: 5
				)
			}
		}
		railLayer.zPosition = 8
	}

	static func buildBackground(
		on backgroundLayer: SKNode,
		size: CGSize,
		appearance: BackgroundAppearance
	) {
		backgroundLayer.removeAllChildren()
		let center = CGPoint(x: size.width / 2, y: size.height / 2)
		switch appearance {
		case .port:
			buildPort(on: backgroundLayer, size: size, center: center)
		case .nightWarehouse:
			buildNightWarehouse(on: backgroundLayer, size: size, center: center)
		case .sunsetYard:
			buildSunsetYard(on: backgroundLayer, size: size, center: center)
		case .cyberCity:
			buildCyberCity(on: backgroundLayer, size: size, center: center)
		}
	}

	// MARK: - Private methods

	private static func buildPort(on layer: SKNode, size: CGSize, center: CGPoint) {
		ScenePrimitives.rect(layer, size, UIColor(resource: .Background.sunsetSky), center, -30)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 210), UIColor(resource: .Background.sunsetHorizon),
			CGPoint(x: center.x, y: 535), -29)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 140), UIColor(resource: .Background.sunsetWater),
			CGPoint(x: center.x, y: 468), -28)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 84),
			UIColor(resource: .Background.sunsetGlow).withAlphaComponent(0.4),
			CGPoint(x: center.x, y: 420), -27)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 100),
			UIColor(resource: .Background.sunsetForeground),
			CGPoint(x: center.x, y: 120), -26)
		ScenePrimitives.line(
			layer, from: CGPoint(x: 0, y: 165), to: CGPoint(x: size.width, y: 165),
			color: UIColor(resource: .Background.sunsetReflection).withAlphaComponent(0.35), width: 1,
			z: -25)
		for x in stride(from: CGFloat(30), through: size.width - 40, by: 94) {
			let stackHeight = CGFloat(40 + (Int(x) % 3) * 18)
			ScenePrimitives.rect(
				layer, CGSize(width: 60, height: stackHeight), UIColor(resource: .Background.sunsetCrane),
				CGPoint(x: x, y: 185 + stackHeight / 2), -24)
			ScenePrimitives.rect(
				layer, CGSize(width: 54, height: 14), UIColor(resource: .Background.sunsetCraneWarm),
				CGPoint(x: x, y: 177 + stackHeight), -23)
			ScenePrimitives.rect(
				layer, CGSize(width: 54, height: 14), UIColor(resource: .Background.sunsetCraneCool),
				CGPoint(x: x, y: 161 + stackHeight), -23)
		}
		for x in [58, 190, 338, 432] as [CGFloat] {
			ScenePrimitives.line(
				layer, from: CGPoint(x: x, y: 195), to: CGPoint(x: x, y: 470),
				color: UIColor(resource: .Background.sunsetRidgeDark), width: 6, z: -22)
			ScenePrimitives.line(
				layer, from: CGPoint(x: x, y: 458), to: CGPoint(x: x + 48, y: 500),
				color: UIColor(resource: .Background.sunsetRidgeMid), width: 5, z: -22)
			ScenePrimitives.line(
				layer, from: CGPoint(x: x + 48, y: 500), to: CGPoint(x: x + 84, y: 500),
				color: UIColor(resource: .Background.sunsetRidgeLight), width: 3, z: -21)
			ScenePrimitives.line(
				layer, from: CGPoint(x: x + 48, y: 500), to: CGPoint(x: x + 48, y: 365),
				color: UIColor(resource: .Background.sunsetRidgeHighlight), width: 2, z: -21)
			ScenePrimitives.circle(
				layer, radius: 3, fill: UIColor(resource: .Background.sunsetLamp),
				position: CGPoint(x: x + 84, y: 500), z: -20)
		}
		ScenePrimitives.roundedRect(
			layer, CGSize(width: 164, height: 32), UIColor(resource: .Background.sunsetStructure),
			CGPoint(x: 332, y: 150), cornerRadius: 6, z: -24)
		for offset in stride(from: CGFloat(-70), through: 70, by: 22) {
			ScenePrimitives.line(
				layer, from: CGPoint(x: 332 + offset, y: 135), to: CGPoint(x: 332 + offset * 0.84, y: 105),
				color: UIColor(resource: .Background.sunsetStructureLight).withAlphaComponent(0.35),
				width: 2, z: -25
			)
		}
	}

	private static func buildNightWarehouse(on layer: SKNode, size: CGSize, center: CGPoint) {
		ScenePrimitives.rect(layer, size, UIColor(resource: .Background.warehouseSky), center, -30)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 230), UIColor(resource: .Background.warehouseWall),
			CGPoint(x: center.x, y: 525), -29)
		for x in stride(from: CGFloat(26), through: size.width - 26, by: 86) {
			ScenePrimitives.rect(
				layer, CGSize(width: 8, height: 460), UIColor(resource: .Background.warehouseColumn),
				CGPoint(x: x, y: 294), -27)
			ScenePrimitives.rect(
				layer, CGSize(width: 8, height: 460), UIColor(resource: .Background.warehouseColumn),
				CGPoint(x: x + 48, y: 294), -27)
			for y in stride(from: CGFloat(164), through: 502, by: 84) {
				ScenePrimitives.rect(
					layer, CGSize(width: 70, height: 6), UIColor(resource: .Background.warehouseBeam),
					CGPoint(x: x + 24, y: y), -26)
			}
			ScenePrimitives.roundedRect(
				layer, CGSize(width: 26, height: 10),
				UIColor(resource: .Background.warehouseLight).withAlphaComponent(0.16),
				CGPoint(x: x + 24, y: 535), cornerRadius: 4, z: -25)
			ScenePrimitives.line(
				layer, from: CGPoint(x: x + 24, y: 530), to: CGPoint(x: x + 24, y: 438),
				color: UIColor(resource: .Background.warehouseLight).withAlphaComponent(0.12), width: 1.5,
				z: -25
			)
		}
		let floor = SKShapeNode(
			path: {
				let path = CGMutablePath()
				path.move(to: CGPoint(x: 0, y: 66))
				path.addLine(to: CGPoint(x: size.width, y: 66))
				path.addLine(to: CGPoint(x: size.width, y: 0))
				path.addLine(to: CGPoint(x: 0, y: 0))
				path.closeSubpath()
				return path
			}())
		floor.fillColor = UIColor(resource: .Background.warehouseFloor)
		floor.strokeColor = UIColor(resource: .Theme.clearSprite)
		floor.zPosition = -24
		layer.addChild(floor)
		for x in stride(from: CGFloat(-10), through: size.width + 40, by: 54) {
			ScenePrimitives.line(
				layer, from: CGPoint(x: x, y: 66), to: CGPoint(x: x + 36, y: 0),
				color: UIColor(resource: .Background.warehouseFloorMark).withAlphaComponent(0.14), width: 1,
				z: -23
			)
		}
	}

	private static func buildSunsetYard(on layer: SKNode, size: CGSize, center: CGPoint) {
		ScenePrimitives.rect(layer, size, UIColor(resource: .Background.cyberSky), center, -30)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 230), UIColor(resource: .Background.cyberHorizon),
			CGPoint(x: center.x, y: 520), -29)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 160),
			UIColor(resource: .Background.cyberGlow).withAlphaComponent(0.7),
			CGPoint(x: center.x, y: 462), -28)
		ScenePrimitives.circle(
			layer, radius: 58, fill: UIColor(resource: .Background.cyberMoon),
			position: CGPoint(x: 378, y: 490), z: -27)
		let ridge = SKShapeNode(
			path: {
				let path = CGMutablePath()
				path.move(to: CGPoint(x: 0, y: 350))
				path.addLine(to: CGPoint(x: 96, y: 410))
				path.addLine(to: CGPoint(x: 160, y: 378))
				path.addLine(to: CGPoint(x: 250, y: 430))
				path.addLine(to: CGPoint(x: 360, y: 376))
				path.addLine(to: CGPoint(x: 480, y: 420))
				path.addLine(to: CGPoint(x: 480, y: 0))
				path.addLine(to: CGPoint(x: 0, y: 0))
				path.closeSubpath()
				return path
			}())
		ridge.fillColor = UIColor(resource: .Background.cyberRidge)
		ridge.strokeColor = UIColor(resource: .Theme.clearSprite)
		ridge.zPosition = -26
		layer.addChild(ridge)
		for x in [40, 150, 286, 398] as [CGFloat] {
			ScenePrimitives.line(
				layer, from: CGPoint(x: x, y: 180), to: CGPoint(x: x, y: 452),
				color: UIColor(resource: .Background.cyberRidgeDark), width: 5, z: -25)
			ScenePrimitives.line(
				layer, from: CGPoint(x: x, y: 448), to: CGPoint(x: x + 62, y: 486),
				color: UIColor(resource: .Background.cyberRidgeLight), width: 4, z: -24)
		}
	}

	private static func buildCyberCity(on layer: SKNode, size: CGSize, center: CGPoint) {
		ScenePrimitives.rect(layer, size, UIColor(resource: .Background.citySky), center, -30)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 260), UIColor(resource: .Background.cityHorizon),
			CGPoint(x: center.x, y: 510), -29)
		ScenePrimitives.rect(
			layer, CGSize(width: size.width, height: 100),
			UIColor(resource: .Background.cityGlow).withAlphaComponent(0.25),
			CGPoint(x: center.x, y: 430), -28)
		for (index, x) in stride(from: CGFloat(22), through: 470, by: 42).enumerated() {
			let height = CGFloat(110 + (index % 4) * 45)
			ScenePrimitives.rect(
				layer, CGSize(width: 28, height: height), UIColor(resource: .Background.cityBuilding),
				CGPoint(x: x, y: 390 + height / 2), -27)
			ScenePrimitives.rect(
				layer, CGSize(width: 20, height: height - 12),
				UIColor(resource: .Background.cityBuildingLight),
				CGPoint(x: x, y: 390 + height / 2 - 4), -26)
			for y in stride(from: CGFloat(346), through: 390 + height - 18, by: 16) {
				let light =
					index.isMultiple(of: 2)
					? UIColor(resource: .Delivery.magneticGlow)
					: UIColor(resource: .Background.cityNeonPink)
				ScenePrimitives.rect(
					layer, CGSize(width: 11, height: 2), light.withAlphaComponent(0.75),
					CGPoint(x: x, y: y), -25)
			}
			if index.isMultiple(of: 3) {
				ScenePrimitives.roundedRect(
					layer, CGSize(width: 18, height: 8), UIColor(resource: .Background.cityWindow),
					CGPoint(x: x, y: 410 + height), cornerRadius: 2, z: -24)
				ScenePrimitives.rect(
					layer, CGSize(width: 14, height: 3), UIColor(resource: .Theme.signalLime),
					CGPoint(x: x, y: 410 + height), -23)
			}
		}
		for x in stride(from: CGFloat(24), through: 460, by: 32) {
			ScenePrimitives.line(
				layer, from: CGPoint(x: x, y: 640), to: CGPoint(x: x - 28, y: 360),
				color: UIColor(resource: .Background.cityRain).withAlphaComponent(0.08), width: 1, z: -22)
		}
	}
}
