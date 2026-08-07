import SwiftUI

struct GameScoreboardView: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		HStack {
			GameScoreItemView(
				label: .score,
				value: padded(game.score, length: .scoreLength),
				alignment: .leading
			)

			Spacer()

			GameScoreItemView(
				label: .record,
				value: padded(max(game.score, game.highScore), length: .scoreLength),
				alignment: .center
			)

			Spacer()

			GameScoreItemView(
				label: .level,
				value: padded(game.level, length: .levelLength),
				alignment: .trailing
			)
		}
		.padding(.horizontal, Margin.x6)
		.padding(.vertical, Margin.x5)
		.background(Color.HUD.panel)
		.overlay(alignment: .top) {
            Rectangle()
				.fill(Color.HUD.divider)
				.frame(height: .scoreboardDividerHeight)
		}
	}

	// MARK: - Private methods

	private func padded(_ value: Int, length: Int) -> String {
		String(format: "%0\(length)d", value)
	}
}

// MARK: - Constants

private extension CGFloat {
    static let scoreboardDividerHeight: CGFloat = 1
}

private extension Int {
    static let scoreLength = 6
    static let levelLength = 2
}

private extension String {
    static let score = "СЧЁТ"
    static let record = "РЕКОРД"
    static let level = "УРОВЕНЬ"
}

// MARK: - Preview

#Preview {
    FlowPreviewSupport.canvas
        .overlay {
            GameScoreboardView(game: FlowPreviewSupport.makeGame(phase: .playing))
        }
        .ignoresSafeArea()
}
