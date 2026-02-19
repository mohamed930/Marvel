//
//  BaseAPI.swift
//  testConnection
//
//  Created by Mohamed Ali on 19/01/2024.
//

import Foundation
import Alamofire
import Combine

struct fileUpload {
    var type: Bool
    var key: String
    var fileType: String?
    var mimeType: String?
    var file: Data
}

class BaseAPI<T:TargetType>: UserToken {
    
    private var cancellables = Set<AnyCancellable>()
    
    func requestPublisher<M: Codable>(Target: T, ClassName: M.Type) -> Future<M, NSError> {
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        let params = buildParams(task: Target.task)

        var urlRequest = URLRequest(url: URL(string: Target.baseURL.rawValue + Target.path.rawValue)!)
        urlRequest.timeoutInterval = 30
        urlRequest.method = method
        urlRequest.headers = headers

        return Future { [unowned self] promise in
            ShardCheckConnection.shared.connectionStatusObservable
                .sink { connection in
                    switch connection {
                    case .unspecified:
                        break

                    case .connected:
                        AF.request(urlRequest.url!, method: method,
                                   parameters: params.0,
                                   encoding: params.1,
                                   headers: headers)
                            .responseDecodable(of: M.self) { [weak self] response in
                                guard let self = self else { return }

                                self.handleResponse(Target: Target, ClassName: M.self, response: response)
                                    .sink { completion in
                                        switch completion {
                                        case .finished: break
                                        case .failure(let error): promise(.failure(error))
                                        }
                                    } receiveValue: { model in
                                        promise(.success(model))
                                    }
                                    .store(in: &self.cancellables)
                            }

                    case .disconnected, .error:
                        let error = NSError(domain: Target.baseURL.rawValue,
                                            code: 0,
                                            userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                        promise(.failure(error))
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func requestPublisherWithFile<M: Codable>(
        Target: T,
        file: Any, // can be fileUpload or [fileUpload]
        params: [String: Any]?,
        ClassName: M.Type
    ) -> Future<M, NSError> {
        
        let date = Date()
        let api_url = Target.baseURL.rawValue + Target.path.rawValue
        let url = URL(string: api_url)!
        
        let method = Alamofire.HTTPMethod(rawValue: Target.method.rawValue)
        let headers = Alamofire.HTTPHeaders(Target.headers ?? [:])
        
        var urlRequest = URLRequest(
            url: url,
            cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
            timeoutInterval: 30.0
        )
        urlRequest.headers = headers
        urlRequest.method = method
        urlRequest.addValue("*/*", forHTTPHeaderField: "Accept")
        urlRequest.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        return Future { [unowned self] promise in
            ShardCheckConnection.shared.connectionStatusObservable
                .sink { connection in
                    switch connection {
                    case .unspecified:
                        break
                        
                    case .connected:
                        // Execute upload
                        AF.upload(multipartFormData: { multiPart in
                            
                            // MARK: - Parameters
                            if let params = params {
                                for (key, value) in params {
                                    switch value {
                                    case let str as String:
                                        multiPart.append(Data(str.utf8), withName: key)
                                    case let int as Int:
                                        multiPart.append(Data("\(int)".utf8), withName: key)
                                    case let double as Double:
                                        multiPart.append(Data("\(double)".utf8), withName: key)
                                    case let arr as [Any]:
                                        arr.forEach { element in
                                            let name = key + "[]"
                                            if let s = element as? String {
                                                multiPart.append(Data(s.utf8), withName: name)
                                            } else if let n = element as? Int {
                                                multiPart.append(Data("\(n)".utf8), withName: name)
                                            }
                                        }
                                    case let arr as [[String: String]]:
                                        for dict in arr {
                                            if let data = try? JSONSerialization.data(withJSONObject: dict, options: []),
                                               let str = String(data: data, encoding: .utf8) {
                                                multiPart.append(Data(str.utf8), withName: key + "[]")
                                            }
                                        }
                                    default:
                                        break
                                    }
                                }
                            }
                            
                            // MARK: - Files (single or multiple)
                            let filesToUpload: [fileUpload]
                            
                            if let single = file as? fileUpload {
                                filesToUpload = [single]
                            } else if let multiple = file as? [fileUpload] {
                                filesToUpload = multiple
                            } else {
                                filesToUpload = []
                            }
                            
                            for fileItem in filesToUpload {
                                let mime = fileItem.mimeType ?? "image/jpeg"
                                let ext = fileItem.fileType ?? "jpeg"
                                let name = fileItem.key
                                let fileName = "\(date.StringDate()).\(ext)"
                                
                                multiPart.append(
                                    fileItem.file,
                                    withName: name,
                                    fileName: fileName,
                                    mimeType: mime
                                )
                            }
                            
                        }, with: urlRequest)
                        .responseDecodable(of: M.self) { [weak self] response in
                            guard let self = self else { return }
                            self.handleResponse(Target: Target, ClassName: M.self, response: response)
                                .sink(
                                    receiveCompletion: { completion in
                                        if case .failure(let error) = completion {
                                            promise(.failure(error))
                                        }
                                    },
                                    receiveValue: { model in
                                        promise(.success(model))
                                    }
                                )
                                .store(in: &self.cancellables)
                        }
                        
                    case .disconnected, .error:
                        let error = NSError(
                            domain: Target.baseURL.rawValue,
                            code: 0,
                            userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1]
                        )
                        promise(.failure(error))
                    }
                }
                .store(in: &self.cancellables)
        }
    }

    
    
    private func handleResponse<M:Codable>(Target:T,ClassName:M.Type,response: DataResponse<M, AFError>) -> Future<M,NSError> {
        return Future { promise in
            
            switch response.result {
                
            case .success(_):
                guard let theJSONData =  response.data else {
                    // ADD Custom Error
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    promise(.failure(error))
                    return
                }
                
                if let string = String(data: theJSONData, encoding: .utf8) {
                   print(string) // Prints the string representation of the data
                }
                
                guard let response = try? response.result.get() else {
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message1])
                    promise(.failure(error))
                    
                    return
                }
                
                promise(.success(response))
                
            case .failure(let e):
                if e.isSessionTaskError,
                   let urlError = e.underlyingError as? URLError,
                   urlError.code == .timedOut {
                    // Handle timeout error
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: ErrorMessage.message2])
                    promise(.failure(error))
                } else {
                    // Handle other errors
                    let error = NSError(domain: Target.baseURL.rawValue, code: 0, userInfo: [NSLocalizedDescriptionKey: e.localizedDescription])
                    promise(.failure(error))
                }
            }
        }
        
    }
    
    
    
    private func buildParams(task: Task) -> ([String:Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:] , URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters,encoding)
        }
    }
}

protocol UserToken {
    func fetchUserToken() -> String
}

extension UserToken {
    func fetchUserToken() -> String {
        
        let local = LocalStorage()
        guard let userToken: String = local.value(key: LocalStorageKeys.token) else { return "" }
        
        return userToken
    }
}
