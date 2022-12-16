import Foundation
import XCTest

enum TestResources {
    static var path: String {
        URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("TestData")
            .path
    }
}

extension XCTestCase {
    var testResourcesPath: String { TestResources.path }
}
