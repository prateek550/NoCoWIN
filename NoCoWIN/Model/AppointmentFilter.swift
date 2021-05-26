//
//  AppointmentFilter.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 23/05/21.
//

import Foundation

struct AppointmnetFilter{
    
    private let ageLimit: AgeLimit
    private let dosage: Dosage
    private var district: Districts
    
    init(ageLimit: AgeLimit, dosage: Dosage, district: Districts){
        self.ageLimit = ageLimit
        self.dosage = dosage
        self.district = district
    }
    
    func getAgeLimit()-> AgeLimit{
        return ageLimit
    }
    
    func getDosage()-> Dosage{
        return dosage
    }
    
    func getDistrict()-> Districts{
        return district
    }
}
