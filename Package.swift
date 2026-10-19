// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftRetainCycleAsyncCallbackDemo",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "retain-cycle-demo", targets: ["RetainCycleDemo"])],
    targets: [.executableTarget(name: "RetainCycleDemo")]
)
