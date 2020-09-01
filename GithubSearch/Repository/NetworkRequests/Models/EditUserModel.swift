// To parse the JSON, add this file to your project and do:
//
//   let editUser = try? newJSONDecoder().decode(EditUser.self, from: jsonData)

import Foundation

public struct EditUser: Codable {
    var name, email: String?
    var blog: String?
    var company, location: String?
    var hireable: Bool?
}
