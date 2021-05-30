//
//  AppointmentProcessor.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 25/05/21.
//

import Foundation

struct AppointmentProcessor{
    
    static func processSlots(slots: Slots?, filter: AppointmnetFilter?)-> [Center]{
        
        var filteredCenters: [Center] = []
        
        if let centers = slots?.centers, !centers.isEmpty{
            
            centers.forEach { center in
                if let sessions = center.sessions?.filter({ session in
                    if let ageLimit = filter?.getAgeLimit(), let dosage = filter?.getDosage(){
                        return (session.minAgeLimit ?? 0) == (ageLimit == .Eighteen ? 18 : 45) && (dosage == .First_Dose ? ((session.availableCapacityDose1 ?? 0) > 0) : ((session.availableCapacityDose2 ?? 0) > 0))
                    }
                    return true
                }), !sessions.isEmpty{
                    var filteredCenter = center
                    filteredCenter.sessions = sessions
                    filteredCenters.append(filteredCenter)
                }
            }
        }
        return filteredCenters
    }
    
    static func vaccineCount(centers: [Center], filter: AppointmnetFilter?)-> Int{
        
        return centers.reduce(0) { result, c in
            return result + vaccineCount(center: c, filter: filter)
        }
    }
    
    static func vaccineCount(center: Center, filter: AppointmnetFilter?)-> Int{
        
        return (center.sessions?.reduce(0, { result, s in
            if filter?.getDosage() == Dosage.First_Dose{
                return (result ?? 0) + (s.availableCapacityDose1 ?? 0)
            }
            else if filter?.getDosage() == Dosage.Booster_Dose{
                return (result ?? 0) + (s.availableCapacityDose2 ?? 0)
            }
            return (result ?? 0)
        }) ?? 0)
    }
}
