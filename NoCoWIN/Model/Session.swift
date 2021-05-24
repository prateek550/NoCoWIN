//
//  Session.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 23/05/21.
//

import Foundation

// MARK: - Session
struct Session: Codable {
    let sessionID, date: String?
    let availableCapacity, availableCapacityDose1, availableCapacityDose2, minAgeLimit: Int?
    let vaccine: String?
    let slots: [String]?

    enum CodingKeys: String, CodingKey {
        case sessionID = "session_id"
        case date = "date"
        case availableCapacity = "available_capacity"
        case availableCapacityDose1 = "available_capacity_dose1"
        case availableCapacityDose2 = "available_capacity_dose2"
        case minAgeLimit = "min_age_limit"
        case vaccine = "vaccine"
        case slots = "slots"
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sessionID = try values.decodeIfPresent(String.self, forKey: .sessionID)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        availableCapacity = try values.decodeIfPresent(Int.self, forKey: .availableCapacity)
        availableCapacityDose1 = try values.decodeIfPresent(Int.self, forKey: .availableCapacityDose1)
        availableCapacityDose2 = try values.decodeIfPresent(Int.self, forKey: .availableCapacityDose2)
        minAgeLimit = try values.decodeIfPresent(Int.self, forKey: .minAgeLimit)
        vaccine = try values.decodeIfPresent(String.self, forKey: .vaccine)
        slots = try values.decodeIfPresent([String].self, forKey: .slots)
    }
}
