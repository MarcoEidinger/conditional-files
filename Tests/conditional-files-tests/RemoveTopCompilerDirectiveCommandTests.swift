@testable import conditional_files
import XCTest

final class RemoveTopCompilerDirectiveCommandTests: XCTestCase {
    func testRemoveSuccess() {
        let input = """
        #if DEBUG
        // code
        #endif
        """
        let expectedOutput = """
        // code
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = RemoveTopCompilerDirectiveCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]

        command.run()

        XCTAssertEqual(stub.updatedFileContent, expectedOutput)
    }

    func testRemoveMiss() {
        let input = """
        // code
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = RemoveTopCompilerDirectiveCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]

        command.run()

        XCTAssertNil(stub.updatedFileContent)
    }
}
