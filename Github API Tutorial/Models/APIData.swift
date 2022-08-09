//
//  APIData.swift
//  Github API Tutorial
//
//  Created by Hamza Rafique Azad on 9/8/22.
//

import Foundation

struct APIData: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [UserModel]
}
