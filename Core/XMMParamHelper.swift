//
//  XMMParamHelper.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation
import CoreLocation

class XMMParamHelper {
    
    static func paramsWithLanguage(language: String) -> [String: String] {
        let params = ["lang": language]
        return params
    }
    
    static func paramsWithLanguage(language: String,
                                   identifier:String) -> [String: String] {
        var params = paramsWithLanguage(language: language)
        params["filter[location-identifier"] = identifier
        return params
    }
    
    static func paramsWithLanguage(language: String,
                                   location: CLLocation) -> [String: String] {
        var params = paramsWithLanguage(language: language)
        params["filter[lat]"] = String(location.coordinate.latitude)
        params["filter[lon]"] = String(location.coordinate.longitude)
        return params
    }
    
    static func paramsWithLanguage(language: String,
                                   location: CLLocation,
                                   radius: Int) -> [String: String] {
        var params = paramsWithLanguage(language: language)
        params["filter[lat]"] = String(location.coordinate.latitude)
        params["filter[lon]"] = String(location.coordinate.longitude)
        params["filter[radius]"] = String(radius)
        return params
    }
    
    static func addPagingToParams(params: [String: String],
                                  pageSize: Int,
                                  cursor: String?) -> [String: String] {
        var mutableParams = params
        
        if pageSize != 0 {
            mutableParams["page[size]"] = String(pageSize)
        }
        if cursor != nil {
            mutableParams["page[cursor]"] = cursor
        }
        return mutableParams
    }
    
    static func addFiltersToParams(params: [String: String],
                                   filters: XMMFilter) -> [String: String] {
        var mutableParams = params
        
        if filters.fromDate != nil {
            mutableParams["filter[meta-datetime-from]"] = filters.fromDate!.ISO8601()
        }
        if filters.toDate != nil {
            mutableParams["filter[meta-datetime-to]"] =  filters.toDate!.ISO8601()
        }
        if filters.relatedSpot != nil {
            mutableParams["filter[related-spot]"] = filters.relatedSpot!
        }
        if filters.name != nil {
            mutableParams["filter[name]"] = filters.name
        }
        if filters.tags != nil {
            let tagsParameter = "[\"\(String(describing: filters.tags!.joined(separator: "\",\"")))"
            mutableParams["filter[tags]"] = tagsParameter
        }
        return mutableParams
    }
    
    static func addContentOptionsToParams(params: [String: String],
                                          options: XMMContentOptions) -> [String: String] {
        var mutableParams = params
        
        if options.contains(.XMMContentOptionsNone) == false {
            let optionsDict = contentOptionsToDictionary(options: options)
            for (key, value) in optionsDict {
                mutableParams[key] = value
            }
        }
        return mutableParams
    }
    
    static func addContentSortOptionsToParams(params: [String: String],
                                              options: XMMContentSortOptions) -> [String: String] {
        var mutableParams = params
        
        if options.contains(.XMMContentSortOptionsNone) == false {
            let sortParameter = contentSortOptionsToArray(sortOptions: options)
            mutableParams["sort"] = sortParameter.joined(separator: ",")
        }
        return mutableParams
    }
    
    static func addSpotOptionsToParams(params: [String: String], options: XMMSpotOptions) -> [String: String] {
        var mutableParams = params
        
        if options.contains(.XMMSpotOptionsNone) == false {
            let optionsDict = spotOptionsToDictionary(options: options)
            for (key, value) in optionsDict{
                mutableParams[key] = value
            }
        }
        return mutableParams
    }
    
    static func addSpotSortOptionsToParams(params: [String: String],
                                              options: XMMSpotSortOptions) -> [String: String] {
        var mutableParams = params
        
        if options.contains(.XMMSpotSortOptionsNone) == false {
            let sortParameter = spotSortOptionsToArray(sortOption: options)
            mutableParams["sort"] = sortParameter.joined(separator: ",")
        }
        return mutableParams
    }
    
    // MARK: - helper
    
    static func contentOptionsToDictionary(options: XMMContentOptions) -> [String: String] {
        var optionsDict: [String: String] = [:]
        
        if options.contains(.XMMContentOptionsPreview) {
            optionsDict["preview"] = "true"
        }
        if options.contains(.XMMContentOptionsPrivate) {
            optionsDict["public-only"] = "true"
        }
        return optionsDict
    }
    
    static func contentSortOptionsToArray(sortOptions: XMMContentSortOptions) -> [String] {
        var sortParameters: [String] = []
        
        if sortOptions.contains(.XMMContentSortOptionsTitle) {
            sortParameters.append("name")
        }
        if sortOptions.contains(.XMMContentSortOptionsTitleDesc) {
            sortParameters.append("-name")
        }
        if sortOptions.contains(.XMMContentSortOptionsFromDate) {
            sortParameters.append("meta-datetime-from")
        }
        if sortOptions.contains(.XMMContentSortOptionsFromDateDesc) {
            sortParameters.append("-meta-datetime-from")
        }
        if sortOptions.contains(.XMMContentSortOptionsToDate) {
            sortParameters.append("meta-datetime-to")
        }
        if sortOptions.contains(.XMMContentSortOptionsToDateDesc) {
            sortParameters.append("-meta-datetime-to")
        }
        return sortParameters
    }
    
    static func spotOptionsToDictionary(options: XMMSpotOptions) -> [String: String] {
        var optionsDict: [String: String] = [:]
        
        if options.contains(.XMMSpotOptionsIncludeMarker) {
            optionsDict["include_markers"] = "true"
        }
        if options.contains(.XMMSpotOptionsIncludeContent) {
            optionsDict["include_content"] = "true"
        }
        if options.contains(.XMMSpotOptionsWithLocation) {
            optionsDict["filter[has-location]"] = "true"
        }
        return optionsDict
    }
    
    static func spotSortOptionsToArray(sortOption: XMMSpotSortOptions) -> [String] {
        var sortParameters: [String] = []
        if sortOption.contains(.XMMSpotSortOptionsName) {
            sortParameters.append("name")
        }
        if sortOption.contains(.XMMSpotSortOptionsNameDesc) {
            sortParameters.append("-name")
        }
        if sortOption.contains(.XMMSpotSortOptionsDistance) {
            sortParameters.append("distance")
        }
        if sortOption.contains(.XMMSpotSortOptionsDistanceDesc) {
            sortParameters.append("-distance")
        }
        return sortParameters
    }
    
    static func addConditionsToParams(params: [String: String],
                                      conditions: [String: Any]) -> [String: String] {
        var newParams: [String: String] = params
        for key in conditions.keys {
            let value = conditionToString(condition: conditions[key]!)
            if value != nil {
                newParams[key] = value
            }
        }
        return newParams
    }
    
    static func conditionToString(condition: Any) -> String? {
        if condition is String {
            return (condition as! String)
        }
        if condition is Int {
            let nubber = condition as! Int
            return String(nubber)
        }
        if condition is Date {
            let date = condition as! Date
            return String(date.ISO8601())
        }
        return nil
    }
    
    static func addRecommendationsToParams(params: [String: String]) -> [String: String] {
        var newParams = params
        newParams["recommend"] = "true"
        return newParams
    }
}
