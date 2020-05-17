//
//  SummaryCollectionViewCell.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

class SummaryCollectionViewCell: UICollectionViewCell {

    static let reuseId = "SummaryCollectionViewCell"

    let tempLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.text = "15°"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        return lbl
    }()

    let descriptionLabel: UILabel = {
        let lbl = UILabel(autolayout: true)
        lbl.text = "min"
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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
        descriptionLabel.text = nil
        tempLabel.text = nil
    }

    func styleCell(item: Int) {
        var alignment: NSTextAlignment = .left
        var labelTitle = "min"
        switch item {
        case 0:
            alignment = .left
            labelTitle = "min"
        case 1:
            alignment = .center
            labelTitle = "Current"
        case 2:
            alignment = .right
            labelTitle = "max"
        default:
            break
        }

        tempLabel.textAlignment = alignment
        descriptionLabel.textAlignment = alignment
        descriptionLabel.text = labelTitle

    }

    private func setupAppearance() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true

        contentView.addSubview(tempLabel)
        tempLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor).isActive = true
        tempLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        tempLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        tempLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
    }
}
