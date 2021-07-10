//
//  SignInSegue.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/13.
//

import UIKit
import FirebaseFirestore

class SignInSegue: UIStoryboardSegue {
    var userList: [User] = []
    var name: String?
    var password: String?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var db = Firestore.firestore()
    override func perform() {
        if self.name! == "" || self.password! == "" {
            let alert = UIAlertController(title: "Sorry", message: "Inputs can not be empty!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.source.present(alert, animated: true, completion:nil)
            return
        }
        
        db.collection("User").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting document: \(err)")
            }
            else {
                for document in querySnapshot!.documents {
                    let user = User(context: self.context)
                    user.id = (document.get("id") as! String)
                    user.name = (document.get("name") as! String)
                    user.password = (document.get("password") as! String)
                    self.userList.append(user)
                }
                
                //
                for user in self.userList {
                    if user.name == self.name && user.password == self.password {
                        CurrentUser = user
                        self.source.present(self.destination, animated: true, completion: nil)
                        return
                    }
                }
                
                // name or password error
                let alert = UIAlertController(title: "Sorry", message: "Invaid name or passord.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.source.present(alert, animated: true, completion:nil)
            }
        }
    }
}
