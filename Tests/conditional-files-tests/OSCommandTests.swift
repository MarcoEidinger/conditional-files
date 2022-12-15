@testable import conditional_files
import XCTest

final class OSCommandTests: XCTestCase {
    func testBasicInsert() {
        let input = ""
        let expectedOutput = """
        #if os(iOS)
        #endif
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = OSCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.operatingSystems = [.ios]
        command.options = PathFileOptions()
        command.options.paths = ["Tests/conditional-files-tests/test.txt"]
        command.undo = false

        command.run()

        XCTAssertEqual(stub.updatedFileContent, expectedOutput)
    }
}
