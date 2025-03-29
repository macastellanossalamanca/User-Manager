//
//  ContentView.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = UsersViewModel()
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem()], spacing: 10) {
                ForEach(viewModel.users, id: \.id) { user in
                    VStack {
                        Text(user.name)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
