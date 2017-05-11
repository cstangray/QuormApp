//
//  QuormRealmModels.swift
//  QuormApp
//
//  Created by Charles Gray on 5/11/17.
//  Copyright © 2017 Charles Gray. All rights reserved.
//

import Foundation
import RealmSwift


final class MemberList: RealmSwift.Object {
    dynamic var text = ""
    dynamic var id = ""
    let items = List<Member>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Member: RealmSwift.Object {
    dynamic var id = 0
    dynamic var firstName = ""
    dynamic var familyName = ""
    dynamic var fullName = ""
    dynamic var spouseName = ""
    dynamic var autoAttend = false
    dynamic var completed = false
    
    override static func primaryKey() -> String? {
        return "id"
    }

}

final class AttendanceList: RealmSwift.Object {
    dynamic var id = ""
    let items = List<Attendance>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Attendance: RealmSwift.Object {
    dynamic var memberId = ""
    dynamic var meetingDate = Date()
    dynamic var present = false
}

class TaskObject: RealmSwift.Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var resolved = false
    dynamic var projectID = 0
    dynamic var user: Member?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    lazy var something: Bool = {
        true
    }()
    
    static func map(_ model: TaskModelObject) -> TaskObject {
        let task = TaskObject()
        task.id = model.id
        task.name = model.name
        task.resolved = model.resolved
        task.projectID = model.projectID
        return task
    }
    
    static func mapTask(_ taskModel: TaskObject) -> TaskModelObject {
        let task = TaskModelObject()
        task.id = taskModel.id
        task.name = taskModel.name
        task.resolved = taskModel.resolved
        task.projectID = taskModel.projectID
        return task
    }
}

class TaskModelObject: RealmSwift.Object {
    dynamic var id = 0
    dynamic var name = ""
    dynamic var resolved = false
    dynamic var projectID = 0
    dynamic var user: Member?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    lazy var something: Bool = {
        true
    }()
}


