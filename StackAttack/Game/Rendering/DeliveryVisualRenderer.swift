import SpriteKit
import UIKit

@MainActor
enum DeliveryVisualRenderer {
	private static let outline = color(0.0902, 0.1451, 0.2078)
	private static let signalLime = color(0.8471, 1, 0.4471)
	private static let droneBody = color(0.1412, 0.2706, 0.4275)
	private static let droneWindow = color(0.4549, 0.8902, 0.9569)
	private static let droneStrut = color(0.2431, 0.4078, 0.5059)
	private static let droneRotor = color(0.0588, 0.1020, 0.1569)
	private static let droneRotorRing = color(0.4275, 0.9098, 1)
	private static let droneRotorHighlight = color(0.7961, 0.9373, 1)
	private static let droneCable = color(0.6, 0.7882, 0.8275)
	private static let rail = color(0.4627, 0.5529, 0.5882)
	private static let wheel = color(0.0549, 0.0902, 0.1412)
	private static let wheelRim = color(0.6, 0.7255, 0.7647)
	private static let gantryCarriage = color(0.5608, 0.4118, 0.1922)
	private static let carriageHighlight = color(0.9137, 0.9647, 1)
	private static let carriageCable = color(0.6941, 0.8353, 0.8157)
	private static let magneticCarriage = color(0.4039, 0.3020, 0.8)
	private static let magneticGlow = color(0.3725, 0.9098, 1)
	private static let magneticArc = color(0.6588, 0.9020, 1)
	private static let gantryGrip = color(0.8471, 0.4941, 0.2980)
	private static let gantryArm = color(0.7373, 0.8118, 0.8314)

	// MARK: - Rendering

	static func build(in carrier: SKNode, usesDrone: Bool, usesMagnetic: Bool) {
		if usesDrone {
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 46, height: 16), outline,
				CGPoint(x: 0, y: 13), cornerRadius: 7, z: 3)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 38, height: 12), droneBody,
				CGPoint(x: 0, y: 13), cornerRadius: 6, z: 4)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 17, height: 6), droneWindow,
				CGPoint(x: 0, y: 13), cornerRadius: 3, z: 5)
			ScenePrimitives.rect(
				carrier, CGSize(width: 8, height: 4), signalLime,
				CGPoint(x: 11, y: 13), 6
			)
			for x in [-22, 22] as [CGFloat] {
				ScenePrimitives.line(
					carrier, from: CGPoint(x: x * 0.55, y: 14), to: CGPoint(x: x, y: 22),
					color: droneStrut, width: 4, z: 3)
				ScenePrimitives.circle(
					carrier, radius: 7.5, fill: droneRotor,
					position: CGPoint(x: x, y: 22), z: 4,
					stroke: droneRotorRing, lineWidth: 1.5)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: x - 8, y: 22), to: CGPoint(x: x + 8, y: 22),
					color: droneRotorHighlight.withAlphaComponent(0.55),
					width: 1.2, z: 5
				)
			}
			ScenePrimitives.line(
				carrier, from: CGPoint(x: -7, y: 5), to: CGPoint(x: -2, y: -38),
				color: droneCable, width: 1.5, z: 2)
			ScenePrimitives.line(
				carrier, from: CGPoint(x: 7, y: 5), to: CGPoint(x: 2, y: -38),
				color: droneCable, width: 1.5, z: 2)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 18, height: 10), outline,
				CGPoint(x: 0, y: -42), cornerRadius: 4, z: 4)
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 12, height: 5), droneWindow,
				CGPoint(x: 0, y: -42), cornerRadius: 2, z: 5)
		} else {
			ScenePrimitives.line(
				carrier, from: CGPoint(x: -34, y: 29), to: CGPoint(x: 34, y: 29),
				color: rail, width: 3, z: 1)
			for x in [-23, 23] as [CGFloat] {
				ScenePrimitives.circle(
					carrier, radius: 4, fill: wheel,
					position: CGPoint(x: x, y: 29), z: 2,
					stroke: wheelRim, lineWidth: 1)
			}
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 30, height: 15), outline,
				CGPoint(x: 0, y: 20), cornerRadius: 5, z: 3)
			let carriageColor =
				usesMagnetic
				? magneticCarriage
				: gantryCarriage
			ScenePrimitives.roundedRect(
				carrier, CGSize(width: 24, height: 10), carriageColor,
				CGPoint(x: 0, y: 20), cornerRadius: 4, z: 4)
			ScenePrimitives.rect(
				carrier, CGSize(width: 9, height: 4), carriageHighlight,
				CGPoint(x: -4, y: 21), 5
			)
			ScenePrimitives.line(
				carrier, from: CGPoint(x: -7, y: 13), to: CGPoint(x: -7, y: -31),
				color: carriageCable, width: 1.5, z: 2)
			ScenePrimitives.line(
				carrier, from: CGPoint(x: 7, y: 13), to: CGPoint(x: 7, y: -31),
				color: carriageCable, width: 1.5, z: 2)
			if usesMagnetic {
				ScenePrimitives.roundedRect(
					carrier, CGSize(width: 26, height: 12), outline,
					CGPoint(x: 0, y: -36), cornerRadius: 6, z: 4)
				ScenePrimitives.roundedRect(
					carrier, CGSize(width: 20, height: 6), magneticGlow,
					CGPoint(x: 0, y: -36), cornerRadius: 3, z: 5)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: -10, y: -40), to: CGPoint(x: -6, y: -46),
					color: magneticArc, width: 3, z: 5)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: 10, y: -40), to: CGPoint(x: 6, y: -46),
					color: magneticArc, width: 3, z: 5)
			} else {
				ScenePrimitives.roundedRect(
					carrier, CGSize(width: 20, height: 9), outline,
					CGPoint(x: 0, y: -34), cornerRadius: 4, z: 4)
				ScenePrimitives.roundedRect(
					carrier, CGSize(width: 14, height: 4), gantryGrip,
					CGPoint(x: 0, y: -34), cornerRadius: 2, z: 5)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: -7, y: -36), to: CGPoint(x: -11, y: -46),
					color: gantryArm, width: 3, z: 4)
				ScenePrimitives.line(
					carrier, from: CGPoint(x: 7, y: -36), to: CGPoint(x: 11, y: -46),
					color: gantryArm, width: 3, z: 4)
			}
		}
		ScenePrimitives.roundedRect(
			carrier, CGSize(width: 16, height: 6), outline,
			CGPoint(x: 0, y: -29), cornerRadius: 2, z: 6)
		ScenePrimitives.rect(
			carrier, CGSize(width: 10, height: 2), signalLime,
			CGPoint(x: 0, y: -29), 7
		)
		carrier.zPosition = 10
	}

	private static func color(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
		UIColor(red: red, green: green, blue: blue, alpha: 1)
	}
}
