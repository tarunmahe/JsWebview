// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Admobads",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "Admobads",
            targets: ["AdmobControllerPlugin"])
    ],
    dependencies: [
        .package(url: "https://github.com/ionic-team/capacitor-swift-pm.git", from: "7.0.0")
    ],
    targets: [
        .target(
            name: "AdmobControllerPlugin",
            dependencies: [
                .product(name: "Capacitor", package: "capacitor-swift-pm"),
                .product(name: "Cordova", package: "capacitor-swift-pm")
            ],
            path: "ios/Sources/AdmobControllerPlugin"),
        .testTarget(
            name: "AdmobControllerPluginTests",
            dependencies: ["AdmobControllerPlugin"],
            path: "ios/Tests/AdmobControllerPluginTests")
    ]
)