//
//  AddLedgerViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/13.
//

import UIKit
import FirebaseFirestore

class AddLedgerViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var createBtn: UIButton!
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dic:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 89/255, blue: 71/255, alpha: 1),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)];
                
        self.typeSegment.setTitleTextAttributes((dic as! [NSAttributedString.Key : Any]), for: UIControl.State.normal);
    }
    
    @IBAction func typeSegmentPressed(_ sender: Any) {
        if self.typeSegment.selectedSegmentIndex == 0 {
            self.view.backgroundColor = UIColor(red: 17/255, green: 89/255, blue: 71/255, alpha: 1)
            let dic:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor(red: 17/255, green: 89/255, blue: 71/255, alpha: 1),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)];
                    
            self.typeSegment.setTitleTextAttributes((dic as! [NSAttributedString.Key : Any]), for: UIControl.State.normal);
            self.backBtn.titleLabel?.textColor = UIColor(red: 17/255, green: 89/255, blue: 71/255, alpha: 1)
            self.createBtn.titleLabel?.textColor = UIColor(red: 17/255, green: 89/255, blue: 71/255, alpha: 1)
        }
        else {
            self.view.backgroundColor = UIColor(red: 64/255, green: 61/255, blue: 114/255, alpha: 1)
            let dic:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor(red: 64/255, green: 61/255, blue: 114/255, alpha: 1),NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)];
                    
            self.typeSegment.setTitleTextAttributes((dic as! [NSAttributedString.Key : Any]), for: UIControl.State.normal);
            self.backBtn.titleLabel?.textColor = UIColor(red: 64/255, green: 61/255, blue: 114/255, alpha: 1)
            self.createBtn.titleLabel?.textColor = UIColor(red: 64/255, green: 61/255, blue: 114/255, alpha: 1)
        }
    }
    @IBAction func createBtnPressed(_ sender: UIButton) {
        if self.nameLabel.text! == "" {
            let alert = UIAlertController(title: "Sorry", message: "Ledger name can not be empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion:nil)
            return
        }
        
        db.collection("User").document(CurrentUser!.id!).getDocument { (document, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                let currentUser = self.db.collection("User").document(CurrentUser!.id!)
                let newDocument = self.db.collection("Ledger").document()
                var type = ""
                if self.typeSegment.selectedSegmentIndex == 0 {
                    type = "PERSON"
                    currentUser.updateData(["personLedgerList" : FieldValue.arrayUnion([newDocument.documentID])])
                }
                else {
                    type = "GROUP"
                    currentUser.updateData(["groupLedgerList" : FieldValue.arrayUnion([newDocument.documentID])])
                }
                newDocument.setData(["name": self.nameLabel.text!, "type": type, "recordData": [], "userList" : [(document!.get("id") as! String)], "id": newDocument.documentID]) { (error) in
                    if let err = err {
                        print("Error getting document: \(err)")
                    }
                    else {
                        let alert = UIAlertController(title: "Congratulations", message: "Ledger created successfully!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
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
