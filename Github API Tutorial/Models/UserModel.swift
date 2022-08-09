//
//  UserModel.swift
//  iOS Test Assignment
//
//  Created by Hamza Rafique Azad on 10/5/22.
//

import Foundation


struct UserModel: Decodable {
    let avatar_url: String
    let login: String
    let type: String
}
