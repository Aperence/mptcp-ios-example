//
//  ModeComponent.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

struct MPTCPModeSelectionView: View{
    
    @Binding var mptcp_mode: MPTCPMode
    let update: () -> Void
    
    var body: some View {
        Picker("MPTCP mode", selection: $mptcp_mode){
            ForEach(MPTCPMode.allCases){ mode in
                Text(mode.name).tag(mode.name)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: mptcp_mode) {
            update()
        }
    }
}

#Preview {
    MPTCPModeSelectionView(mptcp_mode: .constant(.none)){}
}
