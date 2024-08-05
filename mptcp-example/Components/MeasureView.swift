//
//  MeasureView.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

struct MeasureView: View {
    @Binding var measure: Measure
    var mean : Double {
        Double(measure.measures.reduce(0, {$0 + $1})) / Double(measure.measures.count)
    }
    var std : Double {
        let sum = measure.measures.reduce(0.0, { acc, value in
            let value = Double(value);
            return acc + (value - mean) * (value - mean)
        })
        let temp = sum / Double(measure.measures.count)
        return sqrt(temp)
    }
    var body: some View {
        List{
            Section("Record date"){
                Text(measure.date.formatted(date: .numeric, time: .standard))
            }
            Section("Client"){
                Text(measure.client.name)
            }
            Section("Mode"){
                Text(measure.client.mode.name)
            }
            Section("Transfer"){
                Text(measure.transfer.name)
            }
            Section("Statistics"){
                HStack{
                    Text("Mean")
                    Spacer()
                    Text(String(format: "%.2f ms", mean))
                }
                HStack{
                    Text("Std")
                    Spacer()
                    Text(String(format: "%.2f ms", std))
                }
            }
            Section("Measures"){
                ForEach(measure.measures, id: \.hashValue){ time in
                    Text("\(time) ms")
                }.onDelete(perform: { indexSet in
                    measure.measures.remove(atOffsets: indexSet)
                })
            }
        }
    }
}

#Preview {
    MeasureView(measure: .constant(Measure(transfer: .download_1M, measures: [200, 300, 400, 500])))
}
