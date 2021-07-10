//
//  PersonLedgerTableViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/14.
//

import UIKit
import FirebaseFirestore

class PersonLedgerTableViewController: UITableViewController {
    
    var personLedger: [Ledger] = []
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
    
    
    
    @IBAction func exitToPersonLedger(sender: UIStoryboardSegue) {
  
    }
    
    func fetchPersonLedger() {
        self.personLedger = []
        db.collection("User").document(CurrentUser!.id!).getDocument { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                let ledgerList: [String] = document!.get("personLedgerList") as! [String]
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
                            self.personLedger.append(newLedger)
                            
                            //
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchPersonLedger()
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return}
        if id == "ledgerDetailsSegue" {
            let sel = self.tableView.indexPathForSelectedRow?.row
            CurrentLedger = self.personLedger[sel!]
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.personLedger.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonLedgerCell", for: indexPath)
        cell.textLabel?.text = self.personLedger[indexPath.row].name
//        cell.imageView?.image = UIImage(named: "item.jpg")!
        return cell
    }

    override  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        db.collection("User").document(CurrentUser!.id!).updateData(["personLedgerList": FieldValue.arrayRemove([self.personLedger[indexPath.row].id!])]) { (err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                self.db.collection("Ledger").document(self.personLedger[indexPath.row].id!).delete() { (err) in
                    if let err = err {
                        print("Error getting document: \(err)")
                    }
                    else {
                        self.fetchPersonLedger()
                        self.tableView.reloadData()
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
