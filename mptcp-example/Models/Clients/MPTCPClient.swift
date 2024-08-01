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
    func set_mode(mode: URLSessionConfiguration.MultipathServiceType)
    func fetch(url: URL) async throws -> Data
}

struct ContainerClient : Identifiable, Hashable{
    static let client_list = [ContainerClient(client: URLSessionClient()), ContainerClient(client: AlamofireClient())]
    
    static func == (lhs: ContainerClient, rhs: ContainerClient) -> Bool {
        rhs.id == lhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let client: any MPTCPClient
    var id: String { client.name }
    
    init(client: any MPTCPClient) {
        self.client = client
    }
}
