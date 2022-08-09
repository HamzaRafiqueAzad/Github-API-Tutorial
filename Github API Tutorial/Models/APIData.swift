//
//  APIData.swift
//  iOS Test Assignment
//
//  Created by Hamza Rafique Azad on 10/5/22.
//

import Foundation

struct APIData: Decodable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [UserModel]
}
