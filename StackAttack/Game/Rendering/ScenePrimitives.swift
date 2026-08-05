import SpriteKit
import UIKit

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
		node.strokeColor = stroke ?? UIColor(resource: .Theme.clearSprite)
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
		node.strokeColor = stroke ?? UIColor(resource: .Theme.clearSprite)
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
