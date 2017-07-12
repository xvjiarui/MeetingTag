//
//  ViewController.swift
//  MeetingTag
//
//  Created by Jerry XU on 10/7/2017.
//  Copyright © 2017 Jerry XU. All rights reserved.
//

import UIKit
import os.log

class MeetingViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: Properties
    @IBOutlet weak var meetingTitleTextField: UITextField!
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var endButton: UIButton!
    @IBOutlet weak var timerButtonGroup: UIStackView!
    @IBOutlet weak var tagsTable: UITableView!
    var seconds = 0;
    var timer = Timer()
    var isTimerRunning = false
    var tags = [Int]()

    var meeting: Meeting?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        meetingTitleTextField.delegate = self
        tagsTable.delegate = self
        tagsTable.dataSource = self
        if let meeting = meeting
        {
            navigationItem.title = meeting.title
            meetingTitleTextField.text = meeting.title
            photoImageView.image = meeting.photo
        }
        updateSaveButtonState()
        startButton.isHidden = false
        tagButton.isHidden = true
        endButton.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITable
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tags.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "TagTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TagTableViewCell else{
            fatalError("The dequeued cell is not an instance of MeetingtableViewCell")
        }
        let tag = tags[indexPath.row]
        
        cell.tagLabel!.text = String(tag)
        
        
        // Configure the cell...
        
        return cell
    }

    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = meetingTitleTextField.text
    }
    
    // MARK: UIImagePickerControllerDelegte
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        meeting = Meeting(title: meetingTitleTextField.text ?? "", photo: photoImageView.image)
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddMeetingMode = presentingViewController is UINavigationController
        if isPresentingInAddMeetingMode
        {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController
        {
            owningNavigationController.popViewController(animated: true)
        }
        else
        {
            fatalError("The MealViewController is not in saide a navigation controller")
        }
    }
    //MARK: Action
    
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        meetingTitleTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func start(_ sender: UIButton) {
        seconds = 0
        startButton.isHidden = true
        tagButton.isHidden = false
        endButton.isHidden = false
        runTimer()
    }
    
    @IBAction func tag(_ sender: UIButton) {
        tags.append(seconds)
        os_log("Add tag", log: OSLog.default, type: .debug)
        tagsTable.reloadData()
    }
    
    @IBAction func end(_ sender: UIButton) {
        timer.invalidate()
        startButton.isHidden = false
        tagButton.isHidden = true
        endButton.isHidden = true
    }
    
    //MARK: Private
    private func updateSaveButtonState()
    {
        // Disable the Save button if the text field is empty
        let text = meetingTitleTextField.text ?? ""
        saveButton .isEnabled = !text.isEmpty
    }

    func updateTimer()
    {
        seconds += 1
        timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    private func runTimer()
    {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(MeetingViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    private func timeString(time: TimeInterval)->String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }

}

