import SpriteKit
import SwiftUI

struct GameAreaView: View {
	// MARK: - Properties

	@ObservedObject var game: GameController
	let maxWidth: CGFloat
	let maxHeight: CGFloat

	// MARK: - Body

	var body: some View {
		SpriteView(
			scene: game.scene,
			options: [.ignoresSiblingOrder]
		)
		.aspectRatio(
			.gameAreaAspectRatio,
			contentMode: .fit
		)
		.frame(
			maxWidth: maxWidth,
			maxHeight: maxHeight
		)
		.background(Color.Scene.playfieldFill)
		.clipShape(
			RoundedRectangle(
				cornerRadius: .gameAreaCornerRadius
			)
		)
		.overlay {
			RoundedRectangle(
				cornerRadius: .gameAreaCornerRadius
			)
			.stroke(Color.HUD.divider)
		}
		.frame(maxWidth: .infinity)
	}
}

// MARK: - Constants

private extension CGFloat {
	static let gameAreaAspectRatio = 3.0 / 4.0
	static let gameAreaCornerRadius = 4.0
}

// MARK: - Preview

#Preview("Overlay") {
	GameAreaView(
		game: FlowPreviewSupport.makeGame(),
		maxWidth: 360,
		maxHeight: 520
	)
}

#Preview("Playing") {
	GameAreaView(
		game: FlowPreviewSupport.makeGame(phase: .playing),
		maxWidth: 360,
		maxHeight: 520
	)
}
