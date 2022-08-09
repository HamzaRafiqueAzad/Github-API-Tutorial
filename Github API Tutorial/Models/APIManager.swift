//
//  APIManager.swift
//  Github API Tutorial
//
//  Created by Hamza Rafique Azad on 9/8/22.
//

import Foundation
import Alamofire


protocol APIManagerDelegate {
    func didUpdate(_ apiManager: APIManager, userModel: [UserModel])
    func didFailWithError(error: Error)
}


struct APIManager {
    let baseUrl = "https://api.github.com/search/users?q="
    
    var delegate: APIManagerDelegate?
    
    func fetchUsers(userLogin: String, page: Int) {
        let urlString = "\(baseUrl)\(userLogin)&per_page=9&page=\(page)"
        
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString){
            
            AF.request(url).validate().responseJSON { response in
                if let error = response.error {
                    self.delegate?.didFailWithError(error: error)
                } else if let safeData = response.data {
                    if let user = self.passJSON(safeData) {
                        self.delegate?.didUpdate(self, userModel: user)
                    }
                }
            }
        }
    }
    
    func passJSON(_ userData: Data) -> [UserModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(APIData.self, from: userData)
            let items = decodedData.items
            
            var users = [UserModel]()
            for user in items {
                let userModel = UserModel(avatar_url: user.avatar_url, login: user.login, type: user.type)
                users.append(userModel)
            }
            
            return users
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
