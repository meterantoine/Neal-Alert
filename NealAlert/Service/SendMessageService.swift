//
//  Service.swift
//  NealAlert
//
//  Created by Antoine Perry on 5/30/20.
//  Copyright © 2020 Antoine Perry. All rights reserved.
//

import Foundation

class SendMessageService {
    
    static let shared = SendMessageService()
    
    private let urlString = "https://\(TwilioinfoModel.shared.twilioSID):\(TwilioinfoModel.shared.twilioSecret)\(MessageEndpoint.Endpoint.base.url)\(TwilioinfoModel.shared.twilioSID)/SMS/Messages"
    
    func sendMessage(fromNumber: String = TwilioinfoModel.shared.fromNumber, _ toNubmer: String, _ body: String) {
        let parms = "From=\(fromNumber)&To=\(toNubmer)&Body=\(body)"
        guard let url = URL(string: urlString) else {
            fatalError("Trouble fetching url with error")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = parms.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error with data error\(error.localizedDescription)")
                return
            }
            if let data = data {
                DispatchQueue.main.async {
                    let dataString = String(data: data, encoding: String.Encoding.utf8)
                    print(dataString!)
                }
            }
        }.resume()
    }
}
