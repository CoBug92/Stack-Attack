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
		case .loader: "Грузчик"
		case .nightLoader: "Ночной грузчик"
		case .veteranLoader: "Грузчик-ветеран"
		case .cyberLoader: "Кибер-грузчица"
		}
	}

	var description: String {
		switch self {
		case .loader: "Каска, жилет и рабочие перчатки"
		case .nightLoader: "Светоотражающий жилет для ночной смены"
		case .veteranLoader: "Потёртая каска и рабочая форма"
		case .cyberLoader: "Неоновый визор, антенна и персональный дрон"
		}
	}
}
