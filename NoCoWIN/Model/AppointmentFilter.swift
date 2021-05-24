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
    
    init(ageLimit: AgeLimit, dosage: Dosage){
        self.ageLimit = ageLimit
        self.dosage = dosage
    }
    
    func getAgeLimit()-> AgeLimit{
        return ageLimit
    }
    
    func getDosage()-> Dosage{
        return dosage
    }
}
