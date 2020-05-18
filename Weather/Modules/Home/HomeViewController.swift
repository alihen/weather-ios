//
//  HomeViewController.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let presenter: HomePresenterProtocol = HomePresenter()
    var weatherContext = WeatherContext.sunny
    var titleConstraint: NSLayoutConstraint?

    let mainTempImageView: UIImageView = {
        let imgvw = UIImageView(autolayout: true)
        imgvw.image = UIImage(named: "coastal-sunny")
        imgvw.contentMode = .scaleAspectFit
        return imgvw
    }()

    let mainTempLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.font = UIFont.systemFont(ofSize: 70, weight: .regular)
        lbl.text = "15°"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        return lbl
    }()

    let mainTempSubtitleLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        lbl.text = "Sunny".uppercased()
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
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()

        presenter.registerCells(collectionView: detailCollectionView)
        presenter.setupDelegates(collectionView: detailCollectionView)
        presenter.loadWeatherData(location: "") { (error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.detailCollectionView.reloadData()
                    self.updateLabels()
                    self.updateContext()
                }
            }
        }
    }

    func updateLabels() {
        presenter.setTempAndDescriptionLabels(tempLabel: mainTempLabel, descriptionLabel: mainTempSubtitleLabel)
    }

    func updateContext() {
        weatherContext = presenter.getContextForCurrentConditions()
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
    }
}

enum WeatherContext {
    case cloudy
    case rainy
    case sunny

    var imageName: String {
        switch self {
        case .cloudy:
            return "coastal-cloudy"
        case .rainy:
            return "coastal-rainy"
        case .sunny:
            return "coastal-sunny"
        }
    }

    var color: UIColor {
        switch self {
        case .cloudy:
            return UIColor.coastalLightGrey
        case .rainy:
            return UIColor.coastalDarkGrey
        case .sunny:
            return UIColor.coastalBlue
        }
    }

    var forecastIconName: String {
        switch self {
        case .cloudy:
            return "forecast-partlysunny"
        case .rainy:
            return "forecast-rain"
        case .sunny:
            return "forecast-clear"
        }
    }

    var titleYOffset: CGFloat {
        switch self {
        case .cloudy:
            return -50
        case .rainy:
            return -50
        case .sunny:
            return 0
        }
    }
}
