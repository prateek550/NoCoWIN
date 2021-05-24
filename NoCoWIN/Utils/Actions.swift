//
//  Actions.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 18/05/21.
//

import Foundation

enum Actions{
    
    case USER_INPUT_PHONE
    case USER_INPUT_OTP
//    case REQUEST_OTP
    case GENERATE_TOKEN
    case USER_INPUT_REQUEST_CENTER
    case REQUEST_CENTRE
    case VIEW_APPOINTMENTS
    
    static func isUserInputRequired(_for action: Actions)-> Bool{
        
        switch action {
        case .USER_INPUT_OTP:
            return true
        case .USER_INPUT_PHONE:
            return true
        case .USER_INPUT_REQUEST_CENTER:
            return true
        default:
            return false
        }
    }
    
    static func getActionName(_for action: Actions)-> String{
        switch action {
        case .USER_INPUT_PHONE:
            return "Request OTP"
        case .USER_INPUT_OTP:
            return "Submit"
        case .USER_INPUT_REQUEST_CENTER:
            return "💉 Request Centers 💉"
        default:
            return "Please Wait ..."
        }
    }
    
    static func getFieldPlaceholder(_for action: Actions)-> String{
        switch action {
        case .USER_INPUT_PHONE:
            return "Enter phone number"
        case .USER_INPUT_OTP:
            return "Enter OTP"
        default:
            return "Please Wait ..."
        }
    }
}
