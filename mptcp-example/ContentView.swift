//
//  ContentView.swift
//
//  Created by Anthony Doeraene on 30/07/2024.
//

import SwiftUI

typealias MPTCPMode = URLSessionConfiguration.MultipathServiceType

struct ContentView: View {
    
    @State private var loading: Bool = false
    @State private var using_mptcp: Bool = false
    @State private var didError = false
    @State private var savedError: Error? = nil
    @State private var mptcp_mode: MPTCPMode = .none
    @State private var client: any MPTCPClient = ContainerClient.client_list[0].client
    @State private var tranfer: Transfers = .check
    @State private var response_time: UInt64 = 0
    
    var body: some View {
       
        VStack {

            MPTCPModeSelectionView(mptcp_mode: $mptcp_mode){
                refresh()
            }

            ClientSelectionView(client: $client){
                refresh()
            }
            
            TransferSelectionView(tranfer: $tranfer){
                refresh()
            }
            
            Spacer()
            
            if loading{
                ProgressView()
            }else {
                ResultsView(using_mptcp: using_mptcp, tranfer: tranfer, response_time: response_time)
            }
            
            Spacer()
            
            Button{
                refresh()
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
            }
        }
        .padding()
        .task {
            refresh()
        }
        .alert(
            "An error occured",
            isPresented: $didError,
            presenting: savedError
        ) { _ in
            Button("Ok") {}
        } message: { error in
            Text(error.localizedDescription)
        }
    }

    func refresh(){
        Task{
            client.set_mode(mode: mptcp_mode)
            await fetch()
        }
    }

    func fetch() async {
        loading = true
        
        do{
            let start = DispatchTime.now()
            let data = try await client.fetch(url: tranfer.url)
            let end = DispatchTime.now()
            
            response_time = (end.uptimeNanoseconds - start.uptimeNanoseconds) / 1_000_000
            let res = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)
            using_mptcp = res == "You are using MPTCP."
        }catch{
            using_mptcp = false
            savedError = error
            didError = true
        }
        
        loading = false
    }
}

#Preview {
    ContentView()
}
