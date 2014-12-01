//
//  DishModel.swift
//  hsmw
//
//  Created by Patrick Reichelt on 27/11/14.
//  Copyright (c) 2014 Patrick Reichelt. All rights reserved.
//

import Cocoa

class DishModel: NSObject {
    var day : NSDate = NSDate()
    var menus : [MenuModel]
    
    override init() {
        menus = [MenuModel]()
        super.init()
    }
    
    convenience init(menu : MenuModel )
    {
        self.init()
        menus.append(menu)
    }
}
