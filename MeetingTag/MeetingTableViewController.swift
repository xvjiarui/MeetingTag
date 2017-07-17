//
//  MeetingTableViewController.swift
//  MeetingTag
//
//  Created by Jerry XU on 10/7/2017.
//  Copyright © 2017 Jerry XU. All rights reserved.
//

import UIKit
import os.log

class MeetingTableViewController: UITableViewController, HomeModelProtocol {

    //MARK: Properties
    
    var meetings = [Meeting]()
    let homeModel = HomeModel()
    
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
        homeModel.delegate = self
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self.homeModel, action: #selector(homeModel.downloadItems), for: .valueChanged)
        self.refreshControl!.attributedTitle = NSAttributedString(string: "REFRESH")
        
    }
    
    func itemsDownloaded(items: NSArray) {
        meetings += items as! [Meeting]
        tableView.reloadData()
        self.refreshControl!.endRefreshing()
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
            uploadImage(inputImage: meeting.photo)
            uploadInfo(meeting: meeting)
            
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
    
    //MARK: Upload Imae
    
    func uploadImage(inputImage: UIImage?)
    {
        
        let myUrl = NSURL(string: "https://minutes.000webhostapp.com/uploadImage.php");
        
        let request = NSMutableURLRequest(url:myUrl! as URL);
        request.httpMethod = "POST";
        
        let param = [
            "firstName"  : "Jerry",
            "lastName"    : "XU",
            "meetingId"    : String(meetings.count)
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let image = inputImage else {
            print("No image");
            return;
        }
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        if(imageData==nil)  { return; }
        
        request.httpBody = createBodyWithParameters(parameters: param, filePathKey: "file", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        
        
        
        let task = URLSession.shared.dataTask(with: request as URLRequest) {
            data, response, error in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            // You can print out response object
            print("******* response = \(String(describing: response))")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("****** response data = \(responseString!)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                print(json ?? "None?")
                
                DispatchQueue.main.async(execute: {
                    print("Finish")
                });
                
            }catch
            {
                print(error)
            }
            
            
        }
        
        task.resume()
        
    }
    
    func uploadInfo(meeting: Meeting)
    {
        let url = URL(string: "https://minutes.000webhostapp.com/uploadInfo.php")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        var dataString = "secretWord=xvjiarui0826" // starting POST string with a secretWord

        // the POST string has entries separated by &
        dataString = dataString + "&id=\(meetings.count)"
        dataString = dataString + "&title=\(meeting.title)" // add items as name and value
        dataString = dataString + "&photoPath=meetingPreview" + String(meetings.count) + ".jpg"
        // convert the post string to utf8 format
        let dataD = dataString.data(using: .utf8) // convert to utf8 string
        
        do
        {
            // the upload task, uploadJob, is defined here
            let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD)
            {
                data, response, error in
                if error != nil {
                    // display an alert if there is an error inside the DispatchQueue.main.async
                    DispatchQueue.main.async
                    {
                        let alert = UIAlertController(title: "Upload Didn't Work?", message: "Looks like the connection to the server didn't work.  Do you have Internet access?", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                else
                {
                    if let unwrappedData = data {
                        let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) // Response from web server hosting the database
                        if returnedData == "1" // insert into database worked
                        {
                            // display an alert if no error and database insert worked (return = 1) inside the DispatchQueue.main.async
                            DispatchQueue.main.async
                            {
                                let alert = UIAlertController(title: "Upload OK?", message: "Looks like the upload and insert into the database worked.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                        else
                        {
                            // display an alert if an error and database insert didn't worked (return != 1) inside the DispatchQueue.main.async
                            DispatchQueue.main.async
                            {
                                let alert = UIAlertController(title: "Upload Didn't Work", message: "Looks like the insert into the database did not worked.", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
            uploadJob.resume()
        }
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "meetingPreview" + String(meetings.count) + ".jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        
        
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    
    
}



extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}







