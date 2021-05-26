//
//  AppointmentService.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 25/05/21.
//

import Foundation

struct AppointmentService{
    
    static func getCenters(response: @escaping (Actions, Slots?)->Void){
        
        if let token = UserDefaultService.getPreferences(for: UserDefaultService.TOKEN_KEY) as? String, !token.isEmpty,
           let appointmentFilter = UserDefaultService.getPreferences(for: UserDefaultService.FILTER_KEY) as? AppointmnetFilter{
            
            print("token: "+token)
            
            let params: RequestParams = [URLQueryItem(name: "district_id", value: String(Districts.getDistrictId(district: appointmentFilter.getDistrict()))),
                                         URLQueryItem(name: "date", value: Utils.getDateAsString())]
            
            NetworkHelper.fetchRequest(endpoint: URLHelper.SLOTS_BY_CALENNDAR, queryParam: params) { res in
                
                if let data = res?.data{
                    if let slots = try? JSONDecoder().decode(Slots.self, from: data){
                        print(slots)
                        response(.VIEW_APPOINTMENTS, slots)
                    }
                }
                else{
                    print("fetching centers failed")
                    print(res?.error)
                    
                    response(.USER_INPUT_PHONE, nil)
                }
            }
        }
        else if let phone = UserDefaultService.getPreferences(for: UserDefaultService.USER_PHONE_KEY) as? String, !phone.isEmpty{
            response(.USER_INPUT_OTP, nil)
        }
        else{
            response(.USER_INPUT_PHONE, nil)
        }
    }
    
}
