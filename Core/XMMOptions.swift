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
public struct XMMSpotOptions: OptionSet {
   public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
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
public struct XMMContentSortOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    /// No sorting.
    public static let none = Self(rawValue: 0 << 0)
    /// Sort by name ascending.
    public static let title = Self(rawValue: 1 << 0)
    /// Sort by name descending.
    public static let titleDesc = Self(rawValue: 1 << 1)
    /// Sort by from date ascending.
    public static let fromDate = Self(rawValue: 1 << 2)
    /// Sort by from date descending.
    public static let fromDateDesc = Self(rawValue: 1 << 3)
    /// Sort by to date ascending.
    public static let toDate = Self(rawValue: 1 << 4)
    /// Sort by to date descending.
    public static let toDateDesc = Self(rawValue: 1 << 4)
}

/**
 * XMMSpot sorting options.
 */
public struct XMMSpotSortOptions: OptionSet {
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    /// No sorting.
    public static let none = Self(rawValue: 0 << 0)
    /// Sort by name ascending.
    public static let name = Self(rawValue: 1 << 0)
    /// Sort by name descending.
    public static let nameDesc = Self(rawValue: 1 << 1)
    /// Sort by distance ascending.
    public static let distance = Self(rawValue: 1 << 2)
    /// Sort by distance descending.
    public static let distanceDesc = Self(rawValue: 1 << 3)
}
