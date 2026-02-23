//
//  NetworkService.swift
//  InoxoftTT
//

import Foundation
import Alamofire

protocol NetworkSessionProtocol {

    static var shared: Self { get }

    func sendRequest<T: URLContainable>(requestModel: T) async throws -> T.DecodableType

    func sendRequest<T: Decodable>(url: URL) async throws -> T
}

protocol NetworkServiceProtocol: NetworkSessionProtocol {}

final class NetworkService: NetworkServiceProtocol {

    static let shared = NetworkService()

    private let session: Session

    // MARK: -
    // MARK: Initialization

    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = Session(configuration: configuration)
    }

    // MARK: -
    // MARK: NetworkSessionProtocol

    func sendRequest<T: URLContainable>(requestModel: T) async throws -> T.DecodableType {
        guard let url = self.configureURL(from: requestModel) else {
            throw RequestError.invalidURL
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(
                url,
                method: Alamofire.HTTPMethod(rawValue: requestModel.method.rawValue),
                parameters: requestModel.body,
                encoding: requestModel.method == .get ? URLEncoding.default : JSONEncoding.default
            )
            .validate()
            .responseDecodable(of: T.DecodableType.self) { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(returning: data)
                case .failure(let error):
                    continuation.resume(throwing: self.handleError(error, response: response.response))
                }
            }
        }
    }

    func sendRequest<T: Decodable>(url: URL) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            self.session.request(url)
                .validate()
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let error):
                        continuation.resume(throwing: self.handleError(error, response: response.response))
                    }
                }
        }
    }

    // MARK: -
    // MARK: Private Methods

    private func configureURL<T: URLContainable>(from requestModel: T) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = requestModel.scheme
        urlComponents.host = requestModel.host
        urlComponents.path = requestModel.path

        if let queryItems = requestModel.queryItems {
            urlComponents.queryItems = queryItems
        }

        return urlComponents.url
    }

    private func handleError(_ error: AFError, response: HTTPURLResponse?) -> RequestError {
        switch error {
        case .responseSerializationFailed(let reason):
            if case .decodingFailed = reason {
                return .decode
            }
            return .failure(error)
        case .responseValidationFailed(let reason):
            if case .unacceptableStatusCode(let code) = reason {
                return code == 401 ? .unauthorized : .unexpectedStatusCode(code)
            }
            return .failure(error)
        default:
            if let statusCode = response?.statusCode {
                return statusCode == 401 ? .unauthorized : .unexpectedStatusCode(statusCode)
            }
            return .unknown(error.localizedDescription)
        }
    }
}
