@testable import conditional_files
import XCTest

final class GenericCommandTests: XCTestCase {
    func testBasicInsert() {
        let input = "// code"
        let expectedOutput = """
        top
        // code
        bottom
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = GenericCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.top = "top"
        command.bottom = "bottom"
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]
        command.undo = false

        command.run()

        XCTAssertEqual(stub.updatedFileContent, expectedOutput)
    }
}
