//
//  UserModel.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

// MARK: - Models

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Geo: Codable {
    let lat: String
    let lng: String
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}

// MARK: - Extensions to parse to Realm Model

extension Geo {
    func toRealm() -> GeoRealm {
        let geoRealm = GeoRealm()
        geoRealm.lat = lat
        geoRealm.lng = lng
        return geoRealm
    }
}

extension Address {
    func toRealm() -> AddressRealm {
        let addressRealm = AddressRealm()
        addressRealm.street = street
        addressRealm.suite = suite
        addressRealm.city = city
        addressRealm.zipcode = zipcode
        addressRealm.geo = geo.toRealm()
        return addressRealm
    }
}

extension Company {
    func toRealm() -> CompanyRealm {
        let companyRealm = CompanyRealm()
        companyRealm.name = name
        companyRealm.catchPhrase = catchPhrase
        companyRealm.bs = bs
        return companyRealm
    }
}

extension User {
    func toRealm() -> UserRealm {
        let userRealm = UserRealm()
        userRealm.id = id
        userRealm.name = name
        userRealm.username = username
        userRealm.email = email
        userRealm.address = address.toRealm()
        userRealm.phone = phone
        userRealm.website = website
        userRealm.company = company.toRealm()
        return userRealm
    }
}
