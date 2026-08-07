import Foundation

enum PlayerAppearance: String, CaseIterable, Identifiable {
	case loader
	case nightLoader
	case veteranLoader
	case cyberLoader

	var id: String { rawValue }
}

extension PlayerAppearance {
	var title: String {
		switch self {
		case .loader: Localizations.Appearance.Player.Loader.title
		case .nightLoader: Localizations.Appearance.Player.Night.title
		case .veteranLoader: Localizations.Appearance.Player.Veteran.title
		case .cyberLoader: Localizations.Appearance.Player.Cyber.title
		}
	}

	var description: String {
		switch self {
		case .loader: Localizations.Appearance.Player.Loader.description
		case .nightLoader: Localizations.Appearance.Player.Night.description
		case .veteranLoader: Localizations.Appearance.Player.Veteran.description
		case .cyberLoader: Localizations.Appearance.Player.Cyber.description
		}
	}
}
