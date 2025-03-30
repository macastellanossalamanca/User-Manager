//
//  RealmUserModel.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//
import RealmSwift

// Modelo User para Realm
class UserRealm: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String = ""
    @Persisted var username: String = ""
    @Persisted var email: String = ""
    @Persisted var address: AddressRealm?
    @Persisted var phone: String = ""
    @Persisted var website: String = ""
    @Persisted var company: CompanyRealm?
}

// Modelo Geo para Realm
class GeoRealm: Object {
    @Persisted var lat: String = ""
    @Persisted var lng: String = ""
}

// Modelo Address para Realm
class AddressRealm: Object {
    @Persisted var street: String = ""
    @Persisted var suite: String = ""
    @Persisted var city: String = ""
    @Persisted var zipcode: String = ""
    @Persisted var geo: GeoRealm?
}

// Modelo Company para Realm
class CompanyRealm: Object {
    @Persisted var name: String = ""
    @Persisted var catchPhrase: String = ""
    @Persisted var bs: String = ""
}

extension GeoRealm {
    func toGeo() -> Geo {
        return Geo(lat: lat, lng: lng)
    }
}

// MARK: Parse to codable extensions

extension AddressRealm {
    func toAddress() -> Address {
        return Address(street: street, suite: suite, city: city, zipcode: zipcode, geo: geo?.toGeo() ?? Geo(lat: "", lng: ""))
    }
}

extension CompanyRealm {
    func toCompany() -> Company {
        return Company(name: name, catchPhrase: catchPhrase, bs: bs)
    }
}

extension UserRealm {
    func toUser() -> User {
        return User(id: id, name: name, username: username, email: email, address: address?.toAddress() ?? Address(street: "", suite: "", city: "", zipcode: "", geo: Geo(lat: "", lng: "")), phone: phone, website: website, company: company?.toCompany() ?? Company(name: "", catchPhrase: "", bs: ""))
    }
}
