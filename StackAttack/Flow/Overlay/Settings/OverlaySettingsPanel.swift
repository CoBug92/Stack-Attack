import SwiftUI

struct OverlaySettingsPanel: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: Margin.x7) {
			AppearanceMenuSection(
				title: .loader,
				optionCount: PlayerAppearance.allCases.count,
				previewContent: .player(game.selectedPlayerAppearance),
				selectedTitle: game.selectedPlayerAppearance.title,
				selectedDescription: game.selectedPlayerAppearance.description,
				action: game.showPlayerAppearanceSettings
			)

			AppearanceMenuSection(
				title: .manipulator,
				optionCount: ManipulatorAppearance.allCases.count,
				previewContent: .manipulator(game.selectedManipulatorAppearance),
				selectedTitle: game.selectedManipulatorAppearance.title,
				selectedDescription: game.selectedManipulatorAppearance.description,
				action: game.showManipulatorAppearanceSettings
			)

			AppearanceMenuSection(
				title: .background,
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

// MARK: - Constants

private extension String {
	static let loader = "Грузчик"
	static let manipulator = "Манипулятор"
	static let background = "Задний фон"
}
