import SwiftUI

struct AppearanceSelectionCard: View {
	// MARK: - Properties

	let title: String
	let description: String
	let isSelected: Bool

	// MARK: - Body

	var body: some View {
		HStack(spacing: Margin.x4) {
			VStack(alignment: .leading, spacing: Margin.x(1.5)) {
				Text(title)
					.appTypography(.settingsCardTitle)
					.foregroundColor(Color.Theme.white)
					.multilineTextAlignment(.leading)

				Text(description)
					.appTypography(.settingsCardBody)
					.foregroundColor(Color.Overlay.textSecondary)
					.multilineTextAlignment(.leading)
			}

			Spacer(minLength: .appearanceCardSpacerLength)

			Image(systemName: isSelected ? SFSymbols.checkmarkCircleFill : SFSymbols.circle)
				.font(.system(size: .appearanceCardIndicatorSize, weight: .bold))
				.foregroundColor(isSelected ? Color.Theme.uiAccentLime : Color.HUD.textMuted)
		}
		.padding(.horizontal, Margin.x5)
		.padding(.vertical, Margin.x4)
		.frame(maxWidth: .infinity, alignment: .leading)
		.background(backgroundColor)
		.clipShape(RoundedRectangle(cornerRadius: .appearanceCardCornerRadius))
		.overlay {
			RoundedRectangle(cornerRadius: .appearanceCardCornerRadius)
				.stroke(borderColor, lineWidth: .appearanceCardBorderWidth)
		}
	}

	// MARK: - Private properties

	private var backgroundColor: Color {
		isSelected
			? Color.Theme.uiAccentLime.opacity(.appearanceCardSelectedSurfaceOpacity)
			: Color.HUD.surface.opacity(.appearanceCardSurfaceOpacity)
	}

	private var borderColor: Color {
		isSelected ? Color.Theme.uiAccentLime : Color.HUD.divider
	}
}

// MARK: - Preview

#Preview {
	VStack(spacing: Margin.x2) {
		AppearanceSelectionCard(
			title: "Кибер-грузчица",
			description: "Неоновый визор, антенна и персональный дрон.",
			isSelected: true
		)

		AppearanceSelectionCard(
			title: "Грузчик-ветеран",
			description: "Потёртая каска и рабочая форма.",
			isSelected: false
		)
	}
	.padding(Margin.x8)
	.background(FlowPreviewSupport.canvas)
}

// MARK: - Constants

private extension CGFloat {
	static let appearanceCardSpacerLength = 8.0
	static let appearanceCardIndicatorSize = 18.0
	static let appearanceCardCornerRadius = 4.0
	static let appearanceCardBorderWidth = 2.0
}

private extension Double {
	static let appearanceCardSurfaceOpacity = 0.92
	static let appearanceCardSelectedSurfaceOpacity = 0.16
}
