//
//  Measures.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import Foundation
 
struct Measure: Identifiable, Codable {
    var id = UUID()
    var transfer: Transfers = .download_1M
    var date = Date()
    var mode: URLSessionConfiguration.MultipathServiceType = .none {
        didSet{
            client.mode = mode
        }
    }
    
    var measures = [UInt64]()
    private var containerClient: ContainerClient
    
    var client: any MPTCPClient {
        get{
            containerClient.client
        }
        set{
            containerClient.client = newValue
        }
    }
    
    init(mode: URLSessionConfiguration.MultipathServiceType = .none, transfer: Transfers = .download_1M, measures: [UInt64] = [], client: any MPTCPClient = URLSessionClient()) {
        self.mode = mode
        self.transfer = transfer
        self.measures = measures
        self.containerClient = ContainerClient(client: client)
    }
    
    /*
      Return the estimated bandwith in Mbps according to the response time in ms
     */
    func bandwidth(for response_time: UInt64) -> Double{
        return Double(transfer.size) / Double(response_time) / 1000
    }
    
    func bandwidth(for response_time: Double) -> Double{
        return Double(transfer.size) / response_time / 1000
    }
    
    enum CodingKeys: String, CodingKey {
        case id, date, client, measures
    }
    
    enum ClientKeys: String, CodingKey {
        case name, mode
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(date, forKey: .date)
        try container.encode(measures, forKey: .measures)
        
        var clientInfo = container.nestedContainer(keyedBy: ClientKeys.self, forKey: .client)
        try clientInfo.encode(client.name, forKey: .name)
        try clientInfo.encode(client.mode.name, forKey: .mode)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        date = try container.decode(Date.self, forKey: .date)
        measures = try container.decode([UInt64].self, forKey: .measures)
        
        let clientInfo = try container.nestedContainer(keyedBy: ClientKeys.self, forKey: .client)
        let clientName = try clientInfo.decode(String.self, forKey: .name)
        switch clientName{
            case "URLSessionClient":
                containerClient = ContainerClient(client: URLSessionClient())
            case "AlamofireClient":
                containerClient = ContainerClient(client: AlamofireClient())
            default:
                fatalError("Unknown client in data file")
        }
        
        let modeName = try clientInfo.decode(String.self, forKey: .mode)
        switch modeName{
            case "None":
                mode = .none
            case "Handover":
                mode = .handover
            case "Interactive":
                mode = .interactive
            case "Aggregate":
                mode = .aggregate
            default:
                fatalError("Unknown")
        }
    }
}

