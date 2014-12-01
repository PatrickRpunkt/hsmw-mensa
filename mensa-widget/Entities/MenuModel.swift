//
//  DishModel.swift
//  hsmw
//
//  Created by Patrick Reichelt on 27/11/14.
//  Copyright (c) 2014 Patrick Reichelt. All rights reserved.
//
import Cocoa


class MenuModel: NSObject {
 
    //Campusteller
    var type : String = ""
    //Gericht
    var name : String = ""
    var available : Bool = false
    var alcohol : Bool = false
    var pork : Bool = false
    var vital : Bool = false
    var category : Int = 0
    
    convenience init(Name : String )
    {
        self.init()
        
        self.name = Name;
    }
}
