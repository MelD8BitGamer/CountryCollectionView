//
//  UIImage.swift
//  Country-collectionView
//
//  Created by Melinda Diaz on 1/14/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

extension UIImageView {
    //this function gets our image by taking our url as a string
    func getImages(image: String, completion: @escaping (Result<UIImage,AppError>) ->()) {
        
        guard let imageURL = URL(string: image) else {
            completion(.failure(.badURL(image)))
            return
        }
        
        let urlRequest = URLRequest(url: imageURL)
        
        NetworkHelper.shared.performDataTask(request: urlRequest) { (result) in
            switch result{
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                if let convertedImage = UIImage(data: data) {
                    completion(.success(convertedImage))
                }
            }
        }
    }
    
    
}

