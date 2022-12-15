@testable import conditional_files
import Foundation

class FileManagerMock: FileManagerFacade {
    var originalFileContent: String = ""

    var updatedFileContent: String? {
        updatedContents[dummyURL]
    }

    var updatedContents: [URL: String] = [:]

    var dummyURL: URL = .init(string: "https://www.google.com")!

    func content(for _: URL) -> String? {
        return originalFileContent
    }

    func getFiles(for _: [String], in _: String) -> [URL] {
        [dummyURL]
    }

    func save(_ fileContent: String, to file: URL) {
        updatedContents[file] = fileContent
    }
}
