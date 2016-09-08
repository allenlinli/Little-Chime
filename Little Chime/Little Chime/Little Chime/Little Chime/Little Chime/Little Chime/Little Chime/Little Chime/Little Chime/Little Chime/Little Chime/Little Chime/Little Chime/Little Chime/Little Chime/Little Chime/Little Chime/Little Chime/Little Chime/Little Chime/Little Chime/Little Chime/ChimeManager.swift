//
//  ChimeManager.swift
//  Little Chime
//
//  Created by allenlinli on 8/27/16.
//  Copyright © 2016 Raccoonism. All rights reserved.
//

import Foundation

class ChimeManager
{
    var startTime: Float = 8
    var endTime: Float = 22
    var on = true
    //sound
    var frequency: Constants.ChimeFrequency = Constants.ChimeFrequency.hour
    var volumn = 0.5
}
