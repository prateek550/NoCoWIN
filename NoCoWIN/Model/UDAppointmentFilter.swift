//
//  UDAppointmentFilter.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 26/05/21.
//

import Foundation
class UDAppointmentFilter: NSObject, NSCoding{
    
    private let ageLimit: Int
    private let dosage: Int
    private var district: Int
    
    func encode(with coder: NSCoder) {
        coder.encode(ageLimit, forKey: "ageL")
        coder.encode(dosage, forKey: "dosage")
        coder.encode(district, forKey: "district")
    }
    
    required init?(coder: NSCoder) {
        ageLimit = coder.decodeInteger(forKey: "ageL")
        dosage = coder.decodeInteger(forKey: "dosage")
        district = coder.decodeInteger(forKey: "district")
    }
    
    init(filter: AppointmnetFilter){
        ageLimit = filter.getAgeLimit().rawValue
        dosage = filter.getDosage().rawValue
        district = filter.getDistrict().rawValue
    }
    
    func getAppoitmentFilter()-> AppointmnetFilter{
        return AppointmnetFilter(ageLimit: AgeLimit(rawValue: ageLimit)! , dosage: Dosage(rawValue: dosage)!, district: Districts(rawValue: district)!)
    }
}
