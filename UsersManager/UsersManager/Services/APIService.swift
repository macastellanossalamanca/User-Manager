//
//  APIService.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import Alamofire
import os

struct APIService {
    static let shared = APIService()

    func fetchUsers() async throws -> [User] {
        os_log("Fetching users from API", log: .network)
        let url = Constants.API.usersApiKey
        let response = try await AF.request(url).serializingDecodable([User].self).value
        os_log("Fetched users from API", log: .network)
        return response
    }
}
