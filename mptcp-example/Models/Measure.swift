//
//  Measures.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import Foundation

final class Measure: Identifiable {
    let id = UUID()
    var mode: URLSessionConfiguration.MultipathServiceType = .none
    var transfer: Transfers = .download_1M
    var date = Date()
    
    var measures = [Int]()
    
    init(mode: URLSessionConfiguration.MultipathServiceType = .none, transfer: Transfers = .download_1M, measures: [Int] = [Int]()) {
        self.mode = mode
        self.transfer = transfer
        self.measures = measures
    }
}

