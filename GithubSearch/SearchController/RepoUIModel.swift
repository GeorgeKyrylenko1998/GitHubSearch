//
//  RepoUIModel.swift
//  GithubSearch
//
//  Created by George Kyrylenko on 01.09.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//

import Foundation

class RepoUIModel{
    let name: String?
    let url: String?
    let stars: Int?
    let isViewed: Bool
    init(_name: String?, _url: String?, _stars: Int?, _isViewed: Bool) {
        name = _name
        url = _url
        stars = _stars
        isViewed = _isViewed
    }
}
