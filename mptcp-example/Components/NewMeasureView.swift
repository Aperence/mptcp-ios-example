//
//  NewMeasureView.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 02/08/2024.
//

import SwiftUI

struct NewMeasureView: View {
    @Binding var measure: Measure
    @Binding var numberRequests: Int
    @State private var numberRequestsDouble = 3.0
    
    var body: some View {
        Form{
            List{
                Section("Client"){
                    ClientSelectionView(client: $measure.client){}
                }
                
                Section("MPTCP Mode"){
                    MPTCPModeSelectionView(mptcp_mode: $measure.mode){}
                }
                
                Section("Transfer"){
                    TransferSelectionView(tranfer: $measure.transfer){}
                }
                
                Section("Number of requests"){
                    Slider(
                        value: $numberRequestsDouble,
                        in: 1...10,
                        step: 1){}
                        minimumValueLabel: {
                            Text("1")
                        } maximumValueLabel: {
                            Text("10")
                        }.onChange(of: numberRequestsDouble){
                            numberRequests = Int(numberRequestsDouble)
                        }
                    HStack{
                        Text("Number:")
                        Spacer()
                        Text("\(numberRequests)")
                    }
                }
            }
        }
    }
}

#Preview {
    NewMeasureView(measure: .constant(Measure()), numberRequests: .constant(3))
}
