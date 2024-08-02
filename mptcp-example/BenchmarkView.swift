//
//  BenchmarkView.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

struct BenchmarkView: View {
    @State private var showingRunBenchmark = false
    @State private var measures: [Measure] = [
        Measure(mode: .handover, transfer: .download_1M, measures: [200, 300]),
        Measure(mode: .none, transfer: .download_1M, measures: [400, 500])
    ]
    @State private var newMeasure = Measure()
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(measures){measure in
                    NavigationLink(destination: {
                        MeasureView(measure: measure)
                    }, label: {
                        Text("Record from \(measure.date.formatted(date: .numeric, time: .shortened))")
                    })
                }.onDelete(perform: { indexSet in
                    measures.remove(atOffsets: indexSet)
                })
            }.sheet(isPresented: $showingRunBenchmark, onDismiss: {
                showingRunBenchmark = false
            }, content: {
                RunBenchmarkView(measure: $newMeasure){
                    measures.insert(newMeasure, at: 0)
                } onClosed: {
                    newMeasure = Measure()
                }
            }).toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        showingRunBenchmark = true
                    } label: {
                        Label("Run benchmark", systemImage: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    BenchmarkView()
}
