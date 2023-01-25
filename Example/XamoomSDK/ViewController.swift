//
//  ViewController.swift
//  XamoomSDK
//
//  Created by IvanMagda-energ on 01/17/2023.
//  Copyright (c) 2023 IvanMagda-energ. All rights reserved.
//

import UIKit
import XamoomSDK

class ViewController: UIViewController {
    
    var api: XMMEnduserApi?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        api = XMMEnduserApi(apiKey: getApiKey())
//        contentWithID()
        contentWithLocationIdentifier()
    }
    
    private func contentWithID() {
        api!.contentWithId(contentId: "709", password: nil, completion: { (XMMContent, error, passwordRequired) in
        })
    }
    
    private func contentWithLocationIdentifier() {
        api?.contentWithLocationIdentifier(locationIdentifier: "b5v2p", options: XMMContentOptions.init(rawValue: 0), password: nil, completion: { (XMMContent, error, passwordRequired) in
            
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

