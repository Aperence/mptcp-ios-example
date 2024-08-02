//
//  ContentView.swift
//
//  Created by Anthony Doeraene on 30/07/2024.
//

import SwiftUI

typealias MPTCPMode = URLSessionConfiguration.MultipathServiceType

struct CheckMPTCPView: View {
    
    @State private var loading: Bool = false
    @State private var using_mptcp: Bool = false
    @State private var didError = false
    @State private var savedError: Error? = nil
    @State private var client: any MPTCPClient = ContainerClient.client_list[0].client
    @State private var response_time: UInt64 = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Form{
                    Section("Client selection"){
                        ClientSelectionView(client: $client){
                            refresh()
                        }
                    }
                    
                    Section("MPTCP Mode"){
                        MPTCPModeSelectionView(mptcp_mode: $client.mode){
                            refresh()
                        }
                        Text(client.mode.description)
                    }

                    Section("Results"){
                        if loading{
                            ProgressView()
                        }else {
                            ResultsView(using_mptcp: using_mptcp, tranfer: .check, response_time: response_time)
                        }
                    }.listRowSeparator(.hidden)
                    
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        refresh()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
            .task {
                refresh()
            }
            .alert(
                "An error occured",
                isPresented: $didError,
                presenting: savedError
            ) { _ in
                Button("Ok") {}
            }
            message: { error in
                Text(error.localizedDescription)
            }
        }
    }

    func refresh(){
        Task{
            await fetch()
        }
    }

    func fetch() async {
        loading = true
        
        do{
            let start = DispatchTime.now()
            let data = try await client.fetch(url: Transfers.check.url)
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
    CheckMPTCPView()
}
