//
//  DetailedView.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import SwiftUI

struct DetailedView: View {
    @State var user: User?
    @ObservedObject var coordinator: AppCoordinator
    var body: some View {
        Text("This is the detailed view")
    }
}

