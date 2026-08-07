import Foundation

enum ManipulatorAppearance: String, CaseIterable, Identifiable {
	case gantry
	case magnetic
	case drone

	var id: String { rawValue }
}

extension ManipulatorAppearance {
	var title: String {
		switch self {
		case .gantry: Localizations.Appearance.Manipulator.Gantry.title
		case .magnetic: Localizations.Appearance.Manipulator.Magnetic.title
		case .drone: Localizations.Appearance.Manipulator.Drone.title
		}
	}

	var description: String {
		switch self {
		case .gantry: Localizations.Appearance.Manipulator.Gantry.description
		case .magnetic: Localizations.Appearance.Manipulator.Magnetic.description
		case .drone: Localizations.Appearance.Manipulator.Drone.description
		}
	}
}
