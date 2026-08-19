import SwiftUI

struct OverlaySettingsPanel: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: Margin.x7) {
			BackgroundMusicMenuSection(
				title: Localizations.Settings.music,
				optionCount: BackgroundMusicTrack.allCases.count,
				selectedTitle: game.selectedBackgroundMusicTrack.title,
				selectedDescription: game.selectedBackgroundMusicTrack.description,
				action: game.showBackgroundMusicSettings
			)

			AppearanceMenuSection(
				title: Localizations.Settings.player,
				optionCount: PlayerAppearance.allCases.count,
				previewContent: .player(game.selectedPlayerAppearance),
				selectedTitle: game.selectedPlayerAppearance.title,
				selectedDescription: game.selectedPlayerAppearance.description,
				action: game.showPlayerAppearanceSettings
			)

			AppearanceMenuSection(
				title: Localizations.Settings.manipulator,
				optionCount: ManipulatorAppearance.allCases.count,
				previewContent: .manipulator(game.selectedManipulatorAppearance),
				selectedTitle: game.selectedManipulatorAppearance.title,
				selectedDescription: game.selectedManipulatorAppearance.description,
				action: game.showManipulatorAppearanceSettings
			)

			AppearanceMenuSection(
				title: Localizations.Settings.background,
				optionCount: BackgroundAppearance.allCases.count,
				previewContent: .background(game.selectedBackgroundAppearance),
				selectedTitle: game.selectedBackgroundAppearance.title,
				selectedDescription: game.selectedBackgroundAppearance.description,
				action: game.showBackgroundAppearanceSettings
			)
		}
		.foregroundColor(Color.Theme.white)
	}
}

// MARK: - Preview

#Preview {
	OverlaySettingsPanel(game: FlowPreviewSupport.makeGame(overlayScreen: .settings))
		.padding(Margin.x8)
		.background(FlowPreviewSupport.canvas)
}
