//
//  ToDoDetailViewController.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import UIKit

class ToDoDetailViewController: UIViewController  {
    @IBOutlet weak var toDoNameField: UITextField!
    @IBOutlet weak var toDoDatePicker: UIDatePicker!
    @IBOutlet weak var toDoCategoryControl: UISegmentedControl!
    @IBOutlet weak var toDoCompleteSwitch: UISwitch!
    @IBOutlet weak var toDoModifiedLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var gestureRecognizer: UITapGestureRecognizer!
    
    
    var todo = ToDo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toDoNameField.text = todo.title
        toDoModifiedLabel.text = todo.dateString
        categoryLabel.text = todo.category
        completedLabel.text = todo.completed
        selectedDate.text = todo.dueDate
        
        if let image = todo.image {
            imageView.image = image
            addGestureRecognizer()
        } else {
            imageView.isHidden = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addGestureRecognizer() {
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(viewImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    func viewImage() {
        if let image = imageView.image {
            ToDoStore.shared.selectedImage = image
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageNavController")
            present(viewController, animated: true, completion: nil)
        }
    }
    
    fileprivate func showPicker(_ type: UIImagePickerControllerSourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
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
        todo.image = imageView.image
        ToDoStore.shared.save()
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
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let strDate = dateFormatter.string(from: toDoDatePicker.date)
        selectedDate.text = strDate
        
    }
    
    @IBAction func choosePhoto(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Picture", message: "Choose a picture type", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.showPicker(.camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.showPicker(.photoLibrary)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    
}

extension ToDoDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            let maxSize: CGFloat = 512
            let scale = maxSize / image.size.width
            let newHeight = image.size.height * scale
            
            UIGraphicsBeginImageContext(CGSize(width: maxSize, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: maxSize, height: newHeight))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            imageView.image = resizedImage
            
            imageView.isHidden = false
            if gestureRecognizer != nil {
                imageView.removeGestureRecognizer(gestureRecognizer)
            }
            addGestureRecognizer()
            
        }
    }
    
    
}
