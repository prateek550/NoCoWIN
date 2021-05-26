//
//  Dosage.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 23/05/21.
//

import Foundation

enum Dosage: Int, CaseIterable{
    
    case First_Dose = 1
    case Booster_Dose = 2
    
    static func getDisplay(dose: Dosage)-> String{
        switch dose {
        case .First_Dose:
            return "1st Dose"
        case .Booster_Dose:
            return "Booster Dose"
        }
    }
}
