//
//  NetworkHelper.swift
//  Country-collectionView
//
//  Created by Melinda Diaz on 1/14/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation

// we need to make our NetworkHelper a singleton, this means there will only be one instance of this class throughout the application, at no point will someone be able to create a new instance eg. NetworkHelper()

class NetworkHelper {
    
    // we will create a shared instance of the NetworkHelper this is the one and only place for the instance
    static let shared = NetworkHelper()
    
    //no one outside has this access to session
    private var session: URLSession
    
    //we will make the default initializer private it is required in order to be considered a singleton. it also forbids anyone from creating an instance of NetworkHelper()
    private init() { //always know that session is asychronis??
        session = URLSession(configuration: .default)
    }
    //a escaping doesn't complete until the result of the closures come back from the network(complete)
    
    func performDataTask(request:URLRequest, completion: @escaping (Result<Data,AppError>) ->()) {
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkClientError(error)))
            }
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.noResponse))
                return
            }
            switch response.statusCode {
            case 200...299: break
            default:
                completion(.failure(.badStatusCode(response.statusCode)))
                
            }
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
}
