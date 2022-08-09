//
//  Github_API_TutorialTests.swift
//  Github API TutorialTests
//
//  Created by Hamza Rafique Azad on 9/8/22.
//

import XCTest
import Alamofire
@testable import Github_API_Tutorial

class Github_API_TutorialTests: XCTestCase {
    
    var sut: APIManager!
    var sut1: APIData!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        sut = APIManager()
        
        sut1 = APIData(total_count: 0, incomplete_results: true, items: [])
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        sut1 = nil
        try super.tearDownWithError()
    }
    
    func testFetchUser() throws {
        let urlString = "\(sut.baseUrl)kashif&per_page=9&page=1"
        
        XCTAssertEqual(urlString, "https://api.github.com/search/users?q=kashif&per_page=9&page=1")
    }
    
    func testApiCallCompletes() throws {
        // given
        let urlString = "https://api.github.com/search/users?q=kashif&per_page=9"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        AF.request(url).validate().responseJSON { response in
            statusCode = response.response?.statusCode
            responseError = response.error
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
        // then
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    func testPassJson() throws {
        let data: Data = """
{"total_count":3515,"incomplete_results":false,"items":[{"login":"kashif","id":8100,"node_id":"MDQ6VXNlcjgxMDA=","avatar_url":"https://avatars.githubusercontent.com/u/8100?v=4","gravatar_id":"","url":"https://api.github.com/users/kashif","html_url":"https://github.com/kashif","followers_url":"https://api.github.com/users/kashif/followers","following_url":"https://api.github.com/users/kashif/following{/other_user}","gists_url":"https://api.github.com/users/kashif/gists{/gist_id}","starred_url":"https://api.github.com/users/kashif/starred{/owner}{/repo}","subscriptions_url":"https://api.github.com/users/kashif/subscriptions","organizations_url":"https://api.github.com/users/kashif/orgs","repos_url":"https://api.github.com/users/kashif/repos","events_url":"https://api.github.com/users/kashif/events{/privacy}","received_events_url":"https://api.github.com/users/kashif/received_events","type":"User","site_admin":false,"score":1.0}]}
""".data(using: .utf8)!
        
        sut1 = try JSONDecoder().decode(APIData.self, from: data)
        
        XCTAssertEqual(sut1.total_count, 3515)
        XCTAssertEqual(sut1.incomplete_results, false)
    }
    
}
