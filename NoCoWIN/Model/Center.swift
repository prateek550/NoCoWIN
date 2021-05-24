//
//  Center.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 23/05/21.
//
import Foundation

// MARK: - Welcome
struct Slots: Codable {
    let centers: [Center]?
    
    enum CodingKeys: String, CodingKey{
        case centers = "centers"
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        centers = try values.decodeIfPresent([Center].self, forKey: .centers)
    }
}

// MARK: - Center
struct Center: Codable {
    let centerID: Int?
    let name, /*nameL,*/ address/*, addressL*/: String?
    let stateName/*, stateNameL, districtName, districtNameL*/: String?
    //let blockName, blockNameL, pincode: String?
    //let lat, long: Double?
    let /*from, to,*/ feeType: String?
    let vaccineFees: [VaccineFee]?
    var sessions: [Session]?

    enum CodingKeys: String, CodingKey {
        case centerID = "center_id"
        case name = "name"
//        case nameL = "name_l"
        case address = "address"
//        case addressL = "address_l"
        case stateName = "state_name"
//        case stateNameL = "state_name_l"
//        case districtName = "district_name"
//        case districtNameL = "district_name_l"
//        case blockName = "block_name"
//        case blockNameL = "block_name_l"
//        case pincode, lat, long, from, to
        case feeType = "fee_type"
        case vaccineFees = "vaccine_fees"
        case sessions = "sessions"
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        centerID = try values.decodeIfPresent(Int.self, forKey: .centerID)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        stateName = try values.decodeIfPresent(String.self, forKey: .stateName)
        feeType = try values.decodeIfPresent(String.self, forKey: .feeType)
        vaccineFees = try values.decodeIfPresent([VaccineFee].self, forKey: .vaccineFees)
        sessions = try values.decodeIfPresent([Session].self, forKey: .sessions)
    }
}

// MARK: - VaccineFee
struct VaccineFee: Codable {
    let vaccine, fee: String?
    
    enum CodingKeys: String, CodingKey {
        case vaccine = "vaccine"
        case fee = "fee"
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        vaccine = try values.decodeIfPresent(String.self, forKey: .vaccine)
        fee = try values.decodeIfPresent(String.self, forKey: .fee)
    }
}
