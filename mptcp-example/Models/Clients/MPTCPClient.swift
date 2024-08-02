//
//  MPTCPClient.swift
//  test-mptcp
//
//  Created by Anthony Doeraene on 01/08/2024.
//

import Foundation

protocol MPTCPClient: Identifiable{
    var name: String { get }
    var id: String { get }
    var mode: URLSessionConfiguration.MultipathServiceType{
        set get
    }
    func fetch(url: URL) async throws -> Data
}

struct ContainerClient : Identifiable, Hashable, Codable{
    static let client_list = [ContainerClient(client: URLSessionClient()), ContainerClient(client: AlamofireClient())]
    
    static func == (lhs: ContainerClient, rhs: ContainerClient) -> Bool {
        rhs.id == lhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var client: any MPTCPClient
    var id: String { client.name }
    
    init(client: any MPTCPClient) {
        self.client = client
    }
    
    enum CodingKeys: String, CodingKey {
        case name
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(client.name, forKey: .name)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let clientName = try container.decode(String.self, forKey: .name)
        switch clientName{
            case "URLSessionClient":
                self.client = URLSessionClient()
            case "AlamofireClient":
                self.client = AlamofireClient()
            default:
                fatalError("Unknown client in data file")
        }
    }
}
