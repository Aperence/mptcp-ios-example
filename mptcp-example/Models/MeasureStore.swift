//
//  MeasureStore.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 02/08/2024.
//

import SwiftUI

@MainActor
class MeasureStore: ObservableObject{
    @Published var measures: [Measure] = []
    
    private static func fileURL() throws -> URL {
        URL.documentsDirectory.appending(path: "measures.data")
    }
    
    func load() async throws {
        let task = Task<[Measure], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let measures = try JSONDecoder().decode([Measure].self, from: data)
            return measures
        }
        let measures = try await task.value
        self.measures = measures
    }
    
    func insert(measure: Measure){
        Task{ @MainActor in
            self.measures.insert(measure, at: 0)
        }
    }
    
    func remove(atOffsets: IndexSet){
        Task{ @MainActor in
            self.measures.remove(atOffsets: atOffsets)
        }
    }
    
    func save(measures: [Measure]) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(measures)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
}
