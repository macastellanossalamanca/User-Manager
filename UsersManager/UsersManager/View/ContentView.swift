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
                            Text(String(format: NSLocalizedString("Phone", comment: ""), user.phone)).font(.body)
                            Text(String(format: NSLocalizedString("Email", comment: ""), user.email)).font(.body)
                            Text(String(format: NSLocalizedString("City", comment: ""), user.address.city)).font(.body)

                        }
                    }
                }
                .onDelete(perform: deleteUser)
            }
            .navigationTitle(LocalizedStringKey("Users"))
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
                TextField(LocalizedStringKey("Name"), text: $name)
                TextField(LocalizedStringKey("EmailPlaceHolder"), text: $email)
                    .keyboardType(.emailAddress)
                TextField(LocalizedStringKey("PhonePlaceHolder"), text: $phone)
                    .keyboardType(.phonePad)

                if !latitude.isEmpty && !longitude.isEmpty {
                    Text(String(format: NSLocalizedString("Latitude", comment: ""), latitude))
                    Text(String(format: NSLocalizedString("Longitude", comment: ""), longitude))
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
                        Text(LocalizedStringKey("GetLocation"))
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("AddUser"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(LocalizedStringKey("Cancel")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(LocalizedStringKey("save_changes")) {
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
            errorMessage = NSLocalizedString("EmptyNameError", comment: "")
            return false
        }

        guard InputValidator.isValidEmail(email) else {
            errorMessage = NSLocalizedString("InvalidEmailError", comment: "")
            return false
        }

        errorMessage = ""
        return true
    }

    private func getLocation() {
        isLoadingLocation = true
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
