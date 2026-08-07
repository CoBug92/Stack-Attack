import SwiftUI

struct GameOverlaySettingsView: View {
	// MARK: - Properties

	@ObservedObject var game: GameController
	let orange: Color
	let border: Color
	let surface: Color

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 0) {
			Text(verbatim: Localizations.Settings.title)
				.appTypography(.overlayKicker)
				.foregroundColor(orange)

			Text(screenTitle)
				.appTypography(.overlayTitle)
				.foregroundColor(Color.Theme.white)
				.padding(.top, Margin.x(.overlaySettingsTitleTopPaddingUnits))

			Text(screenDescription)
				.appTypography(.body)
				.foregroundColor(Color.Overlay.textSecondary)
				.padding(.top, Margin.x5)

			Divider()
				.overlay(border)
				.padding(.vertical, Margin.x9)

			screenContent

			GameOverlaySecondaryButton(
				title: backButtonTitle,
				border: border,
				surface: surface,
				action: game.hideOverlaySettings
			)
			.padding(.top, Margin.x9)
		}
	}

	// MARK: - Private properties

	@ViewBuilder
	private var screenContent: some View {
		switch game.overlayScreen {
		case .summary:
			EmptyView()
		case .settings:
			OverlaySettingsPanel(game: game)
		case .playerAppearance:
			PlayerAppearanceSection(game: game)
		case .manipulatorAppearance:
			ManipulatorAppearanceSection(game: game)
		case .backgroundAppearance:
			BackgroundAppearanceSection(game: game)
		}
	}

	private var screenTitle: String {
		switch game.overlayScreen {
		case .summary, .settings:
			Localizations.Settings.Appearance.title
		case .playerAppearance:
			Localizations.Settings.PlayerSelection.title
		case .manipulatorAppearance:
			Localizations.Settings.ManipulatorSelection.title
		case .backgroundAppearance:
			Localizations.Settings.BackgroundSelection.title
		}
	}

	private var screenDescription: String {
		switch game.overlayScreen {
		case .summary, .settings:
			Localizations.Settings.Appearance.description
		case .playerAppearance:
			Localizations.Settings.PlayerSelection.description
		case .manipulatorAppearance:
			Localizations.Settings.ManipulatorSelection.description
		case .backgroundAppearance:
			Localizations.Settings.BackgroundSelection.description
		}
	}

	private var backButtonTitle: String {
		switch game.overlayScreen {
		case .summary, .settings:
			Localizations.Settings.Navigation.back
		case .playerAppearance, .manipulatorAppearance, .backgroundAppearance:
			Localizations.Settings.Navigation.backToSections
		}
	}
}

// MARK: - Preview

#Preview {
	GameOverlaySettingsView(
		game: FlowPreviewSupport.makeGame(overlayScreen: .settings),
		orange: FlowPreviewSupport.orange,
		border: FlowPreviewSupport.border,
		surface: FlowPreviewSupport.surface
	)
	.padding(Margin.x(12))
	.background(FlowPreviewSupport.canvas)
}

// MARK: - Constants

private extension CGFloat {
	static let overlaySettingsTitleTopPaddingUnits = 4.5
}
