//
//  CGRect+Utils.swift
//  Contractor Companion
//
//  Created by CampusUser on 3/12/19.
//  Copyright © 2019 Yarrcad. All rights reserved.
//

import UIKit

extension CGRect {
    var minEdge: CGFloat {
        return min(width, height)
    }
}
