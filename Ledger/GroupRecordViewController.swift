//
//  GroupRecordViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/15.
//

import UIKit
import FirebaseFirestore

class GroupRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentLedger: Ledger?
    var groupRecord: [Record] = []
    var youCost: Double = 0
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var youCostLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 60
        self.currentLedger = CurrentLedger
        self.navigationItem.title = self.currentLedger!.name
    }
    
    func fetchGroupRecord() {
        self.groupRecord = []
        CurrentLedger!.userList = []
        self.youCost = 0
        var totalCost: Double = 0
        db.collection("Ledger").document(CurrentLedger!.id!).getDocument { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                let userList: [String] = document!.get("userList") as! [String]
                for user in userList {
                    self.db.collection("User").document(user).getDocument { (userDoc, err) in
                        if let err = err {
                            print("Error getting document: \(err)")
                        }
                        else {
                            let newUser = User(context: self.context)
                            newUser.id = (userDoc!.get("id") as! String)
                            newUser.name = (userDoc!.get("name") as! String)
                            
                            CurrentLedger!.addToUserList(newUser)
                            self.tableView.reloadData()
                        }
                    }
                }

                //
                let recordList: [String] = document!.get("recordData") as! [String]
                for record in recordList {
                    self.db.collection("Record").document(record).getDocument { (recordDoc, err) in
                        if let err = err {
                            print("Error getting document: \(err)")
                        }
                        else {
                            let newRecord = Record(context: self.context)
                            newRecord.id = (recordDoc!.get("id") as! String)
                            newRecord.name = (recordDoc!.get("name") as! String)
                            newRecord.cost = recordDoc!.get("cost") as! Double
                            newRecord.earn = recordDoc!.get("earn") as! Double
                            let attendUserList: [String] = recordDoc!.get("userList") as! [String]
                            self.groupRecord.append(newRecord)
                            
                            //
                            for userID in attendUserList {
                                self.db.collection("User").document(userID).getDocument { (userDoc, err) in
                                    if let err = err {
                                        print("Error getting document: \(err)")
                                    }
                                    else {
                                        let newUser = User(context: self.context)
                                        newUser.id = (userDoc!.get("id") as! String)
                                        newUser.name = (userDoc!.get("name") as! String)
                                        
                                        newRecord.addToAttendUserList(newUser)
                                        print("add user!!!!!!!!!!!!!")
                                        self.tableView.reloadData()
                                    }
                                }
                                
                                if userID == CurrentUser!.id! {
                                    self.youCost += newRecord.cost/Double(attendUserList.count)
                                }
                            }
                            totalCost += newRecord.cost
                            self.totalCostLabel.text = String(totalCost)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchGroupRecord()
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return}
        if id == "detailsSegue" {
            let sel = tableView.indexPathForSelectedRow?.row
            CurrentRecord = self.groupRecord[sel!]
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.groupRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: GroupRecordTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "GroupRecordCell", for: indexPath) as? GroupRecordTableViewCell
        if cell == nil {
            cell = GroupRecordTableViewCell(style: .default, reuseIdentifier: "GroupRecordCell")
        }

        if self.groupRecord[indexPath.row].cost != 0 {
            cell?.imageView?.image = UIImage(named: "cost.png")!.reSizeImage(reSize: CGSize.init(width: 100, height: 100))
            cell?.numberLabel!.text = String(self.groupRecord[indexPath.row].cost)
        }
        else {
            cell?.imageView?.image = UIImage(named: "earn.png")!.reSizeImage(reSize: CGSize.init(width: 100, height: 100))
            cell?.numberLabel!.text = String(self.groupRecord[indexPath.row].earn)
        }
        cell?.nameLabel!.text = self.groupRecord[indexPath.row].name
        self.youCostLabel.text = String(self.youCost.roundTo(places: 2))
        
        return cell!
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.context.delete(self.groupRecord[indexPath.row])
        do {
            try self.context.save()
        } catch  {
        }
        
        self.fetchGroupRecord()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 0.001
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
