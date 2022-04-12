//
//  HomeThirdView.swift
//  NavigationStackExampleDemo
//
//  Created by Alex Nagy on 08.03.2022.
//

import SwiftUI

struct HomeThirdView: View {
	@EnvironmentObject private var homeContainerNavigation: HomeContainer.Navigation

	var title: String

	var body: some View {
		ScrollView {
			#if !os(macOS)
				Button {
					pushHomeFourthView()
				} label: {
					Text("Push HomeFourthView")
				}
			#else
				Button {
					pushHomeFourthView()
				} label: {
					Text("Replace with HomeFourthView")
				}
			#endif

			Button {
				presentHomeFourthView()
			} label: {
				Text("Present HomeFourthView")
			}

			Button {
				pop()
			} label: {
				Text("Pop")
			}
		}
		.navigationTitle(title)
		#if os(macOS)
			.frame(width: 300, height: 300)
		#endif
	}

	func pushHomeFourthView() {
		$homeContainerNavigation.flow.present(.homeFourth)
	}

	func presentHomeFourthView() {
		$homeContainerNavigation.flow.present(.homeFourth, options: .init(style: .sheet))
	}

	func pop() {
		$homeContainerNavigation.flow.pop()
	}
}
