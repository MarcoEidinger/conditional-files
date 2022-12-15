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
    @Argument(help: "List of paths to the files or directories containing swift sources")
    var paths = [String]()
}

@main
struct CLI: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "conditional-files",
        abstract: "A utility to add compiler directives for the whole file content.",
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

    @Flag var undo: Bool = false

    @OptionGroup var options: PathFileOptions

    var processor: CommandProcessor = .init()

    var topLine: String {
        var ifCommand = ""
        if operatingSystems.count > 1 {
            for (index, os) in operatingSystems.enumerated() {
                if index == 0 {
                    ifCommand = "#if os(\(os.rawValue)) "
                } else {
                    ifCommand = ifCommand + "|| os(\(os.rawValue)) "
                }
            }
        } else {
            ifCommand = "#if os(\(operatingSystems.first!.rawValue))"
        }
        return ifCommand
    }

    var bottomLine: String {
        return "#endif"
    }

    mutating func run() {
        if operatingSystems.isEmpty {
            print("Error: at least one operating system has to be specified through an respective flag.")
            return
        }

        processor.execute(with: options.paths, firstLine: topLine, lastLine: bottomLine, undo: undo)
    }
}

struct NotOSCommand: ParsableCommand {
    static var configuration = CommandConfiguration(
        commandName: "not-os",
        abstract: "Add (or remove) compiler directive #if !os(...) [&& !os(...)] for the whole file content with closing #endif."
    )

    @Flag
    var operatingSystems: [OperatingSystem] = []

    @Flag var undo: Bool = false

    @OptionGroup var options: PathFileOptions

    var processor: CommandProcessor = .init()

    var topLine: String {
        var ifCommand = ""
        if operatingSystems.count > 1 {
            for (index, os) in operatingSystems.enumerated() {
                if index == 0 {
                    ifCommand = "#if !os(\(os.rawValue)) "
                } else {
                    ifCommand = ifCommand + "&& !os(\(os.rawValue)) "
                }
            }
        } else {
            ifCommand = "#if !os(\(operatingSystems.first!.rawValue))"
        }
        return ifCommand
    }

    var bottomLine: String {
        return "#endif"
    }

    mutating func run() {
        if operatingSystems.isEmpty {
            print("Error: at least one operating system has to be specified through an respective flag.")
            return
        }

        processor.execute(with: options.paths, firstLine: topLine, lastLine: bottomLine, undo: undo)
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

    @Flag var undo: Bool = false

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
