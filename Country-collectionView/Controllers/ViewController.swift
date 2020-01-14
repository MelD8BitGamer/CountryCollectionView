//
//  ViewController.swift
//  Country-collectionView
//
//  Created by Melinda Diaz on 1/14/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var countrySearch: UISearchBar!
    @IBOutlet weak var collectionTable: UICollectionView!
    
    var countryRef = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionTable.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionTable.dataSource = self
        collectionTable.delegate = self
        setUpCountries()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = collectionTable.indexPathsForSelectedItems,
            let detailedVC = segue.destination as? DetailViewController else {
                fatalError("Could not segue")}
//        let eachCell = countryRef[indexPath.row]
//        detailedVC.countryData = eachCell
        
    }
    
    func setUpCountries() {
        APIClient.getCountries(for: "https://restcountries.eu/rest/v2/name/united") { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Cannot load countries \(appError)")
                }
            case .success(let data):
                self?.countryRef = data
            }
        }
    }
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countryRef.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as? CountryCollectionViewCell else {
            fatalError("Could not downcast Cell")
        }
        let countries = countryRef[indexPath.row]
        cell.setUpCell(eachCell: countries)
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 5 //This is the space between items. if we dont type annotate it from Int to cgfloat it will expect an Int
        let maxWidth = UIScreen.main.bounds.size.width //device width
        let numberOfItems: CGFloat = 3 //items
        let totalSpacing: CGFloat = numberOfItems * interItemSpacing
        let itemWidth: CGFloat = (maxWidth - totalSpacing) / numberOfItems
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
