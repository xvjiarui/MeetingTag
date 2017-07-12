//
//  MeetingTableViewController.swift
//  MeetingTag
//
//  Created by Jerry XU on 10/7/2017.
//  Copyright © 2017 Jerry XU. All rights reserved.
//

import UIKit
import os.log

class MeetingTableViewController: UITableViewController {

    //MARK: Properties
    
    var meetings = [Meeting]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //Load Sample Data
        if let savedMeetings = loadMeetings()
        {
            meetings += savedMeetings
        }
        else
        {
            loadSampleMeetings()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return meetings.count
    }
    
    //MARK: Private Methods
    private func loadSampleMeetings()
    {
        let meeting1 = Meeting(title: "Meeting1", photo: UIImage(named: "meal1"), tags: [Int]())
        let meeting2 = Meeting(title: "Meeting2", photo: UIImage(named: "meal2"), tags: [Int]())
        let meeting3 = Meeting(title: "Meeting3", photo: UIImage(named: "meal3"), tags: [Int]())
        meetings += [meeting1, meeting2, meeting3]
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "MeetingTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MeetingTableViewCell else{
            fatalError("The dequeued cell is not an instance of MeetingtableViewCell")
        }
        let meeting = meetings[indexPath.row]
        cell.titleLabel.text = meeting.title
        cell.photoImageView.image = meeting.photo
        

        // Configure the cell...

        return cell
    }
    
    //MARK: Action

    @IBAction func unwindToMeetingList(sender: UIStoryboardSegue)
    {
        
        if let sourceViewController = sender.source as? MeetingViewController, let meeting = sourceViewController.meeting{
            if let selectedIndexPath = tableView.indexPathForSelectedRow
            {
                meetings[selectedIndexPath.row] = meeting
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else
            {
                let newIndexPath = IndexPath(row: meetings.count, section: 0)
                meetings.append(meeting)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
        }
        saveMeetings()
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            meetings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        saveMeetings()
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        switch segue.identifier ?? "" {
        case "AddItem":
            os_log("Adding a new meeting.", log: OSLog.default, type: .debug)
        case "ShowDetail":
            os_log("Showing a exit meeting", log: OSLog.default, type:.debug)
            guard let meetingDetailViewController = segue.destination as? MeetingViewController else {
                fatalError("Unexpected destination")
            }
            guard let selectedMeetingCell = sender as? MeetingTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedMeetingCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            let selectedMeeting = meetings[indexPath.row]
            meetingDetailViewController.meeting = selectedMeeting
            
            
        default:
            fatalError("Unexpected Segue Identifier \(String(describing: segue.identifier))")
        }
    }

    private func saveMeetings()
    {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meetings, toFile: Meeting.ArchiveURL.path)
        if isSuccessfulSave
        {
            os_log("Meetings successfully saved.", log: OSLog.default, type: .default)
        }
        else
        {
            os_log("Failed to save meetings", log: OSLog.default, type: .error)
        }
    }
    
    private func loadMeetings() -> [Meeting]?
    {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Meeting.ArchiveURL.path) as? [Meeting]
    }
}
