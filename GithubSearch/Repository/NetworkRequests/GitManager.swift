//
//  UserManager.swift
//  githubExanple
//
//  Created by George Kyrylenko on 12/16/18.
//  Copyright © 2018 George Kyrylenko. All rights reserved.
//

import Foundation
import RxSwift
import Moya

class GitManager {
    let provider = MoyaProvider<GitProvider>()
    
    func loginUser(login: String, password: String) -> Observable<UserModel>{
        let loginPassword = "\(login):\(password)"
        return provider.rx.request(.Login(key: loginPassword.toBase64())).retry(5).filterSuccessfulStatusCodes().map(UserModel.self).asObservable()
    }
    
    func searchRepos(with name: String, page: Int)  -> Observable<RepositoriesModel> {
        return provider.rx.request(.SearchRepo(key: CurrentUserDefaultsManager.getUserKey() ?? "", page: page, repoName: name)).retry(5).filterSuccessfulStatusCodes().map(RepositoriesModel.self).asObservable()
    }
}
