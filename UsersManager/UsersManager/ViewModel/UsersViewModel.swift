//
//  UsersViewModel.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import Foundation
import os

@MainActor
class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    var deletedUsers: [User] = []
    private let apiService = APIService.shared
    private let dbService = DatabaseService.shared
    
    init() {
        Task {
            await loadUsers()
        }
    }

    func loadUsers() async {
        do {
            os_log("Loading users...", log: .businessLogic)
            var fetchedUsers = try await apiService.fetchUsers()
            if !dbService.doesDBHaveUsersStored() {
                dbService.saveUsers(fetchedUsers)
            }
            for u in deletedUsers {
                fetchedUsers.removeAll { $0.id == u.id}
            }
            self.users = fetchedUsers
            os_log("Loaded users successfully", log: .businessLogic)
        } catch {
            os_log("Failed to fetch users from API, loading from local database", log: .businessLogic)
            self.users = dbService.fetchUsers()
        }
    }

    func deleteUser(_ user: User) async {
        do {
            os_log("Deleting user", log: .businessLogic)
            var fetchedUsers = try await apiService.fetchUsers()
            fetchedUsers.removeAll {$0.id == user.id}
            dbService.deleteUser(user)
            self.users = fetchedUsers
            deletedUsers.append(user)
            os_log("User deleted locally and from API", log: .businessLogic)
        } catch {
            dbService.deleteUser(user)
            self.users = dbService.fetchUsers()
        }
    }
    
    func addUser(_ user: User) {
        os_log("Adding user: ", log: .businessLogic)
        dbService.addUser(user)
        users.append(user)
        os_log("User added locally", log: .businessLogic)
        
    }
}
