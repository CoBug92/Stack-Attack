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
			Text(verbatim: .shiftSettings)
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
			.skinSelection
		case .playerAppearance:
			.playerSelectionTitle
		case .manipulatorAppearance:
			.manipulatorSelectionTitle
		case .backgroundAppearance:
			.backgroundSelectionTitle
		}
	}

	private var screenDescription: String {
		switch game.overlayScreen {
		case .summary, .settings:
			.overlaySettingsDescription
		case .playerAppearance:
			.playerSelectionDescription
		case .manipulatorAppearance:
			.manipulatorSelectionDescription
		case .backgroundAppearance:
			.backgroundSelectionDescription
		}
	}

	private var backButtonTitle: String {
		switch game.overlayScreen {
		case .summary, .settings:
			.back
		case .playerAppearance, .manipulatorAppearance, .backgroundAppearance:
			.backToSettings
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

private extension String {
	static let shiftSettings = "НАСТРОЙКИ СМЕНЫ"
	static let skinSelection = "Выбор скинов"
	static let overlaySettingsDescription =
		"Подбери грузчика, манипулятор и задний фон для следующей смены."
	static let back = "НАЗАД"
	static let backToSettings = "К РАЗДЕЛАМ"
	static let playerSelectionTitle = "Выбор грузчика"
	static let playerSelectionDescription =
		"Сравни облики грузчика и выбери, кто выйдет на следующую смену."
	static let manipulatorSelectionTitle = "Выбор манипулятора"
	static let manipulatorSelectionDescription =
		"Посмотри на каждый манипулятор отдельно и выбери подходящий стиль доставки."
	static let backgroundSelectionTitle = "Выбор фона"
	static let backgroundSelectionDescription =
		"Проверь атмосферу каждой площадки и выбери фон для склада."
}
