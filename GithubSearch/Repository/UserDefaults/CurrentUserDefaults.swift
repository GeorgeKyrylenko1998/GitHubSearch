//
//  CurrentUserDefaults.swift
//  githubExanple
//
//  Created by George Kyrylenko on 12/16/18.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import Foundation

class CurrentUserDefaultsManager{
    private static let userKey = "userKey"
    
    private static let defaults = UserDefaults.standard
    
    static func setUserKey(key: String){
        defaults.setValue(key, forKey: userKey)
    }
    
    static func getUserKey() -> String?{
        let key = defaults.string(forKey: userKey)
        return key
    }
    
    static func cleanUserDefaults(){
        defaults.setValue(nil, forKey: userKey)
    }
}
