//
//  BenchmarkView.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

struct BenchmarkView: View {
    @State private var showingRunBenchmark = false
    @Binding var measures: [Measure]
    @State private var newMeasure = Measure()
    @Environment(\.scenePhase) private var scenePhase
    var onSceneChange: () -> Void
    
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
                NewBenchmarkView(measure: $newMeasure){
                    measures.insert(newMeasure, at: 0)
                    newMeasure = Measure()
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
            }.onChange(of: scenePhase){
                if scenePhase == .inactive { onSceneChange()}
            }
        }
    }
}

#Preview {
    BenchmarkView(measures: .constant([])){}
}
