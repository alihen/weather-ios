//
//  HomeViewController.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit
import GooglePlaces

class HomeViewController: UIViewController {

    var presenter: HomePresenterProtocol = HomePresenter()
    var weatherContext = WeatherContext.sunny
    var titleConstraint: NSLayoutConstraint?
    var location: String? = nil

    let mainTempImageView: UIImageView = {
        let imgvw = UIImageView(autolayout: true)
        imgvw.image = UIImage(named: "coastal-sunny")
        imgvw.contentMode = .scaleAspectFit
        return imgvw
    }()

    let mainTempLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.font = UIFont.systemFont(ofSize: 70, weight: .regular)
        lbl.text = "--°"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        return lbl
    }()

    let mainTempSubtitleLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.numberOfLines = 2
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.7
        return lbl
    }()

    let detailCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.coastalBlue
        cv.alwaysBounceVertical = true
        return cv
    }()

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadWeatherInfo), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupAppearance()

        presenter.registerCells(collectionView: detailCollectionView)
        presenter.setupDelegates(collectionView: detailCollectionView)
        presenter.startLocationManager()
        presenter.viewController = self

        location = presenter.getSavedLocation()
        if location == nil {
            presenter.startUpdatingLocation()
        }
        loadWeatherInfo()
    }

    @objc func loadWeatherInfo() {
        guard let location = self.location else {
            return
        }
        self.title = location
        presenter.loadWeatherData(location: location) { [weak self] (error) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                if error == nil {
                    self?.detailCollectionView.reloadData()
                    self?.updateLabels()
                    self?.updateContext()
                    return
                }
                self?.presentError(error: error)
            }
        }
    }

    func updateLabels() {
        presenter.setTempAndDescriptionLabels(tempLabel: mainTempLabel, descriptionLabel: mainTempSubtitleLabel)
    }

    func updateContext() {
        weatherContext = presenter.getContextForCurrentConditions()
        self.mainTempLabel.sizeToFit()
        UIView.animate(withDuration: 0.5) {
            self.detailCollectionView.backgroundColor = self.weatherContext.color
            self.titleConstraint?.constant = self.weatherContext.titleYOffset
            self.view.layoutSubviews()
        }

        let newImage = UIImage(named: weatherContext.imageName)
        UIView.transition(with: mainTempImageView,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                            self.mainTempImageView.image = newImage
        })
    }

    func presentError(error: Error?, handler: @escaping () -> Void = {}) {
        var errorMessage = error?.localizedDescription ?? "An unknown error occurred" 
        if let apiResponseError = error as? APIResponseError {
            errorMessage = apiResponseError.localizedDescription
        }

        if let locationError = error as? LocationError {
            errorMessage = locationError.localizedDescription
        }

        let alertController = UIAlertController(title: "Something went wrong", message: errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction) in
            handler()
        }
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func setupNavigationBar() {
        let leftButton = UIBarButtonItem(image: UIImage(systemName: "location.fill"), style: .plain, target: self, action: #selector(leftButtonAction))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton

        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(rightButtonAction))
        rightButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightButton
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    @objc func rightButtonAction() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self

        let filter = GMSAutocompleteFilter()
        filter.type = .city
        autocompleteController.autocompleteFilter = filter
        self.present(autocompleteController, animated: true, completion: nil)
    }

    @objc func leftButtonAction() {
        presenter.startUpdatingLocation()
    }

    func setupAppearance() {
        view.addSubview(mainTempImageView)
        mainTempImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -23).isActive =  true
        mainTempImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainTempImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainTempImageView.widthAnchor.constraint(equalTo: mainTempImageView.heightAnchor, multiplier: 1.0).isActive = true

        view.addSubview(mainTempLabel)
        mainTempLabel.centerXAnchor.constraint(equalTo: mainTempImageView.centerXAnchor).isActive = true
        titleConstraint = mainTempLabel.centerYAnchor.constraint(equalTo: mainTempImageView.centerYAnchor, constant: weatherContext.titleYOffset)
        titleConstraint?.isActive = true


        view.addSubview(mainTempSubtitleLabel)
        mainTempSubtitleLabel.topAnchor.constraint(equalTo: mainTempLabel.bottomAnchor).isActive = true
        mainTempSubtitleLabel.centerXAnchor.constraint(equalTo: mainTempImageView.centerXAnchor).isActive = true
        mainTempSubtitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 90).isActive = true
        mainTempSubtitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -90).isActive = true


        view.addSubview(detailCollectionView)
        detailCollectionView.topAnchor.constraint(equalTo: mainTempImageView.bottomAnchor, constant: -30).isActive = true
        detailCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        detailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        detailCollectionView.addSubview(refreshControl)
    }
}
