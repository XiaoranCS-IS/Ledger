//
//  ViewController.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/9.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitToSignIn(sender: UIStoryboardSegue) {
        CurrentUser = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier else { return}
        if id == "signInSegue" {
            let signInSegue = segue as! SignInSegue
            signInSegue.name = self.nameLabel.text
            signInSegue.password = self.passwordLabel.text
        }
    }
}

