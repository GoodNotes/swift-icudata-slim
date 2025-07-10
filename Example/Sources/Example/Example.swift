import Foundation

@main
struct Example {
    static func main() {
        print("Current locale: \(Locale.current.identifier)")
        print("Available locales: \(Locale.availableIdentifiers)")
        print("Available encodings: \(String.availableStringEncodings)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        print("Parsing date: \(dateFormatter.date(from: "2023-10-01T12:00:00").map { "\($0)" } ?? "Failed to parse date!?")")
    }
}
