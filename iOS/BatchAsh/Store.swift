import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var entries: [Test TileEntry] = []
    @Published var isPro: Bool = false

    static let freeLimit = 23

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("batchash_entries.json")
    }()

    init() {
        load()
        if entries.isEmpty {
            seed()
        }
    }

    func seed() {
        entries = [
        Test TileEntry(name: "Celadon Base 12", recipe: "Feldspar 40 / Silica 30 / Whiting 20 / Kaolin 10", cone: "Cone 6", surface: "Glossy", notes: "Slight crawling on rim"),
        Test TileEntry(name: "Iron Speckle", recipe: "Base + 4% iron oxide, 2% rutile", cone: "Cone 10", surface: "Satin", notes: "Great speckle on stoneware"),
        Test TileEntry(name: "Shino Test A", recipe: "Soda feldspar 70 / Ball clay 20 / Nepheline 10", cone: "Cone 10 reduction", surface: "Matte", notes: "Orange peel texture")
        ]
        save()
    }

    var canAddMore: Bool {
        isPro || entries.count < Store.freeLimit
    }

    func add(recipe: String, cone: String, surface: String, notes: String) {
        guard canAddMore else { return }
        let entry = Test TileEntry(name: name, recipe: recipe, cone: cone, surface: surface, notes: notes)
        entries.insert(entry, at: 0)
        save()
    }

    func update(_ entry: Test TileEntry) {
        if let idx = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[idx] = entry
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
        save()
    }

    func delete(_ entry: Test TileEntry) {
        entries.removeAll { $0.id == entry.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([Test TileEntry].self, from: data) {
            entries = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
