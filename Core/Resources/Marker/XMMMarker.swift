//
//  XMMMarker.swift
//  XamoomSDKExamle
//
//  Created by Vladislav Cherednichenko on 10.01.2023.
//

import Foundation

/**
 * Marker from the xamoom cloud.
 * Markers are the representation of the physical part (qr, nfc, beacon) in the
 * xamoom cloud.
 * Every marker is connected to one XMMSpot.
 */

public class XMMMarker: XMMRestResource {
    
    static var resourceName: String {
        return "markers"
    }
    
    // MARK: - Properties
    
    var qr: String?
    var nfc: String?
    var beaconUUID: String?
    var beaconMajor: String?
    var beaconMinor: String?
    var eddyStoneUrl: String?
}
