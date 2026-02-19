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

class BaseAPI<T:TargetType> {
    
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
