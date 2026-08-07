import SpriteKit
import SwiftUI

@MainActor
struct AppearancePreviewView: View {
	enum Content: Hashable {
		case player(PlayerAppearance)
		case manipulator(ManipulatorAppearance)
		case background(BackgroundAppearance)
		case selection(
			player: PlayerAppearance,
			manipulator: ManipulatorAppearance,
			background: BackgroundAppearance
		)

		var id: String {
			switch self {
			case .player(let appearance):
				"player-\(appearance.rawValue)"
			case .manipulator(let appearance):
				"manipulator-\(appearance.rawValue)"
			case .background(let appearance):
				"background-\(appearance.rawValue)"
			case .selection(let player, let manipulator, let background):
				"selection-\(player.rawValue)-\(manipulator.rawValue)-\(background.rawValue)"
			}
		}
	}

	// MARK: - Properties

	let content: Content

	// MARK: - Body

	var body: some View {
		SpriteView(
			scene: AppearancePreviewScene(content: content),
			options: [.ignoresSiblingOrder, .allowsTransparency]
		)
		.id(content.id)
		.aspectRatio(.appearancePreviewAspectRatio, contentMode: .fit)
		.frame(maxWidth: .infinity)
		.background(Color.HUD.surface.opacity(.appearancePreviewSurfaceOpacity))
		.clipShape(RoundedRectangle(cornerRadius: .appearancePreviewCornerRadius))
		.overlay {
			RoundedRectangle(cornerRadius: .appearancePreviewCornerRadius)
				.stroke(Color.HUD.divider, lineWidth: .appearancePreviewBorderWidth)
		}
	}
}

// MARK: - Preview

#Preview {
	HStack(spacing: Margin.x4) {
		AppearancePreviewView(content: .player(.cyberLoader))
		AppearancePreviewView(content: .manipulator(.magnetic))
		AppearancePreviewView(content: .background(.cyberCity))
	}
	.padding(Margin.x8)
	.background(FlowPreviewSupport.canvas)
}

// MARK: - Constants

private extension CGFloat {
	static let appearancePreviewAspectRatio = 3.0 / 4.0
	static let appearancePreviewCornerRadius = 4.0
	static let appearancePreviewBorderWidth = 2.0
	static let backgroundPreviewScale = 0.74
	static let previewSceneWidth = 480.0
	static let previewSceneHeight = 640.0
	static let previewCenterX = previewSceneWidth / 2
	static let previewPlayerY = 140.0
	static let previewManipulatorY = 352.0
	static let previewIsolatedPlayerY = 240.0
	static let previewIsolatedManipulatorY = 280.0
	static let previewRailY = 470.0
	static let previewFloorY = 76.0
	static let previewSelectionPlayerScale = 3.6
	static let previewIsolatedPlayerScale = 4.8
	static let previewSelectionManipulatorScale = 3.1
	static let previewIsolatedManipulatorScale = 4.1
}

private extension Double {
	static let appearancePreviewSurfaceOpacity = 0.88
}

@MainActor
private final class AppearancePreviewScene: SKScene {
	// MARK: - Init

	init(content: AppearancePreviewView.Content) {
		super.init(size: CGSize(width: .previewSceneWidth, height: .previewSceneHeight))
		scaleMode = .aspectFit
		backgroundColor = .clear
		build(content: content)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Private methods

	private func build(content: AppearancePreviewView.Content) {
		let backgroundLayer = SKNode()
		let railLayer = SKNode()
		let contentLayer = SKNode()

		addChild(backgroundLayer)
		addChild(railLayer)
		addChild(contentLayer)

		switch content {
		case .player(let appearance):
			buildPlayer(
				on: contentLayer,
				appearance: appearance,
				yPosition: .previewIsolatedPlayerY,
				scale: .previewIsolatedPlayerScale
			)
		case .manipulator(let appearance):
			buildManipulator(
				on: contentLayer,
				appearance: appearance,
				yPosition: .previewIsolatedManipulatorY,
				scale: .previewIsolatedManipulatorScale
			)
		case .background(let appearance):
			buildBackgroundPreview(on: backgroundLayer, appearance: appearance)
		case .selection(let player, let manipulator, let background):
			SceneBackgroundRenderer.buildBackground(
				on: backgroundLayer,
				size: size,
				appearance: background
			)
			SceneBackgroundRenderer.buildRail(on: railLayer, size: size, railY: .previewRailY)
			buildFloor(on: contentLayer)
			buildPlayer(
				on: contentLayer,
				appearance: player,
				yPosition: .previewPlayerY,
				scale: .previewSelectionPlayerScale
			)
			buildManipulator(
				on: contentLayer,
				appearance: manipulator,
				yPosition: .previewManipulatorY,
				scale: .previewSelectionManipulatorScale
			)
		}
	}

	private func buildBackgroundPreview(on layer: SKNode, appearance: BackgroundAppearance) {
		let scaledLayer = SKNode()
		scaledLayer.setScale(.backgroundPreviewScale)
		scaledLayer.position = CGPoint(
			x: size.width * (1 - .backgroundPreviewScale) / 2,
			y: size.height * (1 - .backgroundPreviewScale) / 2
		)
		layer.addChild(scaledLayer)
		SceneBackgroundRenderer.buildBackground(
			on: scaledLayer,
			size: size,
			appearance: appearance
		)
	}

	private func buildFloor(on layer: SKNode) {
		ScenePrimitives.rect(
			layer,
			CGSize(width: size.width, height: 18),
			GamePalette.Scene.groundEdge,
			CGPoint(x: .previewCenterX, y: .previewFloorY),
			1
		)
	}

	private func buildPlayer(
		on layer: SKNode,
		appearance: PlayerAppearance,
		yPosition: CGFloat,
		scale: CGFloat
	) {
		let playerNode = SKNode()
		playerNode.position = CGPoint(x: .previewCenterX, y: yPosition)
		playerNode.setScale(scale)
		PlayerVisualRenderer.build(in: playerNode, appearance: appearance)
		layer.addChild(playerNode)
	}

	private func buildManipulator(
		on layer: SKNode,
		appearance: ManipulatorAppearance,
		yPosition: CGFloat,
		scale: CGFloat
	) {
		let carrier = SKNode()
		carrier.position = CGPoint(x: .previewCenterX, y: yPosition)
		carrier.setScale(scale)
		DeliveryVisualRenderer.build(
			in: carrier,
			usesDrone: appearance == .drone,
			usesMagnetic: appearance == .magnetic
		)
		layer.addChild(carrier)
	}
}
