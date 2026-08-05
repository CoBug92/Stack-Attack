import SwiftUI

struct GameOverlayCard: View {
	// MARK: - Properties

	@ObservedObject var game: GameController
	let lime: Color
	let orange: Color

	// MARK: - Body

	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 0) {
				Text(game.overlayKicker)
					.font(.system(size: 9, weight: .bold, design: .monospaced))
					.tracking(1.7)
					.foregroundStyle(orange)

				Text(game.overlayTitle)
					.font(.system(size: 26, weight: .black, design: .monospaced))
					.tracking(-1.5)
					.multilineTextAlignment(.center)
					.padding(.top, 9)

				Text(game.overlayText)
					.font(.system(size: 13, weight: .regular))
					.foregroundStyle(Color(.Theme.secondaryText))
					.multilineTextAlignment(.center)
					.lineSpacing(2)
					.padding(.top, 10)

				Button(action: game.performPrimaryAction) {
					Text(game.primaryActionTitle)
						.font(.system(size: 13, weight: .black, design: .monospaced))
						.foregroundStyle(Color(.Button.onPrimary))
						.frame(maxWidth: .infinity)
						.frame(height: 48)
						.background(lime)
						.clipShape(RoundedRectangle(cornerRadius: 4))
				}
				.padding(.top, 17)

				if game.showsOverlaySettings {
					Divider()
						.overlay(Color(.Overlay.border))
						.padding(.vertical, 18)

					OverlaySettingsPanel(game: game)
				}
			}
			.padding(24)
		}
		.frame(maxWidth: 360, maxHeight: 420)
		.background(.ultraThinMaterial)
		.background(Color(.Overlay.surface).opacity(0.92))
		.clipShape(RoundedRectangle(cornerRadius: 5))
		.overlay {
			RoundedRectangle(cornerRadius: 5)
				.stroke(Color(.Overlay.border), lineWidth: 2)
		}
		.shadow(color: Color(.Theme.black).opacity(0.35), radius: 0, x: 7, y: 7)
	}
}
