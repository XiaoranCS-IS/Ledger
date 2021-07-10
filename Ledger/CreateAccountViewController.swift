//
//  CreateAccountViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/13.
//

import UIKit
import FirebaseFirestore

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        if self.nameLabel.text! == "" || self.passwordLabel.text! == "" {
            let alert = UIAlertController(title: "Sorry", message: "Inputs can not be empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion:nil)
            return
        }
        
        db.collection("User").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    if self.nameLabel.text! == document.get("name") as! String {
                        let alert = UIAlertController(title: "Sorry", message: "Username already existed!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion:nil)
                        return
                    }
                }
                let newDocument = self.db.collection("User").document()
                newDocument.setData(["name": self.nameLabel.text!, "password": self.passwordLabel.text!, "id": newDocument.documentID, "personLedgerList": [], "groupLedgerList": []]) { (error) in
                    if let err = err {
                        print("Error getting document: \(err)")
                    }
                    else {
                        let alert = UIAlertController(title: "Congratulations", message: "Sign up successfully!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion:nil)
                        
                        let newUser = User(context: self.context)
                        newUser.id = newDocument.documentID
                        newUser.name = self.nameLabel.text!
                        newUser.password = self.passwordLabel.text!
                        
                        do {
                            try self.context.save()
                            
                        } catch  {
                        }
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
