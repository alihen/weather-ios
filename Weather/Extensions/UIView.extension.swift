//
//  UIView.extension.swift
//  Weather
//
//  Created by Alastair Hendricks on 2020/05/16.
//  Copyright © 2020 Alastair Hendricks. All rights reserved.
//

import UIKit

extension UIView {

    convenience init(autolayout: Bool) {
        self.init(frame:CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = !autolayout
    }
}
