//
//  TwilioInfoModel.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/30/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import Foundation

struct TwilioinfoModel {
    static let shared = TwilioinfoModel()
    
    var toNumber: String {
        return ""
    }
    
    var fromNumber: String {
        return "+Place your from number here"
    }
    
    var body: String {
        return ""
    }
    
    var twilioSID: String {
        return "Place Your twilio SID here"
    }
    
    var twilioSecret: String {
        return "Place Your twilio secret here"
    }
}
