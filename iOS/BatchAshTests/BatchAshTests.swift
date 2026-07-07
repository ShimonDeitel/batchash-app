import XCTest
@testable import BatchAsh

@MainActor
final class BatchAshTests: XCTestCase {
    var store: Store!

    override func setUp() {
        super.setUp()
        store = Store()
        store.entries = []
    }

    func testSeedEmptyThenSeeds() {
        store.seed()
        XCTAssertEqual(store.entries.count, 3)
    }

    func testAddEntry() {
        store.entries = []
        store.add(name: "Test Item", recipe: "x", cone: "x", surface: "x", notes: "x")
        XCTAssertEqual(store.entries.count, 1)
        XCTAssertEqual(store.entries.first?.name, "Test Item")
    }

    func testFreeLimitAboveSeed() {
        XCTAssertGreaterThan(Store.freeLimit, 3)
    }

    func testCanAddMoreWhenUnderLimit() {
        store.entries = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        store.isPro = false
        store.entries = (0..<Store.freeLimit).map { i in
            Test TileEntry(name: "Item \(i)", recipe: "", cone: "", surface: "", notes: "")
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testProBypassesLimit() {
        store.isPro = true
        store.entries = (0..<Store.freeLimit).map { i in
            Test TileEntry(name: "Item \(i)", recipe: "", cone: "", surface: "", notes: "")
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testDeleteEntry() {
        store.entries = []
        store.add(name: "ToDelete", recipe: "x", cone: "x", surface: "x", notes: "x")
        let entry = store.entries.first!
        store.delete(entry)
        XCTAssertTrue(store.entries.isEmpty)
    }

    func testUpdateEntry() {
        store.entries = []
        store.add(name: "Original", recipe: "x", cone: "x", surface: "x", notes: "x")
        var entry = store.entries.first!
        entry.name = "Updated"
        store.update(entry)
        XCTAssertEqual(store.entries.first?.name, "Updated")
    }
}
