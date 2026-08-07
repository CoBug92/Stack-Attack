import SwiftUI

struct GameOverlayCard: View {
	// MARK: - Properties

	@ObservedObject var game: GameController
	let lime: Color
	let orange: Color
	let maxHeight: CGFloat

	// MARK: - Body

	var body: some View {
		VStack(spacing: .zero) {
			if game.showsOverlaySettings {
				ScrollView(.vertical, showsIndicators: false) {
					GameOverlaySettingsView(
						game: game,
						orange: orange,
						border: Color.Overlay.border,
						surface: Color.Overlay.surface
					)
				}
			} else {
				GameOverlaySummaryView(
					game: game,
					lime: lime,
					orange: orange,
					border: Color.Overlay.border,
					surface: Color.Overlay.surface
				)
			}
		}
		.padding(Margin.x12)
		.foregroundColor(Color.Theme.white)
		.frame(maxWidth: cardMaxWidth)
		.frame(maxHeight: game.showsOverlaySettings ? maxHeight : nil)
		.background(.ultraThinMaterial)
		.background(
			Color.Overlay.surface
				.opacity(.overlayCardSurfaceOpacity)
		)
		.clipShape(
			RoundedRectangle(
				cornerRadius: .overlayCardCornerRadius
			)
		)
		.overlay {
			RoundedRectangle(
				cornerRadius: .overlayCardCornerRadius
			)
			.stroke(
				Color.Overlay.border,
				lineWidth: .overlayCardBorderWidth
			)
		}
	}

	// MARK: - Private properties

	private var cardMaxWidth: CGFloat {
		game.showsOverlaySettings ? .overlaySettingsCardMaxWidth : .overlaySummaryCardMaxWidth
	}
}

// MARK: - Constants

private extension CGFloat {
	static let overlaySummaryCardMaxWidth = 320.0
	static let overlaySettingsCardMaxWidth = 420.0
	static let overlayCardCornerRadius = 5.0
	static let overlayCardBorderWidth = 2.0
}

private extension Double {
	static let overlayCardSurfaceOpacity = 0.92
}

// MARK: - Preview

#Preview("Summary") {
	GameOverlayCard(
		game: FlowPreviewSupport.makeGame(),
		lime: FlowPreviewSupport.lime,
		orange: FlowPreviewSupport.orange,
		maxHeight: 720
	)
	.padding(Margin.x(12))
	.background(FlowPreviewSupport.canvas)
}

#Preview("Settings") {
	GameOverlayCard(
		game: FlowPreviewSupport.makeGame(overlayScreen: .settings),
		lime: FlowPreviewSupport.lime,
		orange: FlowPreviewSupport.orange,
		maxHeight: 720
	)
	.padding(Margin.x(12))
	.background(FlowPreviewSupport.canvas)
}
