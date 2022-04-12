//
//  SettingsSecondView.swift
//  NavigationStackExampleDemo
//
//  Created by Alex Nagy on 08.03.2022.
//

import SwiftUI

struct SettingsSecondView: View {
	@Binding var post: Post

	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack {
			TextField("Post title", text: $post.title)
			#if !os(tvOS) && !os(watchOS)
				.textFieldStyle(.roundedBorder)
			#endif
			#if os(watchOS)
				Button {
					dismiss()
				} label: {
					Text("Dismiss")
				}
			#endif
		}
		.padding()
		.navigationTitle("Settings Second")
	}
}
