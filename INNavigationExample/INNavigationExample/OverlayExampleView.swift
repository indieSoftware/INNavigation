import INNavigation
import SwiftUI

struct OverlayExampleView: View {
	@StateObject
	var viewModel: OverlayExampleViewModel

	init(viewModel: OverlayExampleViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	var body: some View {
		ZStack {
			Rectangle()
				.foregroundColor(.yellow)
				.edgesIgnoringSafeArea(.all)
			Button {
				withAnimation {
					viewModel.overlayIsShown.toggle()
				}
			} label: {
				Text("PRESENT")
			}
		}
	}
}

extension Route {
	struct OverlayExampleScreen: Screen {
		let id: String = UUID().uuidString
		var contentView: AnyView {
			AnyView(
				OverlayExampleView(
					viewModel: viewModel
				)
			)
		}

		var viewModel: OverlayExampleViewModel

		init(viewModel: OverlayExampleViewModel) {
			self.viewModel = viewModel
		}

		func navigationBar(namespaceId _: Namespace.ID) -> AnyView? {
			nil
		}

		func overlayView() -> AnyView? {
			AnyView(
				OverlayView()
					.environmentObject(viewModel)
			)
		}
	}

	@MainActor
	static func overlayExample(viewModel: OverlayExampleViewModel) -> Route {
		Route(OverlayExampleScreen(viewModel: viewModel))
	}
}

@MainActor
final class OverlayExampleViewModel: ObservableObject, Sendable {
	@Published
	var overlayIsShown: Bool = false
}

struct OverlayView: View {
	@EnvironmentObject
	var viewModel: OverlayExampleViewModel
	var body: some View {
		if viewModel.overlayIsShown {
			ZStack {
				Rectangle()
					.foregroundColor(.green)
					.opacity(0.9)
				Button {
					viewModel.overlayIsShown.toggle()
				} label: {
					Text("DISMISS")
				}
			}
		}
	}
}
