//
//  MessageEndPoint.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/30/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import Foundation

class MessageEndpoint {
    enum Endpoint: String {
        case base = "@api.twilio.com/2010-04-01/Accounts/"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
}
