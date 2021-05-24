//
//  AgeLimit.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 23/05/21.
//

import Foundation

enum AgeLimit: CaseIterable{
    
    case Eighteen
    case FortyFive
    
    static func getDisplay(age: AgeLimit)-> String{
        switch age {
        case .Eighteen:
            return "18+"
        case .FortyFive:
            return "45+"
        }
    }
    
}
