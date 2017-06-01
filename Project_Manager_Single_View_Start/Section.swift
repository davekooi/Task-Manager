//
//  Section.swift
//  Project_Manager_Single_View_Start
//
//  Created by David Kooistra on 5/31/17.
//  Copyright © 2017 David. All rights reserved.
//

import Foundation

struct Section {
    var projectCatagory: String!
    var subTasks: [String]!
    var expanded: Bool!
    
    init(projectCatagory: String, subTasks: [String], expanded:Bool){
        self.projectCatagory = projectCatagory
        self.subTasks = subTasks
        self.expanded = expanded
    }
    
    
    
}
