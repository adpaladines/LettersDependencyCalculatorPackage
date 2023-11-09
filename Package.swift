// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "LettersDependencyCalculatorPackage",
    products: [
        .library(
            name: "LettersDependencyCalculatorPackage",
            targets: ["LettersDependencyCalculatorPackage"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LettersDependencyCalculatorPackage",
            dependencies: []),
        .testTarget(
            name: "LettersDependencyCalculatorPackageTests",
            dependencies: ["LettersDependencyCalculatorPackage"]),
    ]
)
