//
//  MultipathServiceType+Name.swift
//  test-mptcp
//
//  Created by Anthony Doeraene on 31/07/2024.
//

import Foundation

extension URLSessionConfiguration.MultipathServiceType : CaseIterable {
    public static var allCases: [URLSessionConfiguration.MultipathServiceType] = [.none, .handover, .interactive, .aggregate]
}

extension URLSessionConfiguration.MultipathServiceType : Identifiable{
    public var id: Self { self }
}

extension URLSessionConfiguration.MultipathServiceType{
    var name: String {
        switch self{
        case .none:
            "None"
        case .handover:
            "Handover"
        case .interactive:
            "Interactive"
        case .aggregate:
            "Aggregate"
        @unknown default:
            "Unknown"
        }
    }
    
    var description: String {
        switch self{
        case .none:
            "Don't use MPTCP at all"
        case .handover:
            "Provide seamless handover between Wi-Fi and cellular if the connection becomes slow/lossy"
        case .interactive:
            "Use the interface with the lowest delay"
        case .aggregate:
            "Send data in parallel on different interfaces to provide higher bandwidth"
        @unknown default:
            "Unknown"
        }
    }
}

extension URLSessionConfiguration.MultipathServiceType: Codable {}
