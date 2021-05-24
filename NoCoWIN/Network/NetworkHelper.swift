//
//  NetworkHelper.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 16/05/21.
//

import Foundation
import Alamofire

typealias RequestParams = [URLQueryItem]
typealias ServiceResponse = (data: Data?, error: Error?)

struct NetworkHelper{
    
    private static let baseURL = "https://cdn-api.co-vin.in/api/v2"
    
    private static func getBaseURL()-> URL {
        return URL(string: baseURL)!
    }
    
    private static func getURL(endpoint: URLHelper)-> URL {
        return URL(string: baseURL)!.appendingPathComponent(URLHelper.getEndpoint(url: endpoint))
    }
    
    private static func constructURL(requestParams: RequestParams, endpoint: URLHelper)-> URL?{
    
        var urlComponent = URLComponents(url: getURL(endpoint: endpoint), resolvingAgainstBaseURL: false)
        if nil == urlComponent?.queryItems{
            urlComponent?.queryItems = []
        }
        for param in requestParams{
            urlComponent?.queryItems?.append(param)
        }
        return urlComponent?.url
    }
    
    static func fetchRequest(endpoint: URLHelper, requestParams: Parameters?=nil, queryParam: RequestParams?=nil, response: @escaping (ServiceResponse?)-> Void){
        
        if URLHelper.getRequestType(url: endpoint) == .get{
            fetchGETRequest(endpoint: endpoint, requestParams: queryParam!, response: response)
        }
        else {
            fetchPOSTRequest(endpoint: endpoint, requestParams: requestParams!, response: response)
        }
    }
    
    static func fetchPOSTRequest(endpoint: URLHelper, requestParams: Parameters, response: @escaping (ServiceResponse?)->Void){
        
        Alamofire.request(getURL(endpoint: endpoint), method: URLHelper.getRequestType(url: endpoint), parameters: requestParams, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { res in
                switch res.response?.statusCode{
                case 200:
                    response((res.data, nil))
                case 401:
                    UserDefaults.standard.removeObject(forKey: ViewController.TOKEN_KEY)
                default:
                    response((nil, res.error))
                }
            }                
    }
    
    static func fetchGETRequest(endpoint: URLHelper, requestParams: RequestParams, response: @escaping (ServiceResponse?)->Void){
        
        if let url = constructURL(requestParams: requestParams, endpoint: endpoint){
            
            print("Request URL: " + url.absoluteString)
        
            Alamofire.request( url, method: URLHelper.getRequestType(url: endpoint), encoding: JSONEncoding.default, headers: URLHelper.getHeaders(url: endpoint))
                .validate()
                .responseJSON { res in
                    switch res.response?.statusCode{
                    case 200:
                        response((res.data, nil))
                    case 401:
                        UserDefaults.standard.removeObject(forKey: ViewController.TOKEN_KEY)
                    default:
                        response((nil, res.error))
                    }
                }
        }
    }
}
