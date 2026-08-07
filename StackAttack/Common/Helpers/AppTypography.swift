import SpriteKit
import SwiftUI
import UIKit

enum AppTypography {
	// MARK: - Types

	enum Style {
		case appTitle
		case overlayKicker
		case overlayTitle
		case body
		case primaryButton
		case secondaryButton
		case settingsSectionTitle
		case settingsCardTitle
		case settingsCardBody
		case settingsCardMeta
		case scoreboardLabel
		case scoreboardValue
	}

	enum SceneStyle {
		case hudLabel
		case effectStar
	}

	struct Attributes {
		let font: Font
		let tracking: CGFloat
		let lineSpacing: CGFloat
	}

	struct SceneAttributes {
		let fontName: String
		let fontSize: CGFloat
	}

	// MARK: - Public methods

	static func attributes(for style: Style) -> Attributes {
		switch style {
		case .appTitle:
			Attributes(
				font: .system(.title, design: .monospaced).weight(.black),
				tracking: .appTitleTracking,
				lineSpacing: 0
			)
		case .overlayKicker:
			Attributes(
				font: .system(.caption, design: .monospaced).weight(.bold),
				tracking: .overlayKickerTracking,
				lineSpacing: 0
			)
		case .overlayTitle:
			Attributes(
				font: .system(.title, design: .monospaced).weight(.black),
				tracking: .overlayTitleTracking,
				lineSpacing: 0
			)
		case .body:
			Attributes(
				font: .body,
				tracking: 0,
				lineSpacing: Margin.x1
			)
		case .primaryButton:
			Attributes(
				font: .system(.subheadline, design: .monospaced).weight(.black),
				tracking: 0,
				lineSpacing: 0
			)
		case .secondaryButton:
			Attributes(
				font: .system(.footnote, design: .monospaced).weight(.bold),
				tracking: 0,
				lineSpacing: 0
			)
		case .settingsSectionTitle:
			Attributes(
				font: .subheadline.weight(.semibold),
				tracking: 0,
				lineSpacing: 0
			)
		case .settingsCardTitle:
			Attributes(
				font: .subheadline.weight(.bold),
				tracking: 0,
				lineSpacing: 0
			)
		case .settingsCardBody:
			Attributes(
				font: .footnote,
				tracking: 0,
				lineSpacing: 0
			)
		case .settingsCardMeta:
			Attributes(
				font: .system(.caption, design: .monospaced).weight(.bold),
				tracking: .metaTracking,
				lineSpacing: 0
			)
		case .scoreboardLabel:
			Attributes(
				font: .system(.caption2, design: .monospaced),
				tracking: .metaTracking,
				lineSpacing: 0
			)
		case .scoreboardValue:
			Attributes(
				font: .system(.title3, design: .monospaced).weight(.bold),
				tracking: .metaTracking,
				lineSpacing: 0
			)
		}
	}

	static func sceneAttributes(for style: SceneStyle) -> SceneAttributes {
		switch style {
		case .hudLabel:
			SceneAttributes(
				fontName: UIFont.monospacedSystemFont(ofSize: .hudLabelSize, weight: .bold).fontName,
				fontSize: .hudLabelSize
			)
		case .effectStar:
			SceneAttributes(
				fontName: UIFont.monospacedSystemFont(ofSize: .effectStarSize, weight: .bold).fontName,
				fontSize: .effectStarSize
			)
		}
	}
}

// MARK: - View modifier

private struct AppTypographyModifier: ViewModifier {
	let attributes: AppTypography.Attributes

	func body(content: Content) -> some View {
		content
			.font(attributes.font)
			.tracking(attributes.tracking)
			.lineSpacing(attributes.lineSpacing)
	}
}

extension View {
	func appTypography(_ style: AppTypography.Style) -> some View {
		modifier(AppTypographyModifier(attributes: AppTypography.attributes(for: style)))
	}
}

extension SKLabelNode {
	func applyTypography(_ style: AppTypography.SceneStyle) {
		let attributes = AppTypography.sceneAttributes(for: style)
		fontName = attributes.fontName
		fontSize = attributes.fontSize
	}
}

// MARK: - Constants

private extension CGFloat {
	static let appTitleTracking = -1.5
	static let overlayKickerTracking = 1.7
	static let overlayTitleTracking = -1.4
	static let metaTracking = 1.2
	static let hudLabelSize = 9.0
	static let effectStarSize = 13.0
}
