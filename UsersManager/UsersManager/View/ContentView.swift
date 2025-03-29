//
//  ContentView.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = UsersViewModel()
    @ObservedObject var coordinator: AppCoordinator
    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                NavigationLink(destination: UserDetailView(user: user)) {
                    VStack(alignment: .leading) {
                        Text(user.name).font(.headline)
                        Text("Teléfono: \(user.phone)").font(.subheadline)
                        Text("Email: \(user.email)").font(.body)
                    }
                }
            }
            .navigationTitle("Usuarios")
        }
    }
}


struct UserDetailView: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Nombre: \(user.name)").font(.title2).bold()
            Text("Teléfono: \(user.phone)").font(.body)
            Text("Email: \(user.email)").font(.body)
            Spacer()
        }
        .padding()
        .navigationTitle("Detalles del Usuario")
    }
}

#Preview {
    ContentView(coordinator: AppCoordinator())
}
