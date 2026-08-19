import SwiftUI

struct BackgroundMusicSection: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		VStack(spacing: Margin.x2) {
			ForEach(BackgroundMusicTrack.allCases) { track in
				Button {
					game.selectBackgroundMusicTrack(track)
				} label: {
					AppearanceSelectionCard(
						title: track.title,
						description: track.description,
						isSelected: track == game.selectedBackgroundMusicTrack
					)
				}
				.buttonStyle(.plain)
			}
		}
	}
}

// MARK: - Preview

#Preview {
	BackgroundMusicSection(
		game: FlowPreviewSupport.makeGame(overlayScreen: .backgroundMusic)
	)
	.padding(Margin.x8)
	.background(FlowPreviewSupport.canvas)
}
