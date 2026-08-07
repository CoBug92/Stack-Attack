import Foundation

enum BackgroundAppearance: String, CaseIterable, Identifiable {
	case port
	case nightWarehouse
	case sunsetYard
	case cyberCity

	var id: String { rawValue }
}

extension BackgroundAppearance {
	var title: String {
		switch self {
		case .port: Localizations.Appearance.Background.Port.title
		case .nightWarehouse: Localizations.Appearance.Background.Warehouse.title
		case .sunsetYard: Localizations.Appearance.Background.Sunset.title
		case .cyberCity: Localizations.Appearance.Background.Cyber.title
		}
	}

	var description: String {
		switch self {
		case .port: Localizations.Appearance.Background.Port.description
		case .nightWarehouse: Localizations.Appearance.Background.Warehouse.description
		case .sunsetYard: Localizations.Appearance.Background.Sunset.description
		case .cyberCity: Localizations.Appearance.Background.Cyber.description
		}
	}
}
