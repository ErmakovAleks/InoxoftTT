//
//  PersistenceService.swift
//  InoxoftTT
//

import Foundation
import RealmSwift

protocol PersistenceServiceProtocol {

    func savePosts(_ posts: [Post])
    func loadPosts() -> [Post]
    func loadPosts(matching query: String) -> [Post]
    func clearCache()
}

final class PersistenceService: PersistenceServiceProtocol {

    static let shared = PersistenceService()

    private var realm: Realm {
        do {
            let config = Realm.Configuration(
                schemaVersion: 1,
                deleteRealmIfMigrationNeeded: true
            )
            return try Realm(configuration: config)
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }

    // MARK: -
    // MARK: Initialization

    private init() {}

    // MARK: -
    // MARK: PersistenceServiceProtocol

    func savePosts(_ posts: [Post]) {
        let cachedPosts = posts.map { CachedPost(from: $0) }

        do {
            try self.realm.write {
                let existingPosts = self.realm.objects(CachedPost.self)
                self.realm.delete(existingPosts)
                self.realm.add(cachedPosts)
            }
        } catch {
            debugPrint("Failed to save posts: \(error)")
        }
    }

    func loadPosts() -> [Post] {
        let cachedPosts = self.realm.objects(CachedPost.self)
            .sorted(byKeyPath: "created", ascending: false)

        return Array(cachedPosts).map { $0.toPost() }
    }

    func loadPosts(matching query: String) -> [Post] {
        let predicate = NSPredicate(
            format: "title CONTAINS[cd] %@ OR author CONTAINS[cd] %@ OR subreddit CONTAINS[cd] %@",
            query, query, query
        )

        let cachedPosts = self.realm.objects(CachedPost.self)
            .filter(predicate)
            .sorted(byKeyPath: "created", ascending: false)

        return Array(cachedPosts).map { $0.toPost() }
    }

    func clearCache() {
        do {
            try self.realm.write {
                self.realm.deleteAll()
            }
        } catch {
            debugPrint("Failed to clear cache: \(error)")
        }
    }
}
