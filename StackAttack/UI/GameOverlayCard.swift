import SwiftUI

struct GameOverlayCard: View {
	// MARK: - Properties

	@ObservedObject var game: GameController
	let lime: Color
	let orange: Color
	private let secondaryText = Color(red: 0.7, green: 0.77, blue: 0.74)
	private let border = Color(red: 0.31, green: 0.41, blue: 0.45)
	private let surface = Color(red: 0.075, green: 0.13, blue: 0.19)

	// MARK: - Body

	var body: some View {
		ScrollView(showsIndicators: false) {
			VStack(spacing: 0) {
				Text(game.overlayKicker)
					.font(.system(size: 9, weight: .bold, design: .monospaced))
					.tracking(1.7)
					.foregroundColor(orange)

				Text(game.overlayTitle)
					.font(.system(size: 26, weight: .black, design: .monospaced))
					.tracking(-1.5)
					.multilineTextAlignment(.center)
					.padding(.top, 9)

				Text(game.overlayText)
					.font(.system(size: 13, weight: .regular))
					.foregroundColor(secondaryText)
					.multilineTextAlignment(.center)
					.lineSpacing(2)
					.padding(.top, 10)

				Button(action: game.performPrimaryAction) {
					Text(game.primaryActionTitle)
						.font(.system(size: 13, weight: .black, design: .monospaced))
						.foregroundColor(Color(red: 0.08, green: 0.13, blue: 0.07))
						.frame(maxWidth: .infinity)
						.frame(height: 48)
						.background(lime)
						.clipShape(RoundedRectangle(cornerRadius: 4))
				}
				.buttonStyle(.plain)
				.padding(.top, 17)

				if game.showsOverlaySettings {
					Divider()
						.overlay(border)
						.padding(.vertical, 18)

					OverlaySettingsPanel(game: game)
				}
			}
			.padding(24)
		}
		.foregroundColor(.white)
		.frame(maxWidth: 360, maxHeight: 420)
		.background(.ultraThinMaterial)
		.background(surface.opacity(0.92))
		.clipShape(RoundedRectangle(cornerRadius: 5))
		.overlay {
			RoundedRectangle(cornerRadius: 5)
				.stroke(border, lineWidth: 2)
		}
		.shadow(color: Color.black.opacity(0.35), radius: 0, x: 7, y: 7)
	}
}
