import SwiftUI

struct OverlaySettingsPanel: View {
	// MARK: - Properties

	@ObservedObject var game: GameController

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 14) {
			Text(Localizations.Settings.title)
				.font(.system(size: 9, weight: .bold, design: .monospaced))
				.tracking(1.4)
				.foregroundStyle(Color(.Theme.accentOrange))

			AppearanceMenuSection(
				title: Localizations.Settings.player,
				selectionTitle: game.selectedPlayerAppearance.title,
				description: game.selectedPlayerAppearance.description,
				options: PlayerAppearance.allCases.map(\.title)
			) {
				ForEach(PlayerAppearance.allCases) { appearance in
					Button(appearance.title) {
						game.selectPlayerAppearance(appearance)
					}
				}
			}

			AppearanceMenuSection(
				title: Localizations.Settings.manipulator,
				selectionTitle: game.selectedManipulatorAppearance.title,
				description: game.selectedManipulatorAppearance.description,
				options: ManipulatorAppearance.allCases.map(\.title)
			) {
				ForEach(ManipulatorAppearance.allCases) { appearance in
					Button(appearance.title) {
						game.selectManipulatorAppearance(appearance)
					}
				}
			}

			AppearanceMenuSection(
				title: Localizations.Settings.background,
				selectionTitle: game.selectedBackgroundAppearance.title,
				description: game.selectedBackgroundAppearance.description,
				options: BackgroundAppearance.allCases.map(\.title)
			) {
				ForEach(BackgroundAppearance.allCases) { appearance in
					Button(appearance.title) {
						game.selectBackgroundAppearance(appearance)
					}
				}
			}

			Toggle(isOn: $game.hapticsEnabled) {
				VStack(alignment: .leading, spacing: 3) {
					Text(Localizations.Settings.haptics)
						.font(.system(size: 13, weight: .semibold))
						.foregroundStyle(Color(.Theme.onDark))
					Text(Localizations.Settings.Haptics.description)
						.font(.system(size: 11))
						.foregroundStyle(Color(.Theme.secondaryText))
				}
			}
			.tint(Color(.Button.primary))
		}
	}
}

private struct AppearanceMenuSection<MenuContent: View>: View {
	// MARK: - Properties

	let title: String
	let selectionTitle: String
	let description: String
	let options: [String]
	@ViewBuilder let menuContent: () -> MenuContent

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(title)
				.font(.system(size: 12, weight: .semibold))
				.foregroundStyle(Color(.Theme.onDark))

			Menu {
				menuContent()
			} label: {
				HStack(spacing: 10) {
					VStack(alignment: .leading, spacing: 3) {
						Text(selectionTitle)
							.font(.system(size: 13, weight: .bold))
							.foregroundStyle(Color(.Theme.onDark))
							.multilineTextAlignment(.leading)
						Text(description)
							.font(.system(size: 11))
							.foregroundStyle(Color(.Theme.secondaryText))
							.multilineTextAlignment(.leading)
					}

					Spacer(minLength: 8)

					VStack(alignment: .trailing, spacing: 3) {
						Text(Localizations.Settings.options(options.count))
							.font(.system(size: 10, weight: .bold, design: .monospaced))
							.foregroundStyle(Color(.Button.primary))
						Image(systemName: "chevron.up.chevron.down")
							.font(.system(size: 12, weight: .bold))
							.foregroundStyle(Color(.HUD.muted))
					}
				}
				.padding(.horizontal, 12)
				.padding(.vertical, 10)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(Color(.HUD.surface).opacity(0.92))
				.clipShape(RoundedRectangle(cornerRadius: 4))
				.overlay {
					RoundedRectangle(cornerRadius: 4)
						.stroke(Color(.HUD.divider))
				}
			}
			.buttonStyle(.plain)
		}
	}
}
