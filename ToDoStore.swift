//
//  ToDoStore.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class ToDoStore {
    static let shared = ToDoStore()
    
    var todos: [ToDo]!
    
    var selectedImage: UIImage?
    
    init() {
        let filePath = archiveFilePath()
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: filePath) {
            todos = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! [ToDo]
        } else {
            todos = []
            todos.append(ToDo(title: "ToDo 1"))
            todos.append(ToDo(title: "Todo 2"))
            todos.append(ToDo(title: "ToDo 3"))
            save()
        }
        sort()
    }
    
    
    // MARK: - Public functions
    func getToDo(_ index: Int) -> ToDo {
        return todos[index]
    }
    
    func addToDo(_ todo: ToDo) {
        todos.insert(todo, at: 0)
    }
    
    func updateToDo(_ todo: ToDo, index: Int) {
        todos[index] = todo
    }
    
    func deleteToDo(_ index: Int) {
        todos.remove(at: index)
    }
    
    func getCount() -> Int {
        return todos.count
    }
    
    func save() {
        NSKeyedArchiver.archiveRootObject(todos, toFile: archiveFilePath())
    }
    
    func sort() {
        todos.sort {
            $0.date.compare($1.date) == .orderedDescending
        }
    }
    
    
    
    // MARK: - Private Functions
    fileprivate func archiveFilePath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentsDirectory = paths.first!
        let path = (documentsDirectory as NSString).appendingPathComponent("NoteStore.plist")
        return path
    }
}
