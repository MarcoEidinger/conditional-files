@testable import conditional_files
import XCTest

final class FindCommandTests: XCTestCase {
    func testFindSuccess() throws {
        let input = """
          #if DEBUG
            // code
          #endif
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = FindCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]

        try command.run()

        XCTAssertEqual(command.processor.findFilesWithCompilerDirective(in: command.options.paths).count, 1)
    }

    func testFindMiss() throws {
        let input = """
        // code
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = FindCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]

        XCTAssertThrowsError(try command.run())

        XCTAssertEqual(command.processor.findFilesWithCompilerDirective(in: command.options.paths).count, 0)
    }
}
