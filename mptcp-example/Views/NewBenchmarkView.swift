//
//  RunBenchmarkView.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

struct NewBenchmarkView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var measure: Measure
    
    @State private var savedError: Error? = nil
    
    @State private var doingRequest = false
    @State private var currRequestIdx = 0
    @State private var numberRequests: Int = 3
    
    private var progress: Double{
        Double(currRequestIdx) / Double(numberRequests)
    }
    
    var onRunned: () -> Void
    var onClosed: () -> Void
    
    var body: some View {
        NavigationStack{
            if let error = savedError{
                Text("An unexpected error occured").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                Text(error.localizedDescription).padding([.top, .bottom], 10)
                Button("Return to list view"){
                    dismiss()
                }
            }else if doingRequest{
                ProgressView(value: progress).progressViewStyle(.circular)
                Text("Done \(currRequestIdx) out of \(numberRequests) requests").padding(.top, 10)
            }else{
                NewMeasureView(measure: $measure, numberRequests: $numberRequests)
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        Button("Dismiss"){
                            onClosed()
                            dismiss()
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Run"){
                            runSamples()
                        }
                    }
                }
            }
        }
    }
    
    func runSamples() {
        Task{ @MainActor in
            let task = Task{
                doingRequest = true
                //measure.client.mode = measure.mode
                debugPrint(measure.client.mode.name)
                // warm up
                for _ in 0..<2{
                    let _ = try await fetch()
                }
                for _ in 0..<numberRequests{
                    let response_time = try await fetch()
                    measure.measures.append(response_time)
                    currRequestIdx+=1
                }
            }

            do{
                let _ = try await task.value
                onRunned()
                dismiss()
            }catch{
                savedError = error
            }
        }
    }
    
    func fetch() async throws -> UInt64{
        let start = DispatchTime.now()
        let _ = try await measure.client.fetch(url: measure.transfer.url)
        let end = DispatchTime.now()
        
        return (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
    }
}

#Preview {
    NewBenchmarkView(measure: .constant(Measure())){} onClosed: {}
}
