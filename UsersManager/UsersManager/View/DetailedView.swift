//
//  DetailedView.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import SwiftUI

struct UserDetailView: View {
    let user: User
    @ObservedObject var viewModel: UsersViewModel
    
    @State private var editedName: String
    @State private var editedEmail: String
    
    init(user: User, viewModel: UsersViewModel) {
        self.user = user
        self.viewModel = viewModel
        _editedName = State(initialValue: user.name)
        _editedEmail = State(initialValue: user.email)
    }

    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Imagen del usuario (siempre el placeholder)
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    // Información editable del usuario
                    Group {
                        Text("Usuario: \(user.username)").font(.body)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            TextField("Nombre", text: $editedName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            if !InputValidator.isValidName(editedName) {
                                Text("⚠️ El nombre no puede estar vacío.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            TextField("Email", text: $editedEmail)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                                .keyboardType(.emailAddress)
                            if !InputValidator.isValidEmail(editedEmail) {
                                Text("⚠️ El correo electrónico no es válido.")
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                        }

                        Text("Teléfono: \(user.phone)").font(.body)
                        Text("Sitio Web: \(user.website)").font(.body)
                    }
                    .padding(.horizontal)

                    Divider().padding(.vertical)

                    // Información de la dirección
                    Group {
                        Text("📍 Dirección").font(.title3).bold()
                        Text("Calle: \(user.address.street)").font(.body)
                        Text("Suite: \(user.address.suite)").font(.body)
                        Text("Ciudad: \(user.address.city)").font(.body)
                        Text("Código Postal: \(user.address.zipcode)").font(.body)
                        Text("Latitud: \(user.address.geo.lat)").font(.body)
                        Text("Longitud: \(user.address.geo.lng)").font(.body)
                    }
                    .padding(.horizontal)

                    Divider().padding(.vertical)

                    // Información de la empresa
                    Group {
                        Text("🏢 Empresa").font(.title3).bold()
                        Text("Nombre: \(user.company.name)").font(.body)
                        Text("Frase: \(user.company.catchPhrase)").font(.body)
                        Text("BS: \(user.company.bs)").font(.body)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }

            // Botón para guardar cambios (al final)
            Button(action: {
                viewModel.updateUser(user, newName: editedName, newEmail: editedEmail)
            }) {
                Text("Guardar cambios")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isValidInput() ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .disabled(!isValidInput())
            .padding(.bottom)
        }
        .navigationTitle("\(user.name)")
    }

    // Validación del formulario usando la clase estática
    private func isValidInput() -> Bool {
        return InputValidator.isValidName(editedName) && InputValidator.isValidEmail(editedEmail)
    }
}

