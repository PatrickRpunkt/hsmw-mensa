//
//  ListRowViewController.swift
//  mensa-widget
//
//  Created by Patrick Reichelt on 29/11/14.
//  Copyright (c) 2014 Patrick Reichelt. All rights reserved.
//

import Cocoa

class ListRowViewController: NSViewController {

    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var categoryLabel: NSTextField!
    var menuObject = MenuModel(Name: "")
    
    
    override var nibName: String? {
        return "ListRowViewController"
        
    }

    override func loadView() {
        super.loadView()
        if let menuObj = self.representedObject as? MenuModel {
            self.menuObject = menuObj
            typeLabel.stringValue = menuObj.type
            categoryLabel.stringValue = "PK " + String(menuObj.category)
            descriptionLabel.stringValue = menuObj.name
            
            preferredContentSize = NSSize(width: self.preferredContentSize.width, height: 100)
        }

        
        // Insert code here to customize the view
    }
}
