import XCTest
@testable import RCT

private struct DummyManagedObject: Codable, Equatable {
    let value: String
}

private struct DummyPersistable: Persistable {
    let value: String

    init(managedObject: DummyManagedObject) {
        self.value = managedObject.value
    }

    func managedObject() -> DummyManagedObject {
        DummyManagedObject(value: value)
    }
}

final class PersistableTests: XCTestCase {
    func testPersistableRoundTrip() {
        let managed = DummyManagedObject(value: "abc")

        let entity = DummyPersistable(managedObject: managed)
        let back = entity.managedObject()

        XCTAssertEqual(back, managed)
    }
}
