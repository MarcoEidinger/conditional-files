@testable import conditional_files
import XCTest

final class FileCollectorTests: XCTestCase {
    func testAllFilesStartingFromDirectoryBlank() {
        let testDir = TestResources.path
        let files = FileCollector().getFiles(for: [""], in: testDir)
        XCTAssertEqual(files.count, 2)
    }

    func testAllFilesStartingFromDirectoryDot() {
        let testDir = TestResources.path
        let files = FileCollector().getFiles(for: ["."], in: testDir)
        XCTAssertEqual(files.count, 2)
    }

    func testSingleFile() {
        let testDir = TestResources.path
        let files = FileCollector().getFiles(for: ["test.swift"], in: testDir)
        XCTAssertEqual(files.count, 1)
    }

    func testMultipleFiles() {
        let testDir = TestResources.path
        let files = FileCollector().getFiles(for: ["test.swift", "test2.swift"], in: testDir)
        XCTAssertEqual(files.count, 2)
    }
}
