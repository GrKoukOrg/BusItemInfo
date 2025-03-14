//
//  SettingsManager.swift
//  BusItemsInfo
//
//  Created by George Koukoudis on 14/3/25.
//

import Foundation

enum AppSettings {
    // Key for UserDefaults
    private static let apiURLKey = "APIURL"
    
    // Load default from Plist
    private static var defaultAPIURL: String {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path),
              let url = dict["APIURL"] as? String else {
            fatalError("APIURL not found in Config.plist")
        }
        return url
    }
    
    // Get or set the API URL
    static var apiURL: String {
        get {
            // Check UserDefaults first, fall back to Plist default
            UserDefaults.standard.string(forKey: apiURLKey) ?? defaultAPIURL
        }
        set {
            UserDefaults.standard.set(newValue, forKey: apiURLKey)
        }
    }
    
    // Reset to default (optional)
    static func resetAPIURL() {
        UserDefaults.standard.removeObject(forKey: apiURLKey)
    }
}
