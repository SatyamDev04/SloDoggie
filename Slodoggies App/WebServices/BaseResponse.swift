//
//  BaseResponse.swift
//  LawCo
//
//  Created by YATIN  KALRA on 12/06/24.
//

import Foundation

struct BaseResponse<T: Decodable>: Decodable {
    let success: Bool?
    let message: String?
    let code: Int?
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case success, message, data, code
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.success = try container.decodeIfPresent(Bool.self, forKey: .success)
        self.message = try container.decodeIfPresent(String.self, forKey: .message)
        self.code = try container.decodeIfPresent(Int.self, forKey: .code)
        
        // Decode data only if API indicates success
        if (success ?? false) {
            self.data = try container.decodeIfPresent(T.self, forKey: .data)
        } else {
            self.data = nil
        }
    }
}
