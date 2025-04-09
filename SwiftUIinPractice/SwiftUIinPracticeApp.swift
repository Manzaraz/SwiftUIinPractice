//
//  SwiftUIinPracticeApp.swift
//  SwiftUIinPractice
//
//  Created by Christian Manzaraz on 31/03/2025.
//

import SwiftUI
import SwiftfulRouting

@main
struct SwiftUIinPracticeApp: App {
    var body: some Scene {
        WindowGroup {
            RouterView { _ in
                ContentView()
            }
        }
    }
}

extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
