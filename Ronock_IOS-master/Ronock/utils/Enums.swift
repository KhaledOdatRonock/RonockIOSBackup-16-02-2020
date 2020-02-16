//
//  Enums.swift
//  Ronock
//
//  Created by Khaled Odat on 11/24/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import Foundation
class Enums{
    enum RequestResponse:Int{
        case SUCCESS = 0, FAILED = -1, UNAUTHORIZED = 4, FORCE_UPDATE=5
    }
    enum HomePageAdType:Int{
        case HOT_DEAL = 0, FLYER = 1, VIDEO = 2, OFFER = 3
    }
    enum MapLocationsType:Int{
        case SINGLE_AD = 1, MULTI_AD = 2
    }
}
