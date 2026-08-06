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
		case .gantry: "Портальный манипулятор"
		case .magnetic: "Магнитный манипулятор"
		case .drone: "Грузовой дрон"
		}
	}

	var description: String {
		switch self {
		case .gantry: "Стальной захват на верхнем тросе"
		case .magnetic: "Неоновый магнитный подъёмник"
		case .drone: "Автономный дрон с роторами"
		}
	}
}
