// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "testcool",
    platforms: [
        .macOS(.v15),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-crypto.git", "1.0.0" ..< "5.0.0"),
        .package(url: "https://github.com/stossy11/StosSign.git", revision: "main"),
        .package(url: "https://github.com/SideStore/MacAnisette.git", revision: "main"),
        .package(url: "https://github.com/OpenSwiftUIProject/OpenSwiftUI.git", branch: "main"),
        // https://github.com/SideStore/MacAnisette
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "testcool",
            dependencies: [
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "StosSign_Auth", package: "StosSign"),
                .product(name: "OpenSwiftUI", package: "OpenSwiftUI"),
                .product(name: "MacAnisette", package: "MacAnisette", condition: .when(platforms: [.macOS])),
            ]
        ),
    ]
)
