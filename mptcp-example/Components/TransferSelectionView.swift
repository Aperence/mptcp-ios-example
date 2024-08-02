//
//  TransferComponent.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

struct TransferSelectionView: View {
    
    @Binding var tranfer: Transfers
    let update: () -> Void
    
    var body: some View {
        Picker("Transfer type", selection: $tranfer){
            ForEach(Transfers.allCases.filter{t in
                t != .check
            }){ transfer in
                Text(transfer.name)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: tranfer) {
            update()
        }
    }
}

#Preview {
    TransferSelectionView(tranfer: .constant(.check)){}
}
