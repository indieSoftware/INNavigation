//
//  PostsSecondView.swift
//  NavigationStackExampleDemo
//
//  Created by Alex Nagy on 08.03.2022.
//

import SwiftUI

struct PostsSecondView: View {
	var post: Post

	@Environment(\.dismiss) private var dismiss

	var body: some View {
		VStack {
			Text("Hello, \(post.title)!")
			#if !os(macOS)
				Button {
					dismiss()
				} label: {
					Text("Dismiss")
				}
			#endif
		}
		.navigationTitle("Post")
	}
}
