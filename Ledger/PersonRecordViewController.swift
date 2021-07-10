//
//  PersonRecordViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/14.
//

import UIKit
import FirebaseFirestore

class PersonRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentLedger: Ledger?
    var personRecord: [Record] = []
    @IBOutlet weak var totalCostLabel: UILabel!
    @IBOutlet weak var totalEarnLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 60
        self.currentLedger = CurrentLedger
        self.navigationItem.title = self.currentLedger!.name
    }
    
    func fetchPersonRecord() {
        self.personRecord = []
        var totalCost: Double = 0
        var totalEarn: Double = 0
        db.collection("Ledger").document(CurrentLedger!.id!).getDocument { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
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
                            newRecord.addToAttendUserList(CurrentUser!)
                            self.personRecord.append(newRecord)
                            
                            //
                            totalCost += newRecord.cost
                            totalEarn += newRecord.earn
                            self.totalCostLabel.text = String(totalCost)
                            self.totalEarnLabel.text = String(totalEarn)
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchPersonRecord()
        self.tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return}
        if id == "detailsSegue" {
            let sel = tableView.indexPathForSelectedRow?.row
            CurrentRecord = self.personRecord[sel!]
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.personRecord.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: PersonRecordTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "PersonRecordCell", for: indexPath) as? PersonRecordTableViewCell
        if cell == nil {
            cell = PersonRecordTableViewCell(style: .default, reuseIdentifier: "PersonRecordCell")
        }

        if self.personRecord[indexPath.row].cost != 0 {
            cell?.imageView?.image = UIImage(named: "cost.png")!.reSizeImage(reSize: CGSize.init(width: 100, height: 100))
            cell?.numberLabel!.text = String(self.personRecord[indexPath.row].cost)
        }
        else {
            cell?.imageView?.image = UIImage(named: "earn.png")!.reSizeImage(reSize: CGSize.init(width: 100, height: 100))
            cell?.numberLabel!.text = String(self.personRecord[indexPath.row].earn)
        }
        cell?.nameLabel!.text = self.personRecord[indexPath.row].name
        
        return cell!
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.context.delete(self.personRecord[indexPath.row])
        do {
            try self.context.save()
        } catch  {
        }
        
        self.fetchPersonRecord()
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
