//
//  Transfers.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import Foundation

enum Transfers: CaseIterable, Identifiable, Codable{
    var id: Self  { self }
    
    case check
    case download_1M
    case download_10M
    case download_100M
    case download_1000M
    
    var name: String {
        switch self{
        case .check:
            "Check"
        case .download_1M:
            "1MB"
        case .download_10M:
            "10MB"
        case .download_100M:
            "100MB"
        case .download_1000M:
            "1000MB"
        }
    }
    
    var url: URL{
        switch self{
        case .check:
            URL(string: "https://check.mptcp.dev")!
        case .download_1M:
            URL(string: "https://check.mptcp.dev/files/1M")!
        case .download_10M:
            URL(string: "https://check.mptcp.dev/files/10M")!
        case .download_100M:
            URL(string: "https://check.mptcp.dev/files/100M")!
        case .download_1000M:
            URL(string: "https://check.mptcp.dev/files/1000M")!
        }
    }
    
    // size of download in bits
    var size: Int{
        switch self{
        case .check:
            0
        case .download_1M:
            8 * 1_000_000
        case .download_10M:
            8 * 10_000_000
        case .download_100M:
            8 * 100_000_000
        case .download_1000M:
            8 * 1_000_000_000
        }
    }
}
