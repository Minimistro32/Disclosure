//
//  CSV.swift
//  Disclosure
//
//  Created by Tyson Freeze on 5/26/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct CSV: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.commaSeparatedText]

    // by default our document is empty
    var text = ""

    // a simple initializer that creates new, empty documents
    init(_ initialText: String = "") {
        text = initialText
    }

    // this initializer loads CSV data
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }

    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
    
    static func escape(_ field: String) -> String {
        var escaped = field.replacingOccurrences(of: "\"", with: "\"\"")
        if escaped.contains(",") || escaped.contains("\n") || escaped.contains("\"") {
            escaped = "\"\(escaped)\""
        }
        return escaped
    }
    
    static func parse(file contents: String) -> [String] {
        var lines: [String] = []
        var currentLine = ""
        var insideQuotes = false

        for char in contents {
            currentLine.append(char)

            if char == "\"" {
                insideQuotes.toggle()
            }

            if char == "\n", !insideQuotes {
                lines.append(currentLine.trimmingCharacters(in: .newlines))
                currentLine = ""
            }
        }

        // Add any trailing line (EOF without newline)
        if !currentLine.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            lines.append(currentLine.trimmingCharacters(in: .newlines))
        }

        // Drop header row
        return Array(lines.dropFirst())
    }

    
    static func parse(_ line: String) -> [String] {
        var result: [String] = []
        var field = ""
        var insideQuotes = false
        let chars = Array(line)
        var i = 0

        while i < chars.count {
            let char = chars[i]

            if char == "\"" {
                if insideQuotes && i + 1 < chars.count && chars[i + 1] == "\"" {
                    field.append("\"") // Escaped quote
                    i += 1
                } else {
                    insideQuotes.toggle()
                }
            } else if char == "," && !insideQuotes {
                result.append(field)
                field = ""
            } else {
                field.append(char)
            }

            i += 1
        }

        result.append(field)
        return result
    }

}
