//
//  RequestError.swift
//  mptcp-example
//
//  Created by Anthony Doeraene on 05/08/2024.
//

import Foundation

enum RequestError: Error{
    case fetchingError
}

extension RequestError: LocalizedError{
    public var errorDescription: String? {
            switch self {
            case .fetchingError:
                return NSLocalizedString("Failed to fetch data from the server", comment: "Fetching error")
            }
        }
}
