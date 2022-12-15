import ArgumentParser
import Foundation

enum OperatingSystem: String, EnumerableFlag {
    case ios = "iOS"
    case macos = "macOS"
    case watchos = "watchOS"
    case tvos = "tvOS"
    case linux = "Linux"
    case windows = "Windows"
}

struct PathFileOptions: ParsableArguments {
    @Argument(help: "List of paths to the files or directories to be processed. You can use a single dot (.) to process all files in the current folder and its sub hierarchy.")
    var paths = [String]()
}

@main
struct CLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "conditional-files",
        abstract: """
        A command-line tool intended to insert a conditional compilation statement in multiple Swift files at once. Generic being able to process multiple files and insert any text at the top and the bottom of a file.
        """,
        discussion: """
        Example command: conditional-files os --ios .
        Result: Will process all files in the current folder and its sub directories.

        Example command: conditional-files os --ios test.swift
        Result: will touch only test.swift file in current directory.

        #if os(iOS) // <== inserted
        // code
        #endif      // <== inserted
        """,
        subcommands: [
            OSCommand.self,
            NotOSCommand.self,
            GenericCommand.self,
        ],
        defaultSubcommand: OSCommand.self
    )

    mutating func run() {}
}

struct OSCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "os",
        abstract: "Add (or remove) compiler directive #if os(...) [|| os(...)] for the whole file content with closing #endif."
    )

    @Flag
    var operatingSystems: [OperatingSystem] = []

    @Flag(help: "Remove the compiler directive if it exists in the file(s)")
    var undo: Bool = false

    @OptionGroup var options: PathFileOptions

    var processor: CommandProcessor = .init()

    mutating func run() {
        if operatingSystems.isEmpty {
            print("Error: at least one operating system has to be specified through an respective flag.")
            return
        }

        let cd = CompilerDirective(type: .if_os(operatingSystems))

        processor.execute(with: options.paths, firstLine: cd.topLine, lastLine: cd.bottomLine, undo: undo)
    }
}

struct NotOSCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "not-os",
        abstract: "Add (or remove) compiler directive #if !os(...) [&& !os(...)] for the whole file content with closing #endif."
    )

    @Flag
    var operatingSystems: [OperatingSystem] = []

    @Flag(help: "Remove the compiler directive if it exists in the file(s)")
    var undo: Bool = false

    @OptionGroup var options: PathFileOptions

    var processor: CommandProcessor = .init()

    mutating func run() {
        if operatingSystems.isEmpty {
            print("Error: at least one operating system has to be specified through an respective flag.")
            return
        }

        let cd = CompilerDirective(type: .if_not_os(operatingSystems))

        processor.execute(with: options.paths, firstLine: cd.topLine, lastLine: cd.bottomLine, undo: undo)
    }
}

struct GenericCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "generic",
        abstract: "Add (or remove) a top (first) and bottom (last) line."
    )

    @Option(help: "Top line")
    var top: String

    @Option(help: "Bottom line")
    var bottom: String

    @Flag(help: "Remove the top and bottom lines if such exist in the file(s)")
    var undo: Bool = false

    @OptionGroup var options: PathFileOptions

    var processor: CommandProcessor = .init()

    var topLine: String {
        top
    }

    var bottomLine: String {
        bottom
    }

    mutating func run() {
        processor.execute(with: options.paths, firstLine: top, lastLine: bottom, undo: undo)
    }
}
