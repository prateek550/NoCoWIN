//
//  Token.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 23/05/21.
//

import Foundation

struct Token: Codable{
    
    let txnId: String?
    let token: String?
    
    enum CodingKeys: String, CodingKey{
        
        case txnId = "txnId"
        case token = "token"
    }
    
    init(from decoder: Decoder) throws{
        let values = try decoder.container(keyedBy: CodingKeys.self)
        txnId = try values.decodeIfPresent(String.self, forKey: .txnId)
        token = try values.decodeIfPresent(String.self, forKey: .token)
    }
}
