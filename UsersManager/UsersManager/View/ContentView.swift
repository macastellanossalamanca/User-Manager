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
            List {
                ForEach(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user, viewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                            Text("Teléfono: \(user.phone)").font(.subheadline)
                            Text("Email: \(user.email)").font(.body)
                        }
                    }
                }
                .onDelete(perform: deleteUser) // Eliminar usuario al deslizar
            }
            .navigationTitle("Usuarios")
            .toolbar {
                EditButton() // Botón para habilitar el modo edición
            }
        }
    }

    // Método para eliminar el usuario
    private func deleteUser(at offsets: IndexSet) {
        for index in offsets {
            let user = viewModel.users[index]
            viewModel.deleteUser(user)
        }
    }
}




#Preview {
    ContentView(coordinator: AppCoordinator())
}
