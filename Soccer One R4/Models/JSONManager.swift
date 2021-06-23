//
//  JSONManager.swift
//  Soccer One
//
//  Created by Daniil Marusenko on 04.12.2020.
//

import Foundation
import Alamofire

protocol JSONManagerDelegate {
    func didUpdateData(_ JSONManager: JSONManager, data: [[String]])
}

struct JSONManager {
    
    var delegate: JSONManagerDelegate?
    
    func getData(with url: String) {
        AF.request(url).response { response in
            if let data = response.data {
                if let decodedData = self.parseJSON(data) {
                    self.delegate?.didUpdateData(self, data: decodedData)
                }
            }
        }
    }
    
    
    private func parseJSON(_ data: Data) -> [[String]]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(JSONData.self, from: data)
            return decodedData.array
        } catch {
            return nil
        }
    }
    
}

