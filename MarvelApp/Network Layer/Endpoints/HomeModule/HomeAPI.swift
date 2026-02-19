//
//  HomeAPI.swift
//  Morizone
//
//  Created by Mohamed Ali on 22/11/2025.
//

import Foundation
import Combine

protocol HomeAPIProtocol {
    func fetchCharacters(limit: Int, offset: Int) -> Future<BaseModel<[ResultModel]>, NSError>
}

class HomeAPI: BaseAPI<HomeNetworking>, HomeAPIProtocol {
    func fetchCharacters(limit: Int = 20, offset: Int = 0) -> Future<BaseModel<[ResultModel]>, NSError> {
        guard
            let publicKey = AppSecrets.marvelPublicKey,
            let privateKey = AppSecrets.marvelPrivateKey
        else {
            return Future { promise in
                let error = NSError(
                    domain: "AppSecrets",
                    code: 0,
                    userInfo: [NSLocalizedDescriptionKey: "Missing MARVEL_PUBLIC_KEY or MARVEL_PRIVATE_KEY in Info.plist"]
                )
                promise(.failure(error))
            }
        }

        return requestPublisher(
            Target: .fetchCharacters(limit: limit, offset: offset, publicKey: publicKey, privateKey: privateKey),
            ClassName: BaseModel<[ResultModel]>.self
        )
    }
}
