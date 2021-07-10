//
//  AddPersonRecordViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/14.
//

import UIKit
import FirebaseFirestore

class AddPersonRecordViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var numberLabel: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dic:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 89/255, blue: 71/255, alpha: 1),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)];
                
        self.typeSegment.setTitleTextAttributes((dic as! [NSAttributedString.Key : Any]), for: UIControl.State.normal);
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

                var cost: Double = 0
                var earn: Double = 0
                if self.typeSegment.selectedSegmentIndex == 0 {
                    cost = Double(self.numberLabel.text!)!
                }
                else {
                    earn = Double(self.numberLabel.text!)!
                }
                
                newDocument.setData(["name": self.nameLabel.text!, "cost": cost, "earn": earn, "ledger": CurrentLedger!.id!, "userList": [CurrentUser!.id!], "id": newDocument.documentID]) { (error) in
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
