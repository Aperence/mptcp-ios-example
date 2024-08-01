//
//  MPTCPClient.swift
//  test-mptcp
//
//  Created by Anthony Doeraene on 31/07/2024.
//

import Foundation

class URLSessionClient : MPTCPClient{
    
    var name: String = "URLSessionClient"
    var id: String { name }
    
    private var session: URLSession = URLSession.shared
    
    func set_mode(mode: URLSessionConfiguration.MultipathServiceType){
        let conf = URLSessionConfiguration.default
        conf.multipathServiceType = mode
        session = URLSession(configuration: conf)
    }
    
    func fetch(url: URL) async throws -> Data {
        var req = URLRequest(url: url)
        // get a shorter description to know if we are using mptcp
        req.addValue("curl/7.54.1", forHTTPHeaderField: "User-Agent")
        
        let (data, _) = try await session.data(for: req)
        return data
    }
}
