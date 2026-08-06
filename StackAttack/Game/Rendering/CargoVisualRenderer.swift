import SpriteKit
import UIKit

@MainActor
enum CargoVisualRenderer {
	// MARK: - Rendering

	static func makeCrate(side: CGFloat, color: UIColor) -> SKNode {
		let node = SKNode()
		let outline = GamePalette.Scene.outline
		ScenePrimitives.roundedRect(
			node, CGSize(width: side, height: side), outline, .zero, cornerRadius: 7, z: 1
		)
		ScenePrimitives.roundedRect(
			node, CGSize(width: side - 4, height: side - 4), color, .zero, cornerRadius: 6, z: 2
		)
		ScenePrimitives.roundedRect(
			node, CGSize(width: side - 12, height: side - 12), color.withAlphaComponent(0.8),
			CGPoint(x: 1, y: -1), cornerRadius: 5, z: 3
		)
		ScenePrimitives.rect(
			node, CGSize(width: side - 8, height: 5),
			GamePalette.Theme.white.withAlphaComponent(0.18),
			CGPoint(x: 0, y: 15), 4
		)
		ScenePrimitives.rect(
			node, CGSize(width: 7, height: side - 8), outline.withAlphaComponent(0.16),
			CGPoint(x: -16, y: 0), 4
		)
		ScenePrimitives.rect(
			node, CGSize(width: 5, height: side - 12), outline.withAlphaComponent(0.18),
			CGPoint(x: 18, y: 1), 4
		)
		let steel = GamePalette.Cargo.metal
		for x in [-18, 18] as [CGFloat] {
			for y in [-18, 18] as [CGFloat] {
				ScenePrimitives.roundedRect(
					node, CGSize(width: 9, height: 9), outline, CGPoint(x: x, y: y), cornerRadius: 2, z: 5
				)
				ScenePrimitives.roundedRect(
					node, CGSize(width: 6, height: 6), steel, CGPoint(x: x, y: y), cornerRadius: 1, z: 6
				)
			}
		}
		ScenePrimitives.roundedRect(
			node, CGSize(width: 14, height: 18), outline.withAlphaComponent(0.55),
			CGPoint(x: 0, y: 0), cornerRadius: 3, z: 5)
		ScenePrimitives.rect(
			node, CGSize(width: 3, height: 15), GamePalette.Theme.white.withAlphaComponent(0.6),
			CGPoint(x: -2, y: 0), 6
		)
		ScenePrimitives.rect(
			node, CGSize(width: 3, height: 15), GamePalette.Theme.white.withAlphaComponent(0.35),
			CGPoint(x: 3, y: 0), 6
		)
		ScenePrimitives.rect(
			node, CGSize(width: 20, height: 4), GamePalette.Cargo.strap.withAlphaComponent(0.8),
			CGPoint(x: 0, y: -15), 6
		)
		ScenePrimitives.rect(
			node, CGSize(width: 20, height: 4), GamePalette.Cargo.strap.withAlphaComponent(0.68),
			CGPoint(x: 0, y: 15), 6
		)
		ScenePrimitives.roundedRect(
			node, CGSize(width: 18, height: 12), GamePalette.Cargo.label,
			CGPoint(x: -10, y: 9), cornerRadius: 2, z: 7)
		for y in [13, 10, 7] as [CGFloat] {
			ScenePrimitives.rect(
				node, CGSize(width: 11, height: 1), GamePalette.Cargo.labelLines,
				CGPoint(x: -10, y: y), 8
			)
		}
		ScenePrimitives.roundedRect(
			node, CGSize(width: 12, height: 8), GamePalette.Cargo.stamp,
			CGPoint(x: 12, y: -10), cornerRadius: 2, z: 7)
		ScenePrimitives.rect(
			node, CGSize(width: 8, height: 2), GamePalette.Cargo.stampHighlight,
			CGPoint(x: 12, y: -10), 8
		)
		for angle in [CGFloat.pi / 4, -.pi / 4] {
			let brace = SKSpriteNode(
				color: outline.withAlphaComponent(0.34), size: CGSize(width: side - 10, height: 3))
			brace.zRotation = angle
			brace.zPosition = 4
			node.addChild(brace)
		}
		return node
	}
}
