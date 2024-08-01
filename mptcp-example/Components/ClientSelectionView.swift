//
//  ClientComponent.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

struct ClientSelectionView: View {
    @State private var clients: [ContainerClient] =
        ContainerClient.client_list
    @State private var clientContainer: ContainerClient = ContainerClient.client_list[0]
    @Binding var client: any MPTCPClient
    let update: () -> Void
    
    var body: some View {
        Picker("Clients", selection: $clientContainer){
            ForEach(clients){ container in
                Text(container.client.name).tag(container)
            }
        }
        .pickerStyle(.segmented)
        .onChange(of: clientContainer){
            client = clientContainer.client
            update()
        }
    }
}

#Preview {
    ClientSelectionView(client: .constant(ContainerClient.client_list[0].client)){}
}
