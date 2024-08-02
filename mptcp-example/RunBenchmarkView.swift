//
//  RunBenchmarkView.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

struct RunBenchmarkView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var measure: Measure
    @State private var numberSamples: Double = 3
    var onRunned: () -> Void
    var onClosed: () -> Void
    
    var body: some View {
        NavigationStack{
            List{
                Section("Mode"){
                    MPTCPModeSelectionView(mptcp_mode: $measure.mode){}
                }
                
                Section("Transfer"){
                    TransferSelectionView(tranfer: $measure.transfer){}
                }
                
                Section("Number of samples"){
                    Slider(
                        value: $numberSamples,
                        in: 1...10,
                        step: 1){}
                        minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("10")
                        }
                    HStack{
                        Text("Number:")
                        Spacer()
                        Text("\(Int(numberSamples))")
                    }
                }
            }
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
    
    func runSamples(){
        for _ in 0..<Int(numberSamples){
            measure.measures.append(100)
        }
        onRunned()
        dismiss()
    }
}

#Preview {
    RunBenchmarkView(measure: .constant(Measure())){} onClosed: {}
}
