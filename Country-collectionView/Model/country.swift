//
//  country.swift
//  Country-collectionView
//
//  Created by Melinda Diaz on 1/14/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import Foundation


struct Country: Codable {
    
    let name: String
    let alpha2Code: String
    let capital: String
    let population: Int
    var countryImage: String?
    
}
