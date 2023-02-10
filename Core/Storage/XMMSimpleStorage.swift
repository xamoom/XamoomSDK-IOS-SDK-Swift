//
//  XMMSimpleStorage.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 26.01.2023.
//

import Foundation
import CoreLocation

class XMMSimpleStorage {
    
    let userDefault: UserDefaults
    
    init() {
        self.userDefault = UserDefaults.standard
    }
    
    func saveTags(tags: [String]) {
        self.userDefault.set(tags, forKey: "com.xamoom.ios.offlineTags")
    }
    
    func readTags() -> [String] {
        let tags = self.userDefault.array(forKey: "com.xamoom.ios.offlineTags")
        return (tags ?? []) as! [String]
    }
    
    func saveLocation(location: [String: String]) {
        self.userDefault.set(location, forKey: "com.xamoom.ios.location")
    }
    
    func getLocation() -> CLLocation? {
        let location = self.userDefault.dictionary(forKey: "com.xamoom.ios.location")
        
        if location != nil {
            let lat = location!["lat"] as! Double
            let lon = location!["lon"] as! Double
            let l = CLLocation(latitude: lat, longitude: lon)
            return l 
        } else {
            return nil
        }
    }
    
    func saveUserToken(token: String) {
        self.userDefault.set(token, forKey: "com.xamoom.ios.userToken")
    }
    
    func getUserToken() -> String? {
        let token = self.userDefault.string(forKey: "com.xamoom.ios.userToken")
        return token ?? nil
    }
}
