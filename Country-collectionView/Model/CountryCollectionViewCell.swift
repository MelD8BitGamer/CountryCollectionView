//
//  CountryCollectionViewCell.swift
//  Country-collectionView
//
//  Created by Melinda Diaz on 1/14/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class CountryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countryImage: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryCap: UILabel!
    @IBOutlet weak var countryPopulation: UILabel!
    
    func setUpCell(eachCell: Country) {
        countryName.text = eachCell.name
        countryCap.text = "Cap: \(eachCell.capital)"
        countryPopulation.text = "Pop: \(eachCell.population)"
        countryImage.getImages(image: "https://www.countryflags.io/\(eachCell.alpha2Code)/flat/64.png") { [weak self] (result) in
            switch result{
            case .failure(let appError):
                fatalError("Could not get image \(appError)")
            case.success(let myImages):
                DispatchQueue.main.async {
                    self?.countryImage.image = myImages
                }
            }
        }
    }
}

