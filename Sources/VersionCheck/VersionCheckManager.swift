// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

@MainActor
class VersionCheckManager {
    static let shared = VersionCheckManager()
    
    var bundleID: String? {
        return Bundle.main.bundleIdentifier
    }
    
    
    func checkIfAppUpdateAvailable() async -> ReturnResult? {
        do{
            guard let bundleID,let lookupURL = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)")else{
                return nil
            }
            let data = try await URLSession.shared.data(from: lookupURL).0
            
            guard let rawJson = (try JSONSerialization.jsonObject(with: data)) as? Dictionary<String, Any> else {
                return nil
            }
            
            guard let jsonResults = rawJson["results"] as? [Any] else {
                return nil
            }
            
            guard let jsonValue = jsonResults.first as? Dictionary<String, Any> else {
                return nil
            }
            
            guard let availableVersion = jsonValue["version"] as? String,
                  let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                  let appLogo = jsonValue["artworkUrl512"] as? String,
                  let appURL = (jsonValue["trackViewUrl"] as? String)?.components(separatedBy: "?").first,
                  let releaseNotes = jsonValue["releaseNotes"] as? String else{
                return nil
            }
            
            if currentVersion.compare(availableVersion, options: .numeric) == .orderedAscending{
                return .init(currentVersion: currentVersion, availableVersion: availableVersion, releaseNotes: releaseNotes, appLogo: appLogo, appURL: appURL)
            }
            
            return nil
        } catch{
            print(error.localizedDescription)
            return nil
        }
        
    }
    
    
    
    struct ReturnResult: Identifiable {
        private(set) var id: String = UUID().uuidString
        var currentVersion: String
        var availableVersion: String
        var releaseNotes: String
        var appLogo: String
        var appURL: String
    }
    
}
