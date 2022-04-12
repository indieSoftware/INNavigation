//
//  SwiftUIFirstView.swift
//  NavigationStackExampleDemo
//
//  Created by Alex Nagy on 08.03.2022.
//

import SwiftUI

struct SwiftUIFirstView: View {
	@State private var isNavigationLinkActive = false
	@State private var isSheetPresented = false
	#if !os(macOS)
		@State private var isFullScreenCoverPresented = false
	#endif

	var body: some View {
		ScrollView {
			Button {
				isSheetPresented.toggle()
			} label: {
				Text("SwiftUISecondView .sheet")
			}
			.sheet(isPresented: $isSheetPresented) {
				print("onDismiss")
			} content: {
				SwiftUISecondView()
			}

			#if !os(macOS)
				Button {
					isFullScreenCoverPresented.toggle()
				} label: {
					Text("SwiftUISecondView .fullScreenCover")
				}
				.fullScreenCover(isPresented: $isFullScreenCoverPresented) {
					print("onDismiss")
				} content: {
					SwiftUISecondView()
				}
			#endif

			Divider()

			#if !os(macOS)
				NavigationLink {
					SwiftUISecondView()
				} label: {
					Text("SwiftUISecondView NavigationLink")
				}

			#else
				NavigationLink {
					SwiftUIThirdView()
				} label: {
					Text("SwiftUIThirdView NavigationLink")
				}
			#endif

			Button {
				isNavigationLinkActive.toggle()
			} label: {
				Text("SwiftUIFourthView NavigationLink isActive")
			}

			NavigationLink(isActive: $isNavigationLinkActive) {
				SwiftUIFourthView()
			} label: {
				EmptyView()
			}
			.hidden()
			.frame(height: 0)
		}
		.navigationInlineTitle("SwiftUI First")
	}
}

struct SwiftUIFirstView_Previews: PreviewProvider {
	static var previews: some View {
		SwiftUIFirstView()
	}
}
