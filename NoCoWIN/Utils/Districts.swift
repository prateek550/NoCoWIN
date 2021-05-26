//
//  Districts.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 23/05/21.
//

import Foundation

enum Districts: Int, CaseIterable{
    
    case Bangalore_Urban = 1
    case East_Delhi = 2
    case North_Delhi = 3
    case Central_Delhi = 4
    case South_Delhi = 5
    
    public static func getDistrictId(district: Districts)-> Int{
        
        var id: Int
        
        switch district {
        case .Bangalore_Urban:
            id = 265
        case .East_Delhi:
            id = 145
        case .North_Delhi:
            id = 146
        case .South_Delhi:
            id = 149
        case .Central_Delhi:
            id = 141
        }
        return id
    }
    
    public static func getDisplayName(district: Districts)-> String{
        
        var name: String = ""
        
        switch district {
        case .Bangalore_Urban:
            name = "Bangalore"
        case .East_Delhi:
            name = "East Delhi"
        case .North_Delhi:
            name = "North Delhi"
        case .South_Delhi:
            name = "South Delhi"
        case .Central_Delhi:
            name = "East Delhi"
        }
        return name
    }
}
