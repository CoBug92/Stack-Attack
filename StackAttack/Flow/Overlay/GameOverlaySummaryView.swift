import SwiftUI

struct GameOverlaySummaryView: View {
	// MARK: - Properties

	@ObservedObject var game: GameController
	let lime: Color
	let orange: Color
	let border: Color
	let surface: Color

	// MARK: - Body

	var body: some View {
		VStack(spacing: 0) {
			Text(game.overlayKicker)
				.appTypography(.overlayKicker)
				.foregroundColor(orange)

			Text(game.overlayTitle)
				.appTypography(.overlayTitle)
				.multilineTextAlignment(.center)
				.padding(.top, Margin.x(.overlaySummaryTitleTopPaddingUnits))

			Text(game.overlayText)
				.appTypography(.body)
				.foregroundColor(Color.Overlay.textSecondary)
				.multilineTextAlignment(.center)
				.padding(.top, Margin.x5)

			Button(action: game.performPrimaryAction) {
				Text(game.primaryActionTitle)
					.appTypography(.primaryButton)
					.foregroundColor(Color.Theme.uiAccentForeground)
					.frame(maxWidth: .infinity)
					.frame(height: .primaryButtonHeight)
					.background(lime)
					.clipShape(RoundedRectangle(cornerRadius: .primaryButtonCornerRadius))
			}
			.buttonStyle(.plain)
			.padding(.top, Margin.x(.overlaySummaryPrimaryButtonTopPaddingUnits))

			if game.canOpenOverlaySettings {
				GameOverlaySecondaryButton(
					title: .settings,
					border: border,
					surface: surface,
					action: game.showOverlaySettings
				)
				.padding(.top, Margin.x5)
			}
		}
	}
}

// MARK: - Constants

private extension CGFloat {
    static let overlaySummaryTitleTopPaddingUnits = 4.5
    static let overlaySummaryPrimaryButtonTopPaddingUnits = 8.5
    static let primaryButtonHeight = 48.0
    static let primaryButtonCornerRadius = 4.0
}

private extension String {
    static let settings = "НАСТРОЙКИ"
}

// MARK: - Preview

#Preview("Ready") {
	GameOverlaySummaryView(
		game: FlowPreviewSupport.makeGame(),
		lime: FlowPreviewSupport.lime,
		orange: FlowPreviewSupport.orange,
		border: FlowPreviewSupport.border,
		surface: FlowPreviewSupport.surface
	)
}

#Preview("Paused") {
	GameOverlaySummaryView(
		game: FlowPreviewSupport.makeGame(phase: .paused),
		lime: FlowPreviewSupport.lime,
		orange: FlowPreviewSupport.orange,
		border: FlowPreviewSupport.border,
		surface: FlowPreviewSupport.surface
	)
}
