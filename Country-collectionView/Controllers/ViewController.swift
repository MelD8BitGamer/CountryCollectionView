//
//  ViewController.swift
//  Country-collectionView
//
//  Created by Melinda Diaz on 1/14/20.
//  Copyright © 2020 Melinda Diaz. All rights reserved.
//

import UIKit
//TODO: Fix segue and passing data, Fix collection view layout
class ViewController: UIViewController {
    
    @IBOutlet weak var countrySearch: UISearchBar!
    @IBOutlet weak var countryCollection: UICollectionView!
    
    var countryRef = [Country]() {
        didSet {
            DispatchQueue.main.async {
                self.countryCollection.reloadData()
            }
        }
    }
    
  var userQuery = "" {
           didSet{
               APIClient.getCountries(for: "https://restcountries.eu/rest/v2/name/\(userQuery)") { [weak self] (result) in
                   switch result {
                   case .failure(let appError):
                       DispatchQueue.main.async {
                           self?.showAlert(title: "Data Failure", message: "Unable to retrieve Countries \(appError)")
                       }
                   case .success(let data):
                       self?.countryRef = data.filter{$0.name.lowercased().contains(self!.userQuery.lowercased()) }
                   }
               }
           }
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countryCollection.dataSource = self
        countryCollection.delegate = self
        countryCollection.backgroundColor = .systemTeal
        countrySearch.delegate = self
        setUpCountries()
        
    }
    //so this is different
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let cell = sender as? CountryCollectionViewCell,
        //the sender is considered as the cell,so you downcast to the CountryCollectionViewCell. then you call on the indexPath and set it to the collectionTable.indexPath(for: cell) then proceed as normal
            let indexPath = countryCollection.indexPath(for: cell),
            let detailedVC = segue.destination as? DetailViewController else {
                fatalError("Could not segue")}
        let eachCell = countryRef[indexPath.row]
        detailedVC.countryData = eachCell
//another way to do that is use indexpathsForSelectedItems but that wouldnt work without banging it so dont use that
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
        let interItemSpacing: CGFloat = 10 //This is the space between items. if we dont type annotate it from Int to cgfloat it will expect an Int
        let maxWidth = UIScreen.main.bounds.size.width //device width
        let numberOfItems: CGFloat = 2 //items
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

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            setUpCountries()
            return
        }
        userQuery = searchText
    }
}
