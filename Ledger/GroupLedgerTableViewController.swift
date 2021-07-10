//
//  GroupLedgerTableViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/13.
//

import UIKit
import FirebaseFirestore

class GroupLedgerTableViewController: UITableViewController {

    var groupLedger: [Ledger] = []
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        self.tableView.rowHeight = 60
    }
    
    @IBAction func exitToGroupLedger(sender: UIStoryboardSegue) {
  
    }
    
    func fetchGroupLedger() {
        self.groupLedger = []
        db.collection("User").document(CurrentUser!.id!).getDocument { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                let ledgerList: [String] = document!.get("groupLedgerList") as! [String]
                for ledger in ledgerList {
                    print(ledgerList.count)
                    self.db.collection("Ledger").document(ledger).getDocument { (ledgerDoc, err) in
                        if let err = err {
                            print("Error getting document: \(err)")
                        }
                        else {
                            let newLedger = Ledger(context: self.context)
                            newLedger.id = (ledgerDoc!.get("id") as! String)
                            newLedger.name = (ledgerDoc!.get("name") as! String)
                            newLedger.type = (ledgerDoc!.get("type") as! String)
                            newLedger.addToUserList(CurrentUser!)
                            self.groupLedger.append(newLedger)
                            
                            //
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchGroupLedger()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return}
        if id == "ledgerDetailsSegue" {
            let sel = self.tableView.indexPathForSelectedRow?.row
            CurrentLedger = self.groupLedger[sel!]
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groupLedger.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupLedgerCell", for: indexPath)
        cell.textLabel?.text = self.groupLedger[indexPath.row].name
//        cell.imageView?.image = UIImage(named: "item.jpg")!
        return cell
    }
    
    override  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        db.collection("User").document(CurrentUser!.id!).updateData(["groupLedgerList": FieldValue.arrayRemove([self.groupLedger[indexPath.row].id!])]) { (err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                self.db.collection("Ledger").document(self.groupLedger[indexPath.row].id!).getDocument() { (document, err) in
                    if let err = err {
                        print("Error getting document: \(err)")
                    }
                    else {
                        let userList = document!.get("userList") as! [String]
                        let recordList = document!.get("recordData") as! [String]
                        for userID in userList {
                            if userID != CurrentUser!.id! {
                                self.db.collection("User").document(userID).updateData(["groupLedgerList": FieldValue.arrayRemove([document!.get("id") as! String])])
                            }
                        }
                        
                        //
                        for recordID in recordList {
                            self.db.collection("Record").document(recordID).delete()
                        }
                        
                        //
                        self.db.collection("Ledger").document(self.groupLedger[indexPath.row].id!).delete() { (err) in
                            if let err = err {
                                print("Error getting document: \(err)")
                            }
                            else {
                                self.fetchGroupLedger()
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 0.001
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
