//
//  Person.swift
//  HWS_project10
//
//  Created by Jamaal Sedayao on 5/31/16.
//  Copyright © 2016 Jamaal Sedayao. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String

    init(name:String, image:String){
        self.name = name
        self.image = image  
    }
}
