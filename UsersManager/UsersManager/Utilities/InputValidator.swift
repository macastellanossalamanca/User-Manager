//
//  InputValidator.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//

import Foundation

final class InputValidator {
    
    // Valida si un nombre no está vacío
    static func isValidName(_ name: String) -> Bool {
        return !name.isEmpty
    }

    // Valida si el email tiene un formato correcto
    static func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}
