import Foundation

extension String {
    func deleteIfExists(firstLine: String, lastLine: String) -> String? {
        var lines = components(separatedBy: "\n")
        if lines.last == "" {
            lines.removeLast()
        }
        guard let first = lines.first, let last = lines.last else { return nil }

        var changed = false
        if first.contains(firstLine) {
            lines.removeFirst()
            changed = true
        }
        if last.contains(lastLine) {
            lines.removeLast()
            changed = true
        }
        if !changed {
            return nil
        }
        return lines.joined(separator: "\n")
    }

    func insert(firstLine: String, lastLine: String) -> String {
        var lines = components(separatedBy: "\n")
        if lines.last == "" {
            lines.removeLast()
        }
        lines.insert(firstLine.trimmingTrailingWhiteSpaces(), at: 0)
        lines.append(lastLine)
        return lines.joined(separator: "\n")
    }

    func trimmingTrailingWhiteSpaces() -> String {
        return replacingOccurrences(of: "\\s+$", with: "", options: .regularExpression)
    }
}
