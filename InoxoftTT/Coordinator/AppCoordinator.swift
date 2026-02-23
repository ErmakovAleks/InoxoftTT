//
//  AppCoordinator.swift
//  InoxoftTT
//

import UIKit
import SwiftUI

final class AppCoordinator: Navigating {

    let deviceType: DeviceType

    private var navigationController: UINavigationController?
    private var splitViewController: UISplitViewController?

    // MARK: -
    // MARK: Initialization

    init() {
        self.deviceType = DeviceType.current
    }

    // MARK: -
    // MARK: Public Methods

    func start(window: UIWindow) {
        let viewController = self.makePostListViewController()

        switch self.deviceType {
        case .iPhone:
            let nav = UINavigationController(rootViewController: viewController)
            self.navigationController = nav
            window.rootViewController = nav

        case .iPad:
            let splitVC = UISplitViewController(style: .doubleColumn)
            splitVC.preferredDisplayMode = .oneBesideSecondary
            splitVC.preferredSplitBehavior = .tile

            self.splitViewController = splitVC

            let placeholder = UIHostingController(rootView: PlaceholderDetailView())

            splitVC.setViewController(viewController, for: .primary)
            splitVC.setViewController(placeholder, for: .secondary)

            window.rootViewController = splitVC
        }

        window.makeKeyAndVisible()
    }

    // MARK: -
    // MARK: Navigating Protocol

    func navigateTo(_ screen: AppScreen, from source: UIViewController? = nil) {
        switch screen {
        case .postList:
            let viewController = self.makePostListViewController()
            self.showScreen(viewController: viewController, from: source)

        case .postDetail(let post):
            let viewController = self.makePostDetailViewController(post: post)
            self.showScreen(viewController: viewController, from: source)

        case .search:
            let viewController = self.makeSearchViewController()
            self.showScreen(viewController: viewController, from: source)

        case .modal(let alertData):
            self.presentAlert(alertData, from: source)
        }
    }

    // MARK: -
    // MARK: View Controller Factory

    private func makePostListViewController() -> UIViewController {
        let viewModel = PostListViewModel(container: DIContainer.self)
        let rootView = PostListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.title = L10n.PostList.title

        viewModel.onEvent = { [weak self] event in
            switch event {
            case .showPostDetail(let post):
                self?.navigateTo(.postDetail(post))
            }
        }

        return hostingController
    }

    private func makePostDetailViewController(post: Post) -> UIViewController {
        let viewModel = PostDetailViewModel(post: post, container: DIContainer.self)
        let rootView = PostDetailView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.title = L10n.PostDetail.title

        viewModel.onEvent = { event in
            switch event {
            case .imageSaved:
                break
            case .openInBrowser(let url):
                UIApplication.shared.open(url)
            }
        }

        return hostingController
    }

    private func makeSearchViewController() -> UIViewController {
        let viewModel = PostListViewModel(container: DIContainer.self, isSearchMode: true)
        let rootView = PostListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: rootView)
        hostingController.title = L10n.PostList.search

        viewModel.onEvent = { [weak self] event in
            switch event {
            case .showPostDetail(let post):
                self?.navigateTo(.postDetail(post))
            }
        }

        return hostingController
    }

    // MARK: -
    // MARK: Private Methods

    private func showScreen(viewController: UIViewController, from source: UIViewController?) {
        if let source = source {
            self.presentAsSheet(viewController, from: source)
        } else {
            switch self.deviceType {
            case .iPhone:
                self.navigationController?.pushViewController(viewController, animated: true)
            case .iPad:
                self.splitViewController?.setViewController(viewController, for: .secondary)
            }
        }
    }

    private func presentAsSheet(_ viewController: UIViewController, from source: UIViewController?) {
        let presentingVC = source ?? self.navigationController?.visibleViewController ?? self.splitViewController
        viewController.modalPresentationStyle = self.deviceType == .iPad ? .formSheet : .automatic
        presentingVC?.present(viewController, animated: true)
    }

    private func presentAlert(_ alertData: AlertData, from source: UIViewController?) {
        let alert = UIAlertController(title: alertData.title, message: alertData.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default))

        let presentingVC = source ?? self.navigationController?.visibleViewController ?? self.splitViewController
        presentingVC?.present(alert, animated: true)
    }
}
