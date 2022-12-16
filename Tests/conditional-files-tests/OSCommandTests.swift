@testable import conditional_files
import XCTest

final class OSCommandTests: XCTestCase {
    func testValidation() {
        var command = OSCommand()
        command.processor = CommandProcessor(fileHandler: FileManagerMock())
        command.operatingSystems = [] // <== error
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]
        command.undo = false

        XCTAssertThrowsError(try command.validate())
    }
    
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
        command.options.paths = ["fakePath"]
        command.undo = false

        command.run()

        XCTAssertEqual(stub.updatedFileContent, expectedOutput)
    }
    
    func testMultipleInsert() {
        let input = ""
        let expectedOutput = """
        #if os(iOS) || os(watchOS)
        #endif
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = OSCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.operatingSystems = [.ios, .watchos]
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]
        command.undo = false

        command.run()

        XCTAssertEqual(stub.updatedFileContent, expectedOutput)
    }

    func testUndoOnNothing() {
        let input = "n/a"

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = OSCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.operatingSystems = [.ios]
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]
        command.undo = true

        command.run()

        XCTAssertEqual(stub.updatedFileContent, nil)
    }

    func testUndo() {
        let input = """
        #if os(iOS)
        // code
        #endif
        """

        let expectedOutput = "// code"

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = OSCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.operatingSystems = [.ios]
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]
        command.undo = true

        command.run()

        XCTAssertEqual(stub.updatedFileContent, expectedOutput)
    }
}
