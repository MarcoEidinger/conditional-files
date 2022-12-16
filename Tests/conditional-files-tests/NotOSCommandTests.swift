@testable import conditional_files
import XCTest

final class NotOSCommandTests: XCTestCase {
    func testValidation() {
        var command = NotOSCommand()
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
        #if !os(iOS)
        #endif
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = NotOSCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.operatingSystems = [.ios]
        command.options = PathFileOptions()
        command.options.paths = ["fakePatht"]
        command.undo = false

        command.run()

        XCTAssertEqual(stub.updatedFileContent, expectedOutput)
    }

    func testMultipleInsert() {
        let input = ""
        let expectedOutput = """
        #if !os(iOS) && !os(watchOS)
        #endif
        """

        let stub = FileManagerMock()
        stub.originalFileContent = input

        var command = NotOSCommand()
        command.processor = CommandProcessor(fileHandler: stub)
        command.operatingSystems = [.ios, .watchos]
        command.options = PathFileOptions()
        command.options.paths = ["fakePath"]
        command.undo = false

        command.run()

        XCTAssertEqual(stub.updatedFileContent, expectedOutput)
    }
}
