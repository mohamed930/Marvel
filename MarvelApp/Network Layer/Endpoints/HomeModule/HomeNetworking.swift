//
//  HomeNetworking.swift
//  Morizone
//
//  Created by Mohamed Ali on 22/11/2025.
//

import Foundation
import Alamofire
import CryptoKit

enum HomeNetworking {
    case fetchCharacters(limit: Int, offset: Int, publicKey: String, privateKey: String)
}

extension HomeNetworking: TargetType {
    var baseURL: Api {
        return .baseUrl
    }
    
    var path: Api {
        switch self {
        case .fetchCharacters:
            return .fetchCharacters
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchCharacters:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .fetchCharacters(let limit, let offset, let publicKey, let privateKey):
            let ts = String(Int(Date().timeIntervalSince1970 * 1000))
            let hash = Self.md5("\(ts)\(privateKey)\(publicKey)")
            let params: [String: Any] = [
                "limit": limit,
                "offset": offset,
                "ts": ts,
                "apikey": publicKey,
                "hash": hash
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding(destination: .queryString))
        }
    }
    
    var headers: [String : String]? {
        return [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
    }
}

private extension HomeNetworking {
    static func md5(_ value: String) -> String {
        let digest = Insecure.MD5.hash(data: Data(value.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
}
