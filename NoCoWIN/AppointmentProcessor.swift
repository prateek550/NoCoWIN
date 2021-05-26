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
}
