//
//  XMMFilter.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 18.01.2023.
//

import Foundation

class XMMFilterBuilder {
    var name: String?
    var tags: [String]?
    var fromDate: Date?
    var toDate: Date?
    var relatedSpot: String?
    
    init(){
        name = nil
        tags = nil
        fromDate = nil
        toDate = nil
        relatedSpot = nil
    }
}

class XMMFilter {
    private(set) var name: String?
    private(set) var tags: [String]?
    private(set) var fromDate: Date?
    private(set) var toDate: Date?
    private(set) var relatedSpot: String?
    
    init(builder: XMMFilterBuilder) {
        name = builder.name
        tags = builder.tags
        fromDate = builder.fromDate
        toDate = builder.toDate
        relatedSpot = builder.relatedSpot
    }
    
    convenience init() {
        let builder = XMMFilterBuilder()
        self.init(builder: builder)
    }
    
    static func makeWithBuilder(updateBlock: @escaping(_ builder: XMMFilterBuilder) -> Void) -> XMMFilter {
        let builder = XMMFilterBuilder()
        updateBlock(builder)
        return XMMFilter(builder: builder)
    }
}
