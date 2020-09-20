//
//  Model.swift
//  DrawChart
//
//  Created by Maryna Bereza on 9/20/20.
//  Copyright © 2020 Maryna Bereza. All rights reserved.
//

import UIKit

struct ChartsModel {
    let modelsArray: [ChartModel]
    var indexModel: Int = 0
}


struct ChartModel {
    let columnsArray: [ColumnModel]
}


struct ColumnModel  {
    let color: UIColor
    let value: CGPoint
}

