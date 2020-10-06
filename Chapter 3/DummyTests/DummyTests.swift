import XCTest
import Dummy


final class DummyTests: XCTestCase {
    func testDummy() throws {
        let dummy = Dummy(dummyVariable: 0)
        print(dummy)
    }
}
