//
//  HSMWServiceClient.swift
//  hsmw-mensa
//
//  Created by Patrick Reichelt on 29/11/14.
//  Copyright (c) 2014 Patrick Reichelt. All rights reserved.
//

import Cocoa
import Alamofire

protocol HSMWServiceDelegate{
    func fetchWeekDataCompleted(week : [DishModel])
}

class HSMWServiceClient: NSObject, NSXMLParserDelegate {

    var delegate : HSMWServiceDelegate?
    var week : [DishModel]
    var currentDay : DishModel
    var inMenu = false
    var inDay = false
    var currentMenu : MenuModel?
    var currentElement : String = ""
    
    override init() {
        currentDay = DishModel()
        week = [DishModel]()
        currentMenu = MenuModel(Name: "")
    }
    
    func executeRequest()
    {
        Alamofire.request(.GET, "https://app.hs-mittweida.de/speiseplan", parameters: nil)
            .response { (request, response, data, error) in
                
                let parser = NSXMLParser(data: data as NSData)
                parser.delegate = self
                parser.parse()
        }
    }
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
     
        if(elementName == "menu")
        {
            inMenu = true;
            currentMenu = MenuModel(Name: "")
        }
        
        if(elementName == "day")
        {
            inDay = true;
            currentDay = DishModel()
        }
        
        currentElement = elementName
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        
        if(elementName == "menu") {
            inMenu = false
            if let menu = currentMenu {
                currentDay.menus.append(menu)
            }
        }
        
        if(elementName == "day"){
            inDay = false
            week.append(currentDay)
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        
        self.delegate?.fetchWeekDataCompleted(self.week)
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        if(inMenu){
        
        if(currentElement == "type") {
            if let temp = currentMenu?.type
            {
                if(string.hasPrefix("\n")){
                    return
                }
                var tempString = temp
                tempString += string
                currentMenu?.type = tempString
            }
            else
            {
                currentMenu?.type = string
            }
        }
        else if(currentElement == "description") {
            if let temp = currentMenu?.name
            {
                if(string.hasPrefix("\n")){
                    return
                }
                var tempString = temp
                tempString += string
                currentMenu?.name = tempString
            }
            else
            {
                currentMenu?.name = string
            }
        }
        else if(currentElement == "pc") {
            if let temp = currentMenu?.category
            {
                if(string.hasPrefix("\n")){
                    return
                }
                if let price = string.toInt(){
                    currentMenu?.category = price
                }
            }
        }
        else if(currentElement == "available") {
            if(isBoolString(string)){
                currentMenu?.available = (string == "true") ? true : false
            }
        }
        else if(currentElement == "alcohol") {
            if(isBoolString(string)){
                currentMenu?.alcohol = (string == "true") ? true : false
            }
        }
        else if(currentElement == "pork") {
            if(isBoolString(string)){
                currentMenu?.pork = (string == "true") ? true : false
            }
        }
        else if(currentElement == "vital") {
            if(isBoolString(string)){
                currentMenu?.vital = (string == "true") ? true : false
            }
        }
            
        }
        else if(inDay)
        {
            if(currentElement == "date") {
                
                let dateFormat = NSDateFormatter()
                dateFormat.dateFormat =  "yyyy-MM-dd"
                
                if let date = dateFormat.dateFromString(string){
                    currentDay.day = date
                }
            }
        }
        else {
            return
        }
    }
    
    func isBoolString(boolString : String) -> Bool
    {
        return (boolString == "true" || boolString == "false")
    }
}


