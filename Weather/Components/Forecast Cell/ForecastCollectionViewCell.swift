//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    static let reuseId = "ForecastCollectionViewCell"

    let dayLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.text = "Weekday"
        lbl.textColor = UIColor.white
        return lbl
    }()

    let weatherImageView: UIImageView = {
        let imgvw = UIImageView(autolayout: true)
        imgvw.contentMode = .scaleAspectFit
        imgvw.image = UIImage(named: "forecast-rain")
        return imgvw
    }()

    let tempLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.text = "15°"
        lbl.textAlignment = .right
        lbl.textColor = UIColor.white
        return lbl
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAppearance()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        dayLabel.text = nil
        weatherImageView.image = nil
        tempLabel.text = nil
    }

    private func setupAppearance() {
        contentView.addSubview(dayLabel)
        dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        dayLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true

        contentView.addSubview(weatherImageView)
        weatherImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        weatherImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        weatherImageView.widthAnchor.constraint(equalToConstant: 28).isActive = true
        weatherImageView.heightAnchor.constraint(equalToConstant: 28).isActive = true

        contentView.addSubview(tempLabel)
        tempLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        tempLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true

    }
    
}
