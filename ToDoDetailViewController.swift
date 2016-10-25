//
//  ToDoDetailViewController.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class ToDoDetailViewController: UIViewController {
    @IBOutlet weak var toDoNameField: UITextField!
    @IBOutlet weak var toDoDatePicker: UIDatePicker!
    @IBOutlet weak var toDoCategoryControl: UISegmentedControl!
    @IBOutlet weak var toDoCompleteSwitch: UISwitch!
    @IBOutlet weak var toDoModifiedLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    
    
    var todo = ToDo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoNameField.text = todo.title
        toDoModifiedLabel.text = todo.dateString
        categoryLabel.text = todo.category
        completedLabel.text = todo.completed
        selectedDate.text = todo.dueDate
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        todo.title = toDoNameField.text!
        todo.date = Date()
        toDoModifiedLabel.text = todo.dateString
        todo.category = categoryLabel.text!
        todo.completed = completedLabel.text!
        todo.dueDate = selectedDate.text!
    }

    // MARK: - IBActions
    
    @IBAction func categoryChanged(_ sender: UISegmentedControl) {
        switch toDoCategoryControl.selectedSegmentIndex
        {
        case 0:
            categoryLabel.text = "Work";
        case 1:
            categoryLabel.text = "Home";
        case 2:
            categoryLabel.text = "Other";
        default:
            break; 
        }
    }
    
    @IBAction func completedClicked(sender: UISwitch) {
        if toDoCompleteSwitch.isOn {
            completedLabel.text = "No"
            toDoCompleteSwitch.setOn(false, animated:true)
        } else {
            completedLabel.text = "Yes"
            toDoCompleteSwitch.setOn(true, animated:true)
        }
    }
    
    @IBAction func datePickerAction(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let strDate = dateFormatter.string(from: toDoDatePicker.date)
        self.selectedDate.text = strDate
        
    }
    
    
}
