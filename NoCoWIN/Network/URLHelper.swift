//
//  URLHelper.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 16/05/21.
//

import Foundation
import Alamofire

enum URLHelper{
    
    case GENERATE_OTP
    case VALIDATE_OTP
    case SLOTS_BY_CALENNDAR
    
    static func getEndpoint(url: URLHelper)-> String{
        
        switch url {
        case .GENERATE_OTP:
            return "/auth/public/generateOTP"
        case .VALIDATE_OTP:
            return "/auth/public/confirmOTP"
        case .SLOTS_BY_CALENNDAR:
            return "/appointment/sessions/public/calendarByDistrict"
        }
    }
    
    static func getRequestType(url: URLHelper)-> HTTPMethod{
        switch url {
        case .GENERATE_OTP:
            return HTTPMethod.post
        case .VALIDATE_OTP:
            return HTTPMethod.post
        case .SLOTS_BY_CALENNDAR:
            return HTTPMethod.get
        }
    }
    
    static func getHeaders(url: URLHelper)-> HTTPHeaders?{
        
        switch url {
        case .SLOTS_BY_CALENNDAR:
            return getAuthHeader()
        default:
            print("No auth required")
        }
        return nil
    }
    
    private static func getAuthHeader()-> HTTPHeaders?{
        
        if let token: String = UserDefaultService.getPreferences(for: UserDefaultService.TOKEN_KEY) as? String, !token.isEmpty{
            return ["Authorization":"Bearer " + token]
        }
        return nil
    }
}
