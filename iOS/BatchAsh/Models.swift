import Foundation

struct TestTileEntry: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var name: String
    var recipe: String
    var cone: String
    var surface: String
    var notes: String
    var dateCreated: Date = Date()
}
