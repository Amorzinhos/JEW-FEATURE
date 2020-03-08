//
//  Connector.swift
//  InvestScopio
//
//  Created by Joao Medeiros Pereira on 05/06/19.
//  Copyright © 2019 Joao Medeiros Pereira. All rights reserved.
//

import Foundation
import Alamofire
public typealias SuccessResponse = (Decodable) -> ()
public typealias FinishResponse = () -> ()
public typealias SuccessRefreshResponse = (_ shouldUpdateHeaders: Bool) -> ()
public typealias ErrorCompletion = (ConnectorError) -> ()


public final class JEWConnector {
    
    // Can't init is singleton
    private init() { }
    
    public static let connector = JEWConnector()
    public var baseURL: String = JEWConstants.Services.localHost.rawValue
    public static func getURL(withRoute route: String) -> URL? {
        let baseURL = URL(string: "\(JEWConnector.connector.baseURL)\(route)")
        return baseURL
    }
    
    public func request<T: Decodable>(withRoute route: String, method: HTTPMethod = .get, parameters: JSONAble? = nil, responseClass: T.Type, headers: HTTPHeaders? = nil, shouldRetry: Bool = false, successCompletion: @escaping(SuccessResponse), errorCompletion: @escaping(ErrorCompletion)) {
        
        guard let url = JEWConnector.getURL(withRoute: route) else {
            return
        }
        
        self.requestBlock(withURL: url, method: method, parameters: parameters, responseClass: responseClass, headers: headers, successCompletion: { (decodable) in
            successCompletion(decodable)
        }) { (error) in
            if shouldRetry && error.error != .none {
                self.request(withRoute: route, method: method, parameters: parameters, responseClass: responseClass, headers: headers, shouldRetry: false, successCompletion: successCompletion, errorCompletion: errorCompletion)
                return
            }
            errorCompletion(error)
        }
        
    }
    
    public func requestBlock<T: Decodable>(withURL url: URL, method: HTTPMethod = .get, parameters: JSONAble? = nil, responseClass: T.Type, headers: HTTPHeaders? = nil, successCompletion: @escaping(SuccessResponse), errorCompletion: @escaping(ErrorCompletion)) {
        Alamofire.request(url, method: method, parameters: parameters?.toDict(), encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
            let responseResult = response.result
            if responseResult.error != nil {
                do {
                    if let data = response.data {
                        var apiError = try JSONDecoder().decode(ApiError.self, from: data)
                        apiError.error = false
                        errorCompletion(ConnectorError.init(error: .none, title: JEWFloatingTextFieldType.defaultErrorTitle(), message: apiError.reason))
                    } else {
                        errorCompletion(ConnectorError(error: .none))
                    }
                    return
                }
                catch let error {
                    JEWLogger.error(error.localizedDescription)
                    errorCompletion(ConnectorError())
                    return
                }
                
            }
            switch responseResult {
            case .success:
                do {
                    if let data = response.data {
                        let decodable = try JSONDecoder().decode(T.self, from: data)
                        successCompletion(decodable)
                    } else {
                        errorCompletion(ConnectorError(error: .none))
                    }
                    break
                }
                catch {
                    errorCompletion(ConnectorError(error: .none))
                    break
                }
            case .failure:
                errorCompletion((ConnectorError(error: .none)))
                break
            }
        }
    }
}
