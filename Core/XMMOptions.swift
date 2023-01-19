//
//  XMMOptions.swift
//  XamoomSDK
//
//  Created by Vladislav Cherednichenko on 18.01.2023.
//

import Foundation

/**
 * XMMContent special options.
 */
public struct XMMContentOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    
    /// No options.
   public static let XMMContentOptionsNone = Self(rawValue: 0 << 0)
    /// Will not save statistics.
   public static let XMMContentOptionsPreview = Self(rawValue: 1 << 0)
    /// Wont return ContentBlocks with "Hide Online" flag.
   public static let XMMContentOptionsPrivate = Self(rawValue: 1 << 1)
}

/**
 * XMMSpot special options.
 */
struct XMMSpotOptions: OptionSet {
    let rawValue: Int
    
    /// No options.
    static let XMMSpotOptionsNone = Self(rawValue: 0 << 0)
    /// Will include contentID to spots.
    static let XMMSpotOptionsIncludeContent = Self(rawValue: 1 << 0)
    /// Will include markers to spots.
    static let XMMSpotOptionsIncludeMarker = Self(rawValue: 1 << 1)
    /// Will only return spots with a location.
    static let XMMSpotOptionsWithLocation = Self(rawValue: 1 << 2)
}

/**
 * XMMContent sorting options.
 */
struct XMMContentSortOptions: OptionSet {
    let rawValue: Int
    
    /// No sorting.
    static let XMMContentSortOptionsNone = Self(rawValue: 0 << 0)
    /// Sort by name ascending.
    static let XMMContentSortOptionsTitle = Self(rawValue: 1 << 0)
    /// Sort by name descending.
    static let XMMContentSortOptionsTitleDesc = Self(rawValue: 1 << 1)
    /// Sort by from date ascending.
    static let XMMContentSortOptionsFromDate = Self(rawValue: 1 << 2)
    /// Sort by from date descending.
    static let XMMContentSortOptionsFromDateDesc = Self(rawValue: 1 << 3)
    /// Sort by to date ascending.
    static let XMMContentSortOptionsToDate = Self(rawValue: 1 << 4)
    /// Sort by to date descending.
    static let XMMContentSortOptionsToDateDesc = Self(rawValue: 1 << 4)
}

/**
 * XMMSpot sorting options.
 */
struct XMMSpotSortOptions: OptionSet {
    let rawValue: Int
    
    /// No sorting.
    static let XMMSpotSortOptionsNone = Self(rawValue: 0 << 0)
    /// Sort by name ascending.
    static let XMMSpotSortOptionsName = Self(rawValue: 1 << 0)
    /// Sort by name descending.
    static let XMMSpotSortOptionsNameDesc = Self(rawValue: 1 << 1)
    /// Sort by distance ascending.
    static let XMMSpotSortOptionsDistance = Self(rawValue: 1 << 2)
    /// Sort by distance descending.
    static let XMMSpotSortOptionsDistanceDesc = Self(rawValue: 1 << 3)
}
