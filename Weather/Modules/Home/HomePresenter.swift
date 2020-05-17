//
//  HomePresenter.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

class HomePresenter: NSObject {

    func registerCells(collectionView: UICollectionView) {
        collectionView.register(ForecastCollectionViewCell.self, forCellWithReuseIdentifier: ForecastCollectionViewCell.reuseId)
        collectionView.register(SummaryCollectionViewCell.self, forCellWithReuseIdentifier: SummaryCollectionViewCell.reuseId)
    }

    func setupDelegates(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

extension HomePresenter: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            return 5
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SummaryCollectionViewCell.reuseId, for: indexPath) as! SummaryCollectionViewCell
            cell.styleCell(item: indexPath.row)
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.reuseId, for: indexPath) as! ForecastCollectionViewCell
            return cell
        }
    }
}

extension HomePresenter: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: (UIScreen.main.bounds.width/3)-10, height: 48)
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 40)
        }

    }
}
