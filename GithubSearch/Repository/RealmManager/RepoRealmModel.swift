//
//  RepoRealmModel.swift
//  GithubSearch
//
//  Created by George Kyrylenko on 01.09.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class RepoRealmModel: Object{
     @objc dynamic var name: String?
     @objc dynamic var url: String?
     @objc dynamic var stars: Int = 0
     @objc dynamic var isViewd: Bool = false
    
    override static func primaryKey() -> String? {
        return "url"
    }
    
    init(_name: String?, _url: String?, _stars: Int?) {
        name = _name
        url = _url
        stars = _stars ?? 0
    }
    
    required init() {
    }
}
