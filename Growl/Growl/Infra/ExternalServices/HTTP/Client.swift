//
//  Request.swift
//  Growl
//
//  Created by 木本瑛介 on 2026/04/18.
//

import Foundation
import Alamofire

/// A client to handle HTTP requests using Alamofire.
public class HttpClient {
    /// The Alamofire session used for making requests.
    private let session: Session
    /// The timeout interval for a single request.
    private var requestTimeout: Double
    /// The timeout interval for resource loading.
    private var resourceTimeout: Double
    /// The maximum number of retry attempts for failed requests.
    private let retryLimit: UInt
    /// Singleton
    static let shared = HttpClient()
    
    /// Initializes a new HttpClient instance.
    /// - Parameters:
    ///   - requestTimeout: The timeout interval for requests.
    ///   - resourceTimeout: The timeout interval for resources.
    ///   - retryLimit: The maximum number of retry attempts.
    public init(requestTimeout: Double = 15, resourceTimeout: Double = 30, retryLimit: UInt = 3) {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = requestTimeout
        config.timeoutIntervalForResource = resourceTimeout
        
        let retryPolicy = RetryPolicy(retryLimit: retryLimit)
        
        self.session = Session(configuration: config, interceptor: retryPolicy)
        self.requestTimeout = requestTimeout
        self.resourceTimeout = resourceTimeout
        self.retryLimit = retryLimit
    }
    
    /// Private instance for singleton.
    private init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 15
        config.timeoutIntervalForResource = 30
        
        let retryPolicy = RetryPolicy(retryLimit: 3)
        
        self.session = Session(configuration: config, interceptor: retryPolicy)
        self.requestTimeout = 15
        self.resourceTimeout = 30
        self.retryLimit = 3
    }
}

extension HttpClient {
    /// Executes an HTTP request and decodes the response into a Decodable type.
    /// - Parameters:
    ///   - url: The target URL string.
    ///   - method: The HTTP method to use.
    ///   - paramaters: Optional parameters for the request.
    /// - Returns: A Result containing the decoded object or an HttpError.
    private func execute<T: Decodable>(url: String, method: HTTPMethod, paramaters: Parameters? = nil) async -> Result<T, HttpError> {
        guard let targetURL = URL(string: url) else {
            return .failure(.invalidURL(url: url))
        }
        
        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
        let task = self.session
            .request(targetURL, method: method, parameters: paramaters, encoding: encoding)
            .validate()
            .serializingDecodable(T.self)
        let response = await task.response
        
        switch response.result {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(HttpError(error: error))
        }
    }
    
    /// Executes an HTTP request without expecting a specific response body.
    /// - Parameters:
    ///   - url: The target URL string.
    ///   - method: The HTTP method to use.
    ///   - paramaters: Optional parameters for the request.
    /// - Returns: A Result indicating success or an HttpError.
    private func execute(url: String, method: HTTPMethod, paramaters: Parameters? = nil) async -> Result<(), HttpError> {
        guard let targetURL = URL(string: url) else {
            return .failure(.invalidURL(url: url))
        }
        
        let encoding: ParameterEncoding = (method == .get) ? URLEncoding.default : JSONEncoding.default
        let task = self.session
            .request(targetURL, method: method, parameters: paramaters, encoding: encoding)
            .validate()
            .serializingData()
        let response = await task.response
        
        switch response.result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(HttpError(error: error))
        }
    }
    
    /// Performs a GET request.
    /// - Parameters:
    ///   - url: The target URL string.
    ///   - paramaters: Optional query parameters.
    /// - Returns: A Result containing the decoded object or an HttpError.
    public func get<T: Decodable>(url: String, paramaters: Parameters? = nil) async -> Result<T, HttpError> {
        return await self.execute(url: url, method: .get, paramaters: paramaters)
    }
    
    /// Performs a POST request.
    /// - Parameters:
    ///   - url: The target URL string.
    ///   - paramaters: Optional request body parameters.
    /// - Returns: A Result indicating success or an HttpError.
    public func post(url: String, paramaters: Parameters? = nil) async -> Result<(), HttpError> {
        return await self.execute(url: url, method: .post, paramaters: paramaters)
    }
    
    public func post<T: Decodable>(url: String, paramaters: Parameters? = nil) async -> Result<T, HttpError> {
        return await self.execute(url: url, method: .post, paramaters: paramaters)
    }
    
    /// Performs a DELETE request.
    /// - Parameters:
    ///   - url: The target URL string.
    ///   - paramaters: Optional query or body parameters.
    /// - Returns: A Result indicating success or an HttpError.
    public func delete(url: String, paramaters: Parameters? = nil) async -> Result<(), HttpError> {
        return await self.execute(url: url, method: .delete, paramaters: paramaters)
    }
    
    /// Performs a PUT request.
    /// - Parameters:
    ///   - url: The target URL string.
    ///   - paramaters: Optional request body parameters.
    /// - Returns: A Result indicating success or an HttpError.
    public func put(url: String, paramaters: Parameters? = nil) async -> Result<(), HttpError> {
        return await self.execute(url: url, method: .put, paramaters: paramaters)
    }
    
    /// Performs a PATCH request.
    /// - Parameters:
    ///   - url: The target URL string.
    ///   - paramaters: Optional request body parameters.
    /// - Returns: A Result indicating success or an HttpError.
    public func patch(url: String, paramaters: Parameters? = nil) async -> Result<(), HttpError> {
        return await self.execute(url: url, method: .patch, paramaters: paramaters)
    }
}

