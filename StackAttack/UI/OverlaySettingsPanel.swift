import SwiftUI

struct OverlaySettingsPanel: View {
	// MARK: - Properties

	@ObservedObject var game: GameController
	private let orange = Color(red: 1, green: 0.51, blue: 0.28)
	private let lime = Color(red: 0.776, green: 0.937, blue: 0.38)
	private let secondaryText = Color(red: 0.7, green: 0.77, blue: 0.74)
	private let hudMuted = Color(red: 0.57, green: 0.65, blue: 0.61)
	private let hudSurface = Color(red: 0.06, green: 0.1, blue: 0.15)
	private let hudDivider = Color(red: 0.18, green: 0.26, blue: 0.31)

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 14) {
			Text("НАСТРОЙКИ СМЕНЫ")
				.font(.system(size: 9, weight: .bold, design: .monospaced))
				.tracking(1.4)
				.foregroundColor(orange)

			AppearanceMenuSection(
				title: "Грузчик",
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
				title: "Манипулятор",
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
				title: "Задний фон",
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
					Text("Вибрация")
						.font(.system(size: 13, weight: .semibold))
						.foregroundColor(.white)
					Text("Тактильный отклик для прыжка, очков и столкновений.")
						.font(.system(size: 11))
						.foregroundColor(secondaryText)
				}
			}
			.tint(lime)
		}
		.foregroundColor(.white)
	}
}

private struct AppearanceMenuSection<MenuContent: View>: View {
	// MARK: - Properties

	let title: String
	let selectionTitle: String
	let description: String
	let options: [String]
	@ViewBuilder let menuContent: () -> MenuContent
	private let lime = Color(red: 0.776, green: 0.937, blue: 0.38)
	private let secondaryText = Color(red: 0.7, green: 0.77, blue: 0.74)
	private let hudMuted = Color(red: 0.57, green: 0.65, blue: 0.61)
	private let hudSurface = Color(red: 0.06, green: 0.1, blue: 0.15)
	private let hudDivider = Color(red: 0.18, green: 0.26, blue: 0.31)

	// MARK: - Body

	var body: some View {
		VStack(alignment: .leading, spacing: 6) {
			Text(title)
				.font(.system(size: 12, weight: .semibold))
				.foregroundColor(.white)

			Menu {
				menuContent()
			} label: {
				HStack(spacing: 10) {
					VStack(alignment: .leading, spacing: 3) {
						Text(selectionTitle)
							.font(.system(size: 13, weight: .bold))
							.foregroundColor(.white)
							.multilineTextAlignment(.leading)
						Text(description)
							.font(.system(size: 11))
							.foregroundColor(secondaryText)
							.multilineTextAlignment(.leading)
					}

					Spacer(minLength: 8)

					VStack(alignment: .trailing, spacing: 3) {
						Text(optionsLabel(options.count))
							.font(.system(size: 10, weight: .bold, design: .monospaced))
							.foregroundColor(lime)
						Image(systemName: "chevron.up.chevron.down")
							.font(.system(size: 12, weight: .bold))
							.foregroundColor(hudMuted)
					}
				}
				.padding(.horizontal, 12)
				.padding(.vertical, 10)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(hudSurface.opacity(0.92))
				.clipShape(RoundedRectangle(cornerRadius: 4))
				.overlay {
					RoundedRectangle(cornerRadius: 4)
						.stroke(hudDivider)
				}
			}
			.buttonStyle(.plain)
		}
	}

	private func optionsLabel(_ count: Int) -> String {
		let remainder10 = count % 10
		let remainder100 = count % 100

		let suffix: String
		if remainder10 == 1 && remainder100 != 11 {
			suffix = "вариант"
		} else if (2...4).contains(remainder10) && !(12...14).contains(remainder100) {
			suffix = "варианта"
		} else {
			suffix = "вариантов"
		}

		return "\(count) \(suffix)"
	}
}
