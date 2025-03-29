//
//  Coordinator.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import SwiftUI

protocol Coordinator {
    func start() -> AnyView
}

class AppCoordinator: ObservableObject {
    @Published var selectedUser: User? = nil

    func start() -> AnyView {
        AnyView(ContentView(coordinator: self))
    }

    func showUserDetail(user: User) {
        selectedUser = user
    }

    func goBack() {
        selectedUser = nil
    }
}
