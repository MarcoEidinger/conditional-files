import Foundation

enum CompilerDirectiveType {
    case if_os([OperatingSystem])
    case if_not_os([OperatingSystem])
}

struct CompilerDirective {
    var topLine: String {
        switch type {
        case let .if_os(operatingSystems):

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

        case let .if_not_os(operatingSystems):

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
    }

    var bottomLine: String {
        "#endif"
    }

    var type: CompilerDirectiveType
}
