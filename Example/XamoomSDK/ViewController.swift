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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let endUserApi = XMMEnduserApi(apiKey: "25c5606b-a7bf-42e2-85c3-39db1753bc05")
        endUserApi.contentWithId(contentId: "76856", password: nil, completion:{ content,error,passwordRequired in  })
    }
}

