import Foundation

struct CommandProcessor: Decodable {
    init(fileHandler: FileManagerFacade = FileSystemAccessor()) {
        fm = fileHandler
    }

    init(from _: Decoder) throws {
        fm = FileSystemAccessor()
    }

    var fm: FileManagerFacade = FileSystemAccessor()
    func execute(with paths: [String],
                 firstLine: String,
                 lastLine: String,
                 undo: Bool)
    {
        let files = fm.getFiles(for: paths, in: FileManager.default.currentDirectoryPath)

        for fileURL in files {
            guard let fileContent = fm.content(for: fileURL) else { continue }
            if undo {
                if let updatedFileContent = fileContent.deleteIfExists(firstLine: firstLine, lastLine: lastLine) {
                    fm.save(updatedFileContent, to: fileURL)
                }
            } else {
                let updatedFileContent = fileContent.insert(firstLine: firstLine, lastLine: lastLine)
                fm.save(updatedFileContent, to: fileURL)
            }
        }
    }
}

/// Abstraction to mock away the access to the filesystem in unit tests
protocol FileManagerFacade: Decodable {
    func content(for file: URL) -> String?

    func getFiles(for paths: [String], in directory: String) -> [URL]

    func save(_ fileContent: String, to file: URL)
}

struct FileSystemAccessor: FileManagerFacade {
    func content(for file: URL) -> String? {
        try? String(contentsOf: file)
    }

    func getFiles(for paths: [String], in _: String) -> [URL] {
        let directory = FileManager.default.currentDirectoryPath
        return FileCollector().getFiles(for: paths, in: directory)
    }

    func save(_ fileContent: String, to file: URL) {
        try? fileContent.write(to: file, atomically: true, encoding: .utf8)
    }
}
