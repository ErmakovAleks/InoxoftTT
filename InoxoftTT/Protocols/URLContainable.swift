//
//  URLContainable.swift
//  InoxoftTT
//

import Foundation

protocol URLContainable {

    associatedtype DecodableType: Decodable

    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: [String: Any]? { get }
}

extension URLContainable {

    var scheme: String {
        "https"
    }

    var host: String {
        "www.reddit.com"
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem]? { nil }

    var body: [String: Any]? { nil }
}
