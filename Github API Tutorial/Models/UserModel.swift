//
//  UserModel.swift
//  Github API Tutorial
//
//  Created by Hamza Rafique Azad on 9/8/22.
//

import Foundation


struct UserModel: Decodable {
    let avatar_url: String
    let login: String
    let type: String
}
