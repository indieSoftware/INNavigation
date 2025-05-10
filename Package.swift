// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "INNavigation",
    platforms: [.iOS("16.0")],
    products: [
        .library(
            name: "INNavigation",
            targets: ["INNavigation"]
		),
    ],
    dependencies: [
		.package(url: "https://github.com/indieSoftware/INCommons.git", from: "4.1.0"),
    ],
    targets: [
        .target(
            name: "INNavigation",
            dependencies: ["INCommons"]
		),
        .testTarget(
            name: "INNavigationTests",
            dependencies: ["INNavigation", "INCommons"]
		),
	],
	swiftLanguageModes: [
		.v5, .version("6")
	]
)
