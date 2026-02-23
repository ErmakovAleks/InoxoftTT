//
//  DIContainer.swift
//  InoxoftTT
//

import Foundation

protocol ServiceContainable {

    static var networkService: NetworkServiceProtocol { get }
    static var persistenceService: PersistenceServiceProtocol { get }
    static var imageLoader: ImageLoaderProtocol { get }
}

enum DIContainer: ServiceContainable {

    static var networkService: NetworkServiceProtocol = NetworkService.shared
    static var persistenceService: PersistenceServiceProtocol = PersistenceService.shared
    static var imageLoader: ImageLoaderProtocol = ImageLoader.shared
}
