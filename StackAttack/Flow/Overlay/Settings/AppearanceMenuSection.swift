import SwiftUI

struct AppearanceMenuSection: View {
	// MARK: - Properties

	let title: String
	let optionCount: Int
	let previewContent: AppearancePreviewView.Content
	let selectedTitle: String
	let selectedDescription: String
	let action: () -> Void

	// MARK: - Body

	var body: some View {
		Button(action: action) {
			VStack(alignment: .leading, spacing: Margin.x2) {
				HStack(alignment: .firstTextBaseline, spacing: Margin.x4) {
					Text(title)
						.appTypography(.settingsSectionTitle)
						.foregroundColor(Color.Theme.white)

					Spacer(minLength: Margin.x4)

					Text(optionsLabel(optionCount))
						.appTypography(.settingsCardMeta)
						.foregroundColor(Color.HUD.textMuted)
				}

				HStack(spacing: Margin.x4) {
					AppearancePreviewView(content: previewContent)
						.frame(width: .appearanceMenuPreviewWidth)
						.allowsHitTesting(false)

					VStack(alignment: .leading, spacing: Margin.x(1.5)) {
						Text(selectedTitle)
							.appTypography(.settingsCardTitle)
							.foregroundColor(Color.Theme.white)

						Text(selectedDescription)
							.appTypography(.settingsCardBody)
							.foregroundColor(Color.Overlay.textSecondary)
							.multilineTextAlignment(.leading)
					}

					Spacer(minLength: Margin.x4)

					Image(systemName: SFSymbols.chevronRight)
						.font(.system(size: .appearanceMenuIndicatorSize, weight: .bold))
						.foregroundColor(Color.Theme.uiAccentLime)
				}
				.padding(.horizontal, Margin.x5)
				.padding(.vertical, Margin.x4)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(Color.HUD.surface.opacity(.appearanceMenuSurfaceOpacity))
				.clipShape(RoundedRectangle(cornerRadius: .appearanceMenuCornerRadius))
				.overlay {
					RoundedRectangle(cornerRadius: .appearanceMenuCornerRadius)
						.stroke(Color.HUD.divider, lineWidth: .appearanceMenuBorderWidth)
				}
			}
		}
		.buttonStyle(.plain)
	}

	// MARK: - Private methods

	private func optionsLabel(_ count: Int) -> String {
		let remainder10 = count % 10
		let remainder100 = count % 100

		let suffix: String
		if remainder10 == .singularVariantRemainder && remainder100 != .singularVariantException {
			suffix = .variantSingular
		} else if Int.fewVariantRemainders.contains(remainder10) && !Int.fewVariantExceptions.contains(remainder100) {
			suffix = .variantFew
		} else {
			suffix = .variantMany
		}

		return "\(count) \(suffix)"
	}
}

// MARK: - Preview

#Preview {
	AppearanceMenuSection(
		title: "Грузчик",
		optionCount: 3,
		previewContent: .player(.cyberLoader),
		selectedTitle: "Кибер-грузчица",
		selectedDescription: "Неоновый визор, антенна и персональный дрон."
	) {}
	.padding(Margin.x8)
	.background(FlowPreviewSupport.canvas)
}

// MARK: - Constants

private extension CGFloat {
	static let appearanceMenuPreviewWidth = 68.0
	static let appearanceMenuIndicatorSize = 14.0
	static let appearanceMenuCornerRadius = 4.0
	static let appearanceMenuBorderWidth = 2.0
}

private extension Double {
	static let appearanceMenuSurfaceOpacity = 0.92
}

private extension Int {
	static let singularVariantRemainder = 1
	static let singularVariantException = 11
	static let fewVariantRemainders = 2...4
	static let fewVariantExceptions = 12...14
}

private extension String {
	static let variantSingular = "вариант"
	static let variantFew = "варианта"
	static let variantMany = "вариантов"
}
