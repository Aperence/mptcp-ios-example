//
//  mptcp_exampleApp.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

@main
struct mptcp_exampleApp: App {
    
    @StateObject private var measureStore = MeasureStore()
    @State private var didError = false
    @State private var savedError: Error? = nil
    
    var body: some Scene {
        WindowGroup {
            TabView {
                CheckMPTCPView().tabItem {
                    Label("Check MPTCP", systemImage: "gear.badge")
                }

                BenchmarkView(measures: $measureStore.measures){
                    Task{
                        do{
                            try await measureStore.save(measures: measureStore.measures)
                        }catch{
                            didError = true
                            savedError = error
                        }
                    }
                }.tabItem{
                    Label("Benchmark", systemImage: "laptopcomputer.and.arrow.down")
                }
            }.task {
                do{
                    try await measureStore.load()
                }catch{}
            }.alert(
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
}
