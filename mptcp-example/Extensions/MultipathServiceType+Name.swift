//
//  MultipathServiceType+Name.swift
//  test-mptcp
//
//  Created by Anthony Doeraene on 31/07/2024.
//

import Foundation

extension URLSessionConfiguration.MultipathServiceType : CaseIterable {
    public static var allCases: [URLSessionConfiguration.MultipathServiceType] = [.none, .handover, .aggregate, .interactive]
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
        ""
    }
}
