//
//  PersonRecordDetailsViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/15.
//

import UIKit
import FirebaseFirestore

class PersonRecordDetailsViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var numberLabel: UITextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.nameLabel.text = CurrentRecord!.name
        if CurrentRecord!.cost != 0 {
            self.numberLabel.text = String(CurrentRecord!.cost)
            self.typeSegment.selectedSegmentIndex = 0
        }
        else {
            self.numberLabel.text = String(CurrentRecord!.earn)
            self.typeSegment.selectedSegmentIndex = 1
        }
        
        let dic:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 89/255, blue: 71/255, alpha: 1),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)];
                
        self.typeSegment.setTitleTextAttributes((dic as! [NSAttributedString.Key : Any]), for: UIControl.State.normal);
        
    }
    
    @IBAction func updateBtnPressed(_ sender: UIButton) {
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
        
        
        if self.typeSegment.selectedSegmentIndex == 0 {
            self.db.collection("Record").document(CurrentRecord!.id!).updateData(["cost": Double(self.numberLabel.text!)!])
            self.db.collection("Record").document(CurrentRecord!.id!).updateData(["earn": 0])
        }
        else {
            self.db.collection("Record").document(CurrentRecord!.id!).updateData(["cost": 0])
            self.db.collection("Record").document(CurrentRecord!.id!).updateData(["earn": Double(self.numberLabel.text!)!])
        }
        
        self.db.collection("Record").document(CurrentRecord!.id!).updateData(["name": self.nameLabel.text!]) { (err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                let alert = UIAlertController(title: "Congratulations", message: "Record updated successfully!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: { (action) in
                    print(self)
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion:nil)
            }
        }
    }
    
    @IBAction func deleteBtnPressed(_ sender: UIButton) {
        db.collection("Ledger").document(CurrentLedger!.id!).updateData(["recordData": FieldValue.arrayRemove([CurrentRecord!.id!])]) { (err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                self.db.collection("Record").document(CurrentRecord!.id!).delete() { (err) in
                    if let err = err {
                        print("Error getting document: \(err)")
                    }
                    else {
                        let alert = UIAlertController(title: "Congratulations", message: "Record deleted successfully!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default,handler: { (action) in
                            print(self)
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
