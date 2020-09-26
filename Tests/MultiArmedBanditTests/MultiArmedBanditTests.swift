import XCTest
import MultiArmedBandit
import class Foundation.Bundle


final class MultiArmedBanditTests: XCTestCase {
    static var allTests = [
        ("testRandomActions", testRandomActions),
        ("testExample", testExample),
    ]
    
    func testRandomActions() {
        let bandit = MultiArmedBandit(armCount: 10)
        
        var state = bandit.initialState
        for i in 0...100 {
            precondition(!state.legalActions.isEmpty)
            
            let randomAction = state.legalActions.randomElement()!
            state = state.applying(randomAction)
        }
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.

        // Some of the APIs that we use below are available in macOS 10.13 and above.
        guard #available(macOS 10.13, *) else {
            return
        }

        let fooBinary = productsDirectory.appendingPathComponent("MultiArmedBandit")

        let process = Process()
        process.executableURL = fooBinary

        let pipe = Pipe()
        process.standardOutput = pipe

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        XCTAssertEqual(output, "Hello, world!\n")
    }

    /// Returns path to the built products directory.
    var productsDirectory: URL {
      #if os(macOS)
        for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
            return bundle.bundleURL.deletingLastPathComponent()
        }
        fatalError("couldn't find the products directory")
      #else
        return Bundle.main.bundleURL
      #endif
    }
}
