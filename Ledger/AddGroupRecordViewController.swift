//
//  AddGroupRecordViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/15.
//

import UIKit
import FirebaseFirestore

class AddGroupRecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var currentLedger: Ledger?
    var totalMemeberList: [User]?
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var numberLabel: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 60
        currentLedger = CurrentLedger!
        totalMemeberList = currentLedger!.userList!.allObjects as? [User]
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.totalMemeberList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: AddGroupRecordTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AddGroupRecordCell", for: indexPath) as? AddGroupRecordTableViewCell
        if cell == nil {
            cell = AddGroupRecordTableViewCell(style: .subtitle, reuseIdentifier: "AddGroupRecordCell")
        }

        cell?.imageView?.image =  UIImage(named: "customer.png")
//        cell?.numberLabel!.text = self.numberLabel.text
        cell?.nameLabel!.text = self.totalMemeberList![indexPath.row].name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 0.001
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createBtnPressed(_ sender: UIButton) {
        if self.nameLabel.text! == "" || self.numberLabel.text! == "" {
            let alert = UIAlertController(title: "Sorry", message: "Inputs can not be empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion:nil)
            return
        }
        else if Double(self.numberLabel.text!) == nil {
            let alert = UIAlertController(title: "Sorry", message: "Amount must be a number!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion:nil)
            return
        }
        
        db.collection("Ledger").document(CurrentLedger!.id!).getDocument { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                let currentLedger = self.db.collection("Ledger").document(CurrentLedger!.id!)
                let newDocument = self.db.collection("Record").document()
                currentLedger.updateData(["recordData" : FieldValue.arrayUnion([newDocument.documentID])])

                //userlist
                var index = 0
                var attendUserList: [String] = []
                for member in self.totalMemeberList! {
                    let cell: AddGroupRecordTableViewCell? = self.tableView.visibleCells[index] as? AddGroupRecordTableViewCell
                    if cell!.selectSwitch!.isOn {
                        attendUserList.append(member.id!)
                    }
                    index += 1
                }
                

                newDocument.setData(["name": self.nameLabel.text!, "cost": Double(self.numberLabel.text!)!, "earn": 0, "ledger": CurrentLedger!.id!, "userList": attendUserList, "id": newDocument.documentID]) { (error) in
                    if let err = err {
                        print("Error getting document: \(err)")
                    }
                    else {
                        let alert = UIAlertController(title: "Congratulations", message: "Record created successfully!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion:nil)
                    }
                }
            }
        }
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
