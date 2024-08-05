//
//  JSONDocument.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 05/08/2024.

import SwiftUI
import UniformTypeIdentifiers

struct MeasurementFile: FileDocument {
    
    static var readableContentTypes: [UTType] { [.json] }
    var measurements: [Measure]
    
    init(configuration: ReadConfiguration) throws {
        guard
            let data = configuration.file.regularFileContents
        else { throw NSError() }
        self.measurements = try JSONDecoder().decode([Measure].self, from: data)
    }
    
    init(measurements: [Measure]) {
        self.measurements = measurements
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let content = try JSONEncoder().encode(measurements)
        return FileWrapper(regularFileWithContents: content)
    }
}
