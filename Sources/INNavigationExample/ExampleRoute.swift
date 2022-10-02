import INNavigation
import SwiftUI

enum ExampleRoute: Route {
	case exampleView(title: String)

	var view: some View {
		switch self {
		case let .exampleView(title):
			return ExampleView(title: title)
		}
	}
}
