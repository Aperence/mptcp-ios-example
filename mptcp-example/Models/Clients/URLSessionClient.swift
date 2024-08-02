//
//  MPTCPClient.swift
//  test-mptcp
//
//  Created by Anthony Doeraene on 31/07/2024.
//

import Foundation

struct URLSessionClient : MPTCPClient{
    
    var name: String = "URLSessionClient"
    var id: String { name }
    
    private var session: URLSession = URLSession.shared
    
    private var _mode: URLSessionConfiguration.MultipathServiceType = .none
    
    var mode: URLSessionConfiguration.MultipathServiceType{
        set{
            _mode = newValue
            let conf = URLSessionConfiguration.default
            conf.multipathServiceType = _mode
            session = URLSession(configuration: conf)
        }
        get{
            return _mode
        }
    }
    
    func fetch(url: URL) async throws -> Data {
        var req = URLRequest(url: url)
        // get a shorter description to know if we are using mptcp
        req.addValue("curl/7.54.1", forHTTPHeaderField: "User-Agent")
        
        let (data, _) = try await session.data(for: req)
        return data
    }
}
