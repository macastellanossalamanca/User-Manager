//
//  UsersManagerApp.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import SwiftUI

@main
struct UsersManagerApp: App {
    @StateObject var coordinator = AppCoordinator()
    
    var body: some Scene {
        WindowGroup {
            coordinator.start()
        }
    }
}
