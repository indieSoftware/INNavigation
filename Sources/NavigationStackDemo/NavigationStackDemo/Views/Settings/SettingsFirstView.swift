//
//  SettingsFirstView.swift
//  NavigationStackExampleDemo
//
//  Created by Alex Nagy on 08.03.2022.
//

import SwiftUI

struct SettingsFirstView: View {
	@State private var post = Post(title: "Edit me")
	@EnvironmentObject private var settingsContainerNavigation: SettingsContainer.Navigation

	var body: some View {
		ScrollView {
			Text("Post title: \(post.title)")
			Button {
				pushSettingsSecondView()
			} label: {
				Text("Push SettingsSecondView")
			}
			#if !os(macOS)
				Button {
					presentSettingsSecondView()
				} label: {
					Text("Present SettingsSecondView")
				}
			#endif
		}
		.navigationTitle("Settings first")
	}

	func pushSettingsSecondView() {
		$settingsContainerNavigation.flow.present(.settingsSecond(post: $post))
	}

	func presentSettingsSecondView() {
		$settingsContainerNavigation.flow.present(.settingsSecond(post: $post), options: .init(style: .sheet))
	}
}

struct SettingsFirstView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsFirstView()
	}
}
