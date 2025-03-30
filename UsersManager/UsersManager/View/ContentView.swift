//
//  ContentView.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @ObservedObject var viewModel = UsersViewModel()
    @ObservedObject var coordinator: AppCoordinator
    @State private var showingAddUser = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users) { user in
                    NavigationLink(destination: UserDetailView(user: user, viewModel: viewModel)) {
                        VStack(alignment: .leading) {
                            Text(user.name).font(.headline)
                            Text("Teléfono: \(user.phone)").font(.subheadline)
                            Text("Email: \(user.email)").font(.body)
                            Text("Ciudad: \(user.address.city)").font(.body)
                        }
                    }
                }
                .onDelete(perform: deleteUser)
            }
            .navigationTitle("Usuarios")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddUser = true }) {
                        Label("Añadir", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddUser) {
                AddUserView(viewModel: viewModel)
            }
        }
    }

    private func deleteUser(at offsets: IndexSet) {
        for index in offsets {
            let user = viewModel.users[index]
            viewModel.deleteUser(user)
        }
    }
}

struct AddUserView: View {
    @ObservedObject var viewModel: UsersViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var errorMessage = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var isLoadingLocation = false

    var body: some View {
        NavigationView {
            Form {
                TextField("Nombre", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                TextField("Teléfono", text: $phone)
                    .keyboardType(.phonePad)

                if !latitude.isEmpty && !longitude.isEmpty {
                    Text("Latitud: \(latitude)")
                    Text("Longitud: \(longitude)")
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button(action: getLocation) {
                    if isLoadingLocation {
                        ProgressView()
                    } else {
                        Text("Obtener Ubicación Actual")
                    }
                }
            }
            .navigationTitle("Añadir Usuario")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") {
                        if validateInputs() {
                            let newUser = User(id: UUID().hashValue, name: name, username: name, email: email, address: Address(street: "", suite: "", city: "", zipcode: "", geo: Geo(lat: latitude, lng: longitude)), phone: phone, website: "", company: Company(name: "", catchPhrase: "", bs: ""))
                            viewModel.addUser(newUser)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(!InputValidator.isValidName(name) || !InputValidator.isValidEmail(email))
                }
            }
        }
    }

    private func validateInputs() -> Bool {
        guard InputValidator.isValidName(name) else {
            errorMessage = "El nombre no puede estar vacío."
            return false
        }

        guard InputValidator.isValidEmail(email) else {
            errorMessage = "El correo no es válido."
            return false
        }

        errorMessage = ""
        return true
    }

    private func getLocation() {
        isLoadingLocation = true
        LocationManager.shared.requestLocationPermissions()
        LocationManager.shared.getCurrentLocation { result in
            switch result {
            case .success(let location):
                latitude = String(location.coordinate.latitude)
                longitude = String(location.coordinate.longitude)
            case .failure(let error):
                errorMessage = "Error al obtener ubicación: \(error.localizedDescription)"
            }
            isLoadingLocation = false
        }
    }
}

// Preview
#Preview {
    ContentView(coordinator: AppCoordinator())
}
