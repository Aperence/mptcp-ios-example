//
//  BenchmarkView.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI
import UniformTypeIdentifiers

struct BenchmarkView: View {
    @State private var showingRunBenchmark = false
    @State private var showingExport = false
    @Binding var measures: [Measure]
    @State private var newMeasure = Measure()
    @Environment(\.scenePhase) private var scenePhase
    var onSceneChange: () -> Void
    private var document: MeasurementFile {
        MeasurementFile(measurements: measures)
    }
    
    var body: some View {
        NavigationStack{
            List{
                ForEach($measures){ $measure in
                    NavigationLink(destination: {
                        MeasureView(measure: $measure)
                    }, label: {
                        Text("\(measure.client.name), \(measure.mode.name), \(measure.transfer.name)")
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
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        showingExport = true
                    } label: {
                        Label("Download measurements", systemImage: "square.and.arrow.down")
                    }
                }
            }.onChange(of: scenePhase){
                if scenePhase == .inactive { onSceneChange()}
            }.fileExporter(isPresented: $showingExport, document: document, contentType: .json, defaultFilename: "measures"){ result in
                debugPrint(result)
            }
        }
    }
}

#Preview {
    BenchmarkView(measures: .constant([])){}
}
