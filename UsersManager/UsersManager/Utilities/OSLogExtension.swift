//
//  OSLogExtension.swift
//  UsersManager
//
//  Created by Sandra Salamanca on 29/03/25.
//
import OSLog

// MARK: - OSLog Extension

extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let dataAccess = OSLog(subsystem: subsystem, category: "DataAccess")
    static let navigation = OSLog(subsystem: subsystem, category: "Navigation")
    static let businessLogic = OSLog(subsystem: subsystem, category: "BusinessLogic")
    static let view = OSLog(subsystem: subsystem, category: "View")
    static let network = OSLog(subsystem: subsystem, category: "Network")
}
