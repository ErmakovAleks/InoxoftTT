//
//  RequestError.swift
//  InoxoftTT
//

import Foundation

enum RequestError: LocalizedError {

    case decode
    case failure(Error)
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode(Int)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .decode:
            return "Failed to decode response data"
        case .invalidURL:
            return "Invalid URL"
        case .noResponse:
            return "No response from server"
        case .unauthorized:
            return "Unauthorized access"
        case .unexpectedStatusCode(let code):
            return "Unexpected status code: \(code)"
        case .unknown(let message):
            return "Unknown error: \(message)"
        case .failure(let error):
            return error.localizedDescription
        }
    }
}
