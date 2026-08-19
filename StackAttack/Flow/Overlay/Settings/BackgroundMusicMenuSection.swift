import SwiftUI

struct BackgroundMusicMenuSection: View {
	// MARK: - Properties

	let title: String
	let optionCount: Int
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

					Text(Localizations.Settings.options(optionCount))
						.appTypography(.settingsCardMeta)
						.foregroundColor(Color.HUD.textMuted)
				}

				HStack(spacing: Margin.x4) {
					Image(systemName: SFSymbols.musicNote)
						.font(.system(size: .backgroundMusicIconSize, weight: .semibold))
						.foregroundColor(Color.Theme.uiAccentLime)
						.frame(width: .backgroundMusicIconFrame, height: .backgroundMusicIconFrame)
						.background(Color.Theme.uiAccentLime.opacity(.backgroundMusicIconSurfaceOpacity))
						.clipShape(RoundedRectangle(cornerRadius: .backgroundMusicIconCornerRadius))

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
						.font(.system(size: .backgroundMusicIndicatorSize, weight: .bold))
						.foregroundColor(Color.Theme.uiAccentLime)
				}
				.padding(.horizontal, Margin.x5)
				.padding(.vertical, Margin.x4)
				.frame(maxWidth: .infinity, alignment: .leading)
				.background(Color.HUD.surface.opacity(.backgroundMusicSurfaceOpacity))
				.clipShape(RoundedRectangle(cornerRadius: .backgroundMusicCornerRadius))
				.overlay {
					RoundedRectangle(cornerRadius: .backgroundMusicCornerRadius)
						.stroke(Color.HUD.divider, lineWidth: .backgroundMusicBorderWidth)
				}
			}
		}
		.buttonStyle(.plain)
	}
}

// MARK: - Preview

#Preview {
	BackgroundMusicMenuSection(
		title: Localizations.Settings.music,
		optionCount: BackgroundMusicTrack.allCases.count,
		selectedTitle: Localizations.Music.PuzzleGame.title,
		selectedDescription: Localizations.Music.PuzzleGame.description
	) {}
	.padding(Margin.x8)
	.background(FlowPreviewSupport.canvas)
}

// MARK: - Constants

private extension CGFloat {
	static let backgroundMusicIconSize = 18.0
	static let backgroundMusicIconFrame = 68.0
	static let backgroundMusicIndicatorSize = 14.0
	static let backgroundMusicCornerRadius = 4.0
	static let backgroundMusicIconCornerRadius = 4.0
	static let backgroundMusicBorderWidth = 2.0
}

private extension Double {
	static let backgroundMusicSurfaceOpacity = 0.92
	static let backgroundMusicIconSurfaceOpacity = 0.16
}
