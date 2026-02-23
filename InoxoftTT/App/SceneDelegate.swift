//
//  SceneDelegate.swift
//  InoxoftTT
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    private var coordinator: AppCoordinator?

    // MARK: -
    // MARK: Scene Lifecycle

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = scene as? UIWindowScene else { return }

        self.window = UIWindow(windowScene: windowScene)

        self.coordinator = AppCoordinator()
        self.coordinator?.start(window: self.window!)
    }
}
