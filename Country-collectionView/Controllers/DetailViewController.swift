//
//  DetailViewController.swift
//  Country-collectionView
//
//  Created by Melinda Diaz on 1/14/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var countryFlagImage: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var capitalOutlet: UILabel!
    @IBOutlet weak var populationOutlet: UILabel!
    
    var countryData: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        
    }
    
    func setUp() {
        guard let x = countryData else {
            showAlert(title: "No data", message: "cant set up detail")
            return
        }
        let imageURL = "https://www.countryflags.io/\(x.alpha2Code)/flat/64.png"
        
        countryNameLabel.text = x.name
        capitalOutlet.text = "Capital: \(x.capital)"
        populationOutlet.text = "Population: \(x.population.description)"
        countryFlagImage.getImages(image: imageURL) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Image Error", message: "No image available \(appError)")
                    self?.countryFlagImage.image = UIImage(named: "uhoh")
                }
            case .success(let imageURL):
                DispatchQueue.main.async {
                    self?.countryFlagImage.image = imageURL
                }
            }
        }
        
    }
    
    
}
