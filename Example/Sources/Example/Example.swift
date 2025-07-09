// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@main
struct Example {
    static func main() {
        print("Available locales: \(Locale.availableIdentifiers.joined(separator: ", "))")
        print("Available encodings: \(String.availableStringEncodings.map { "\($0)" }.joined(separator: ", "))")
    }
}
