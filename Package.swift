// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "PayKit",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
        ],
    products: [
        .library(
            name: "PayKit",
            targets: ["PayKit"]
        ),
        .library(
            name: "PayKitUI",
            targets: ["PayKitUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftGen/SwiftGenPlugin.git", from: "6.6.2"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.9.0"),
    ],
    targets: [
        .target(
            name: "PayKit",
            swiftSettings: [
                .define("LOGGING", .when(configuration: .debug))
              ]
        ),
        .target(
            name: "PayKitUI",
            resources: [
                .copy("custom-xcassets-template.stencil"),
                .copy("Shared/Assets/Resources/Colors.xcassets"),
                .copy("swiftgen.yml"),
                .copy("Shared/Assets/Resources/Images.xcassets"),
            ], plugins: [
                .plugin(name: "SwiftGenPlugin", package: "SwiftGenPlugin"),
            ]
        ),
        .testTarget(
            name: "PayKitTests",
            dependencies: ["PayKit"],
            resources: [
                    .copy("Resources/Fixtures"),
                    .copy("Resources/Fixtures/Errors"),
                  ]
        ),
        .testTarget(
            name: "PayKitUITests",
            dependencies: [
                "PayKitUI",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            resources: [
                    .copy("__Snapshots__/"),
                  ]
        )
    ]
)
