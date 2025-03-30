import SwiftUI

struct UserDetailView: View {
    let user: User
    @ObservedObject var viewModel: UsersViewModel
    
    @State private var editedName: String
    @State private var editedEmail: String
    @Environment(\.presentationMode) var presentationMode
    
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
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.gray)
                        .padding()
                        .frame(maxWidth: .infinity)
                    
                    Group {
                        Text(String(format: NSLocalizedString("User", comment: ""), user.username)).font(.body)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            TextField(LocalizedStringKey("Name"), text: $editedName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .padding(.horizontal)
                            if !InputValidator.isValidName(editedName) {
                                Text(LocalizedStringKey("EmptyNameError"))
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
                                Text(LocalizedStringKey("InvalidEmailError"))
                                    .font(.caption)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                        }
                        
                        Text(String(format: NSLocalizedString("Phone", comment: ""), user.phone)).font(.body)
                        Text(String(format: NSLocalizedString("Web", comment: ""), user.website)).font(.body)

                    }
                    .padding(.horizontal)

                    Divider().padding(.vertical)

                    Group {
                        Text(LocalizedStringKey("Address")).font(.title3).bold()
                        Text(String(format: NSLocalizedString("Street", comment: ""), user.address.street)).font(.body)
                        Text(String(format: NSLocalizedString("Suite", comment: ""), user.address.suite)).font(.body)
                        Text(String(format: NSLocalizedString("City", comment: ""), user.address.city)).font(.body)
                        Text(String(format: NSLocalizedString("Postal Code", comment: ""), user.address.zipcode)).font(.body)
                        Text(String(format: NSLocalizedString("Latitude", comment: ""), user.address.geo.lat)).font(.body)
                        Text(String(format: NSLocalizedString("Longitude", comment: ""), user.address.geo.lng)).font(.body)
                    }
                    .padding(.horizontal)

                    Divider().padding(.vertical)

                    Group {
                        Text(LocalizedStringKey("Company")).font(.title3).bold()
                        Text(String(format: NSLocalizedString("CompoundName", comment: ""), user.company.name)).font(.body)
                        Text(String(format: NSLocalizedString("Phrase", comment: ""), user.company.catchPhrase)).font(.body)
                        Text(String(format: NSLocalizedString("BS", comment: ""), user.company.bs)).font(.body)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding()
            }

            Button(action: {
                viewModel.updateUser(user, newName: editedName, newEmail: editedEmail)
                presentationMode.wrappedValue.dismiss() // Cerrar la vista al guardar
            }) {
                Text(LocalizedStringKey("save_changes"))
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

    private func isValidInput() -> Bool {
        return InputValidator.isValidName(editedName) && InputValidator.isValidEmail(editedEmail)
    }
}
