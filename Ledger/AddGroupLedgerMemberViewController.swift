//
//  AddGroupLedgerMemberViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/15.
//

import UIKit
import FirebaseFirestore

class AddGroupLedgerMemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var totalUserList: [User] = []
    @IBOutlet weak var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = 60
        
        //userList
        db.collection("User").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    let newUser = User(context: self.context)
                    newUser.id = (document.get("id") as! String)
                    newUser.name = (document.get("name") as! String)
                    
                    self.totalUserList.append(newUser)
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.totalUserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: AddGroupRecordTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "AddGroupRecordCell", for: indexPath) as? AddGroupRecordTableViewCell
        if cell == nil {
            cell = AddGroupRecordTableViewCell(style: .default, reuseIdentifier: "AddGroupRecordCell")
        }

        cell?.imageView?.image =  UIImage(named: "customer.png")
        cell?.nameLabel!.text = self.totalUserList[indexPath.row].name
        if self.isExistInLedger(user: self.totalUserList[indexPath.row]) {
            cell?.selectSwitch?.isOn = false
            cell?.selectSwitch?.isHidden = true
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 0.001
    }
    
    func isExistInLedger(user: User) -> Bool {
        let memberList = CurrentLedger!.userList!.allObjects as! [User]
        for member in memberList {
            if user.id == member.id {
                return true
            }
        }
        return false
    }
    
    @IBAction func addBtnPressed(_ sender: UIButton) {
        var index = 0
        for user in self.totalUserList {
            let cell: AddGroupRecordTableViewCell? = self.tableView.visibleCells[index] as? AddGroupRecordTableViewCell
            if cell!.selectSwitch!.isOn {
                CurrentLedger!.addToUserList(user)
//                self.tableView.cellForRow(at: )
                
                //
                db.collection("User").document(user.id!).updateData(["groupLedgerList": FieldValue.arrayUnion([CurrentLedger!.id!])])
                //
                db.collection("Ledger").document(CurrentLedger!.id!).updateData(["userList": FieldValue.arrayUnion([user.id!])]) { (err) in
                    if let err = err {
                        print("Error getting document: \(err)")
                    }
                    else {
                        let alert = UIAlertController(title: "Congratulations", message: "Ledger memeber added successfully!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action) in
                            print(self)
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion:nil)
                    }
                }
                
            }
            index += 1
        }
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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
