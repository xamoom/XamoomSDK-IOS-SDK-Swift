//
//  XMMEnduserApi.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import UIKit
import XamoomSDK

class ViewController: UIViewController {
    
    var api: XMMEnduserApi?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = XMMEnduserApi(apiKey: getApiKey())
        contentWithID()
//        contentWithTags()
//        contentWithLocationIdentifier()
    }
    
    private func contentWithID() {
        api!.content(WithId: "709", password: nil, completion: { (XMMContent, error, passwordRequired) in
        })
    }
    
    private func contentWithTags() {
        var sort = XMMContentSortOptions.title
        api?.contents(WithTags: ["x-row-1"], pageSize: 10, cursor: nil, sortOptions: sort, completion: { (content, hasMore, cursor, error) in
            
        })
    }
    
    private func contentWithLocationIdentifier() {
        api?.content(WithLocationIdentifier: "b5v2p", options: XMMContentOptions.init(rawValue: 0), password: nil, completion: { (XMMContent, error, passwordRequired) in
            
        })
    }
    
    func getApiKey() -> String {
        var config: [String: Any]?
        if let infopListPath = Bundle.main.url(forResource: "TestingIDs", withExtension: "plist") {
            do {
                let infoPlistData = try Data(contentsOf: infopListPath)
                if let dict = try PropertyListSerialization.propertyList(from: infoPlistData, format: nil) as? [String: Any] {
                    config = dict
                }
            } catch {
                print(error)
            }
        }
        let apiKey = config!["APIKEY"] as! String
        return apiKey
    }
}

