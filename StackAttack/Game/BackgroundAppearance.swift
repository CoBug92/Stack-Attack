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
		case .port: "Порт №35"
		case .nightWarehouse: "Ночной склад"
		case .sunsetYard: "Терминал на закате"
		case .cyberCity: "Кибер-город"
		}
	}

	var description: String {
		switch self {
		case .port: "Контейнерный порт у воды"
		case .nightWarehouse: "Стеллажи и холодный рабочий свет"
		case .sunsetYard: "Тёплый свет над грузовым двором"
		case .cyberCity: "Дождливые неоновые небоскрёбы"
		}
	}
}
