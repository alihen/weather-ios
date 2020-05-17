//
//  HomeViewController.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let presenter = HomePresenter()

    let mainTempImageView: UIImageView = {
        let imgvw = UIImageView(autolayout: true)
        imgvw.image = UIImage(named: "coastal-sunny")
        imgvw.contentMode = .scaleAspectFit
        return imgvw
    }()

    let mainTempLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.font = UIFont.systemFont(ofSize: 80, weight: .regular)
        lbl.text = "15°"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        return lbl
    }()

    let mainTempSubtitleLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        lbl.text = "Sunny".uppercased()
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
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
    }

    func setupAppearance() {
        view.addSubview(mainTempImageView)
        mainTempImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: -23).isActive =  true
        mainTempImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mainTempImageView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mainTempImageView.widthAnchor.constraint(equalTo: mainTempImageView.heightAnchor, multiplier: 1.0).isActive = true

        view.addSubview(mainTempLabel)
        mainTempLabel.centerXAnchor.constraint(equalTo: mainTempImageView.centerXAnchor).isActive = true
        mainTempLabel.centerYAnchor.constraint(equalTo: mainTempImageView.centerYAnchor).isActive = true


        view.addSubview(mainTempSubtitleLabel)
        mainTempSubtitleLabel.topAnchor.constraint(equalTo: mainTempLabel.bottomAnchor).isActive = true
        mainTempSubtitleLabel.centerXAnchor.constraint(equalTo: mainTempImageView.centerXAnchor).isActive = true


        view.addSubview(detailCollectionView)
        detailCollectionView.topAnchor.constraint(equalTo: mainTempImageView.bottomAnchor, constant: -30).isActive = true
        detailCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        detailCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        detailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
