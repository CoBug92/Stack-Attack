import SpriteKit
import UIKit

@MainActor
enum DeliveryVisualRenderer {
	// MARK: - Rendering

	static func build(in carrier: SKNode, usesDrone: Bool, usesMagnetic: Bool) {
		let outline = UIColor(resource: .Scene.outline)
		if usesDrone {
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 46, height: 16), outline,
				CGPoint(x: 0, y: 13), cornerRadius: 7, z: 3)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 38, height: 12), UIColor(resource: .Delivery.droneBody),
				CGPoint(x: 0, y: 13), cornerRadius: 6, z: 4)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 17, height: 6), UIColor(resource: .Delivery.droneWindow),
				CGPoint(x: 0, y: 13), cornerRadius: 3, z: 5)
			ScenePrimitives.rect(
				carrier, CGSize(width: 8, height: 4), UIColor(resource: .Theme.signalLime),
				CGPoint(x: 11, y: 13), 6
			)
			for x in [-22, 22] as [CGFloat] {
				ScenePrimitives.line(
					carrier, from: CGPoint(x: x * 0.55, y: 14), to: CGPoint(x: x, y: 22),
					color: UIColor(resource: .Delivery.droneStrut), width: 4, z: 3)
				ScenePrimitives.circle(
					carrier, radius: 7.5, fill: UIColor(resource: .Delivery.droneRotor),
					position: CGPoint(x: x, y: 22), z: 4,
					stroke: UIColor(resource: .Delivery.droneRotorRing), lineWidth: 1.5)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: x - 8, y: 22), to: CGPoint(x: x + 8, y: 22),
					color: UIColor(resource: .Delivery.droneRotorHighlight).withAlphaComponent(0.55),
					width: 1.2, z: 5
				)
			}
			ScenePrimitives.line(
				carrier, from: CGPoint(x: -7, y: 5), to: CGPoint(x: -2, y: -38),
				color: UIColor(resource: .Delivery.droneCable), width: 1.5, z: 2)
			ScenePrimitives.line(
				carrier, from: CGPoint(x: 7, y: 5), to: CGPoint(x: 2, y: -38),
				color: UIColor(resource: .Delivery.droneCable), width: 1.5, z: 2)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 18, height: 10), outline,
				CGPoint(x: 0, y: -42), cornerRadius: 4, z: 4)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 12, height: 5), UIColor(resource: .Delivery.droneWindow),
				CGPoint(x: 0, y: -42), cornerRadius: 2, z: 5)
		} else {
			ScenePrimitives.line(
				carrier, from: CGPoint(x: -34, y: 29), to: CGPoint(x: 34, y: 29),
				color: UIColor(resource: .Delivery.rail), width: 3, z: 1)
			for x in [-23, 23] as [CGFloat] {
				ScenePrimitives.circle(
					carrier, radius: 4, fill: UIColor(resource: .Delivery.wheel),
					position: CGPoint(x: x, y: 29), z: 2,
					stroke: UIColor(resource: .Delivery.wheelRim), lineWidth: 1)
			}
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 30, height: 15), outline,
				CGPoint(x: 0, y: 20), cornerRadius: 5, z: 3)
			let carriageColor =
				usesMagnetic
				? UIColor(resource: .Delivery.magneticCarriage)
				: UIColor(resource: .Delivery.gantryCarriage)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 24, height: 10), carriageColor,
				CGPoint(x: 0, y: 20), cornerRadius: 4, z: 4)
			ScenePrimitives.rect(
				carrier, CGSize(width: 9, height: 4), UIColor(resource: .Delivery.carriageHighlight),
				CGPoint(x: -4, y: 21), 5
			)
			ScenePrimitives.line(
				carrier, from: CGPoint(x: -7, y: 13), to: CGPoint(x: -7, y: -31),
				color: UIColor(resource: .Delivery.carriageCable), width: 1.5, z: 2)
			ScenePrimitives.line(
				carrier, from: CGPoint(x: 7, y: 13), to: CGPoint(x: 7, y: -31),
				color: UIColor(resource: .Delivery.carriageCable), width: 1.5, z: 2)
			if usesMagnetic {
				ScenePrimitives.roundedRect(
					carrier, CGSize(width: 26, height: 12), outline,
					CGPoint(x: 0, y: -36), cornerRadius: 6, z: 4)
				ScenePrimitives.roundedRect(
					carrier, CGSize(width: 20, height: 6), UIColor(resource: .Delivery.magneticGlow),
					CGPoint(x: 0, y: -36), cornerRadius: 3, z: 5)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: -10, y: -40), to: CGPoint(x: -6, y: -46),
					color: UIColor(resource: .Delivery.magneticArc), width: 3, z: 5)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: 10, y: -40), to: CGPoint(x: 6, y: -46),
					color: UIColor(resource: .Delivery.magneticArc), width: 3, z: 5)
			} else {
				ScenePrimitives.roundedRect(
					carrier, CGSize(width: 20, height: 9), outline,
					CGPoint(x: 0, y: -34), cornerRadius: 4, z: 4)
				ScenePrimitives.roundedRect(
					carrier, CGSize(width: 14, height: 4), UIColor(resource: .Delivery.gantryGrip),
					CGPoint(x: 0, y: -34), cornerRadius: 2, z: 5)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: -7, y: -36), to: CGPoint(x: -11, y: -46),
					color: UIColor(resource: .Delivery.gantryArm), width: 3, z: 4)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: 7, y: -36), to: CGPoint(x: 11, y: -46),
					color: UIColor(resource: .Delivery.gantryArm), width: 3, z: 4)
			}
		}
		ScenePrimitives.roundedRect(
			carrier, CGSize(width: 16, height: 6), outline,
			CGPoint(x: 0, y: -29), cornerRadius: 2, z: 6)
		ScenePrimitives.rect(
			carrier, CGSize(width: 10, height: 2), UIColor(resource: .Theme.signalLime),
			CGPoint(x: 0, y: -29), 7
		)
		carrier.zPosition = 10
	}
}
