//
//  APIClient.swift
//  Country-collectionView
//
//  Created by Melinda Diaz on 1/14/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation

struct APIClient {
    //this method takes data from the API and decodes it into a format that swift can understand, which is our model(in this case Element)
    static func getCountries(for urlString: String,
                            completion: @escaping (Result<[Country], AppError>) -> ()) { //it takes in a valid url and a completion handler
        // the completion handler captures the value of the decoded data from API(like the phone call)
        guard let url = URL(string: urlString) else { completion(.failure(.badURL(urlString)))
            return
            
        }
        let urlRequest = URLRequest(url: url)
        
        
        NetworkHelper.shared.performDataTask(request: urlRequest) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                do {//any function that uses an error you must try//anytime you decode data from JSON you need to include .self
                    let searchResults = try JSONDecoder().decode([Country].self, from: data)
                    completion(.success(searchResults))
                    // 2. capture the array of results in the completion handler
                    //completion(.success(searchResults.results))
                    
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
}
    
