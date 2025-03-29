//
//  DatabaseService.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//
import Foundation
import RealmSwift
import os

// MARK: - DataBaseService Protocol

protocol DataBaseServiceProtocol {
    func saveUsers(_ users: [User])
    func fetchUsers() -> [User]
    func addUser(_ user: User)
    func deleteUser(_ user: User)
}


// MARK: - DataBaseService Implementation

class DatabaseService: DataBaseServiceProtocol {
    static let shared = DatabaseService()
    
    private var realm: Realm? {
        do {
            return try Realm()
        } catch {
            os_log("Error initializing Realm: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveUsers(_ users: [User]) {
        guard let realm = realm else { return }
        let realmUsers = users.map { $0.toRealm() }
        do {
            try realm.write {
                realm.add(realmUsers)
            }
            os_log("Users saved successfully. Count: \(users.count)")
        } catch {
            os_log("Failed to save users: \(error.localizedDescription)")
        }
    }
    
    func fetchUsers() -> [User] {
        guard let realm = realm else { return [] }
        
        let users = realm.objects(UserRealm.self).map{ $0.toUser() }
        os_log("Fetched users successfully. Count: \(users.count)")
        return Array(users)
    }
    
    func addUser(_ user: User) {
        guard let realm = realm else { return }
        let realmUser = user.toRealm()
        do {
            try realm.write {
                realm.add(realmUser)
            }
            os_log("User added: \(user.name) [ID: \(user.id)]")
        } catch {
            os_log("Failed to add user: \(error.localizedDescription)")
        }
    }

    func deleteUser(_ user: User) {
        guard let realm = realm else { return }
        let realmUser = user.toRealm()
        do {
            if let userToDelete = realm.object(ofType: UserRealm.self, forPrimaryKey: realmUser.id) {
                try realm.write {
                    realm.delete(userToDelete)
                }
                os_log("User deleted: \(userToDelete.name) [ID: \(userToDelete.id)]")
            } else {
                os_log("User not found for deletion")
            }
        } catch {
            os_log("Failed to delete user: \(error.localizedDescription)")
        }
    }
    
    func deleteAll() {
        guard let realm = realm else { return }
        do {
            try realm.write {
                realm.deleteAll()
            }
            os_log("All users deleted")
        } catch {
            os_log("Failed to delete users: \(error.localizedDescription)")
        }
    }
}
