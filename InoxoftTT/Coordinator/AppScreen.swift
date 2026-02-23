//
//  AppScreen.swift
//  InoxoftTT
//

import UIKit

enum DeviceType {

    case iPhone
    case iPad

    static var current: DeviceType {
        UIDevice.current.userInterfaceIdiom == .pad ? .iPad : .iPhone
    }
}

struct AlertData {

    let title: String
    let message: String
}

enum AppScreen {

    case postList
    case postDetail(Post)
    case search
    case modal(AlertData)
}

protocol Navigating {

    func navigateTo(_ screen: AppScreen, from source: UIViewController?)
}

extension Navigating {

    func navigateTo(_ screen: AppScreen) {
        self.navigateTo(screen, from: nil)
    }
}
