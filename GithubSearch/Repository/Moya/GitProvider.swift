//
//  API.swift
//
//  Generated usign MoyaPaw Export https://github.com/narlei/SwiftMoyaCodeGenerator.git

import Moya

public enum GitProvider {
    case Login(key: String)
    case SearchRepo(key: String, page: Int, repoName: String)
}

extension GitProvider: TargetType {
    
    public var baseURL: URL { return URL(string: "https://api.github.com")! }
    
    public var path: String {
        switch self {
        case .Login:
            return "/user"
        case .SearchRepo:
            return "/search/repositories"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .Login, .SearchRepo:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        case .Login:
            return .requestPlain
        case .SearchRepo(_, let page, let repoName):
            var params: [String : Any] = [:]
            params["q"] = repoName
            params["page"] = page
            params["per_page"] = 15
            params["sort"] = "stars"
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        switch self {
        case .Login(let key), .SearchRepo(let key, _, _):
            return ["Content-Type" : "application/json", "Authorization" : "Basic \(key)"]
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
}

