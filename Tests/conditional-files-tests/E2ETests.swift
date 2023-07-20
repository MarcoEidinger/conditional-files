@testable import conditional_files
import XCTest

final class E2ETest: XCTestCase {
    var testFileContent: String {
        """
        // code
        """
    }

    var testFilePath: String {
        FileManager.default.currentDirectoryPath + "/test.txt"
    }

    override func setUp() {
        createTestFile()
    }

    override func tearDown() {
        deleteTestFile()
    }

    func testOSCommand() {
        var command = OSCommand()
        command.operatingSystems = [.ios]
        command.options = PathFileOptions()
        command.options.paths = [testFilePath]
        command.remove = false

        command.run()

        let updatedContent = readTestFileContent()

        let expectedOutput = """
        #if os(iOS)
        // code
        #endif
        """

        XCTAssertEqual(updatedContent, expectedOutput)
    }
    
    func testOSCommandForVisionOS() {
        var command = OSCommand()
        command.operatingSystems = [.visionOS]
        command.options = PathFileOptions()
        command.options.paths = [testFilePath]
        command.remove = false

        command.run()

        let updatedContent = readTestFileContent()

        let expectedOutput = """
        #if os(xrOS)
        // code
        #endif
        """

        XCTAssertEqual(updatedContent, expectedOutput)
    }

    func createTestFile() {
        FileManager.default.createFile(atPath: testFilePath, contents: testFileContent.data(using: .utf8), attributes: nil)
    }

    func deleteTestFile() {
        try? FileManager.default.removeItem(atPath: testFilePath)
    }

    func readTestFileContent() -> String? {
        try? String(contentsOfFile: testFilePath, encoding: .utf8)
    }
}
