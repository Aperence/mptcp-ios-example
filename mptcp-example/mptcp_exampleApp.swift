//
//  mptcp_exampleApp.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import SwiftUI

@main
struct mptcp_exampleApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                CheckMPTCPView().tabItem {
                    Label("Check MPTCP", systemImage: "gear.badge")
                }


                BenchmarkView().tabItem{
                    Label("Benchmark", systemImage: "laptopcomputer.and.arrow.down")
                }
            }
        }
    }
}
