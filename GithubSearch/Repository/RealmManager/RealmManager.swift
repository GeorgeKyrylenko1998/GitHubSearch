//
//  RealmManager.swift
//  GithubSearch
//
//  Created by George Kyrylenko on 01.09.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager{
    
    private var realm = try! Realm()
    
    func getViewedRepos() -> [RepoRealmModel]{
        let viewedRepos = Array(realm.objects(RepoRealmModel.self))
        return viewedRepos
    }
    
    func addRepos(repos: [RepoRealmModel]){
        for repo in repos{
            if getRepo(by: repo.url) == nil{
                try! realm.write{
                    realm.add(repo)
                }
            }
        }
    }
    
    func removeRepo(by URL: String?){
        guard let repo = getRepo(by: URL) else {return}
        try! realm.write{
            realm.delete(repo)
        }
    }
    
    func markAsViwedRepo(by URL: String?){
        guard let repo = getRepo(by: URL) else {return}
        try! realm.write{
            repo.setValue(true, forKey: "isViewd")
        }
    }
    
    func getRepo(by url: String?) -> RepoRealmModel?{
        return realm.objects(RepoRealmModel.self).filter("url == '\(url ?? "")'").first
    }
}
