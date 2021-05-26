//
//  CustomUserDefaultUtil.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 25/05/21.
//

import Foundation

typealias PreferenceKey = String

struct UserDefaultService{
    
    static let TOKEN_KEY = "TOKEN"
    static let USER_PHONE_KEY = "USER_PHONE"
    
    static let FILTER_KEY = "FILTER_KEY"
    
    static let APP_REFRESH_COUNTER = "REFRESH_COUNTER_KEY"
    static let SUCCESS_API_COUNTER = "SUCCESS_COUNTER_KEY"
    static let CENTERS_FOUND_COUNTER = "CENTERS_COUNTER_KEY"
    
    static func hasKey(for key: PreferenceKey)-> Bool{
        return (nil != UserDefaults.standard.value(forKey: key))
    }
    
    static func incrementPreferenceCounter(for key: PreferenceKey){
        var counter = (((UserDefaultService.getPreferences(for: key) as? Int) ?? 0) + 1)
        UserDefaultService.updatePreferences(for: key, value: counter)
    }
    
    static func getPreferences(for key: PreferenceKey)-> Any?{
        let value = UserDefaults.standard.value(forKey: key)
        
        if key == FILTER_KEY{
            return (NSKeyedUnarchiver.unarchiveObject(with: value as! Data) as? UDAppointmentFilter)?.getAppoitmentFilter()
        }
        
        return value
    }
    
    static func updatePreferences(for key: PreferenceKey, value: Any){
        if let filter = value as? AppointmnetFilter, key == FILTER_KEY{
            let udFilter = UDAppointmentFilter(filter: filter)
            if let encodedData: Data = try? NSKeyedArchiver.archivedData(withRootObject: udFilter, requiringSecureCoding: false){
                UserDefaults.standard.setValue(encodedData, forKey: key)
            }
        }
        else{
            UserDefaults.standard.setValue(value, forKey: key)
        }
    }
}
