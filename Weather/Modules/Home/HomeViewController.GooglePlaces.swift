//
//  HomeViewController.GooglePlaces.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/19.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import Foundation
import GooglePlaces

extension HomeViewController: GMSAutocompleteViewControllerDelegate {

    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        guard let placeName = place.name else {
            dismiss(animated: true, completion: nil)
            return
        }
        self.location = placeName
        loadWeatherInfo()
        dismiss(animated: true, completion: nil)
    }

    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        debugPrint("Error: ", error.localizedDescription)
    }

    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
}
