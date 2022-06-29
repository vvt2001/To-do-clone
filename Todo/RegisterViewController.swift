//
//  RegisterViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 24/06/2022.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var accountStore: AccountStore!
    
    private func showAlert(title: String, message: String, isSuccess: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
            if isSuccess{
                self.navigationController?.popViewController(animated: true)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func register(_ sender: UIButton){
        if let username = usernameTextField.text, let password = passwordTextField.text, let confirmPassword = confirmPasswordTextField.text, username != "", password != "", confirmPassword != ""{
            if accountStore.allAccounts.first(where: {$0.getUsername() == username}) != nil{
                showAlert(title: "Username already existed", message: "Please try again", isSuccess: false)
            }
            else{
                if password == confirmPassword{
                    let newAccount = Account(username: username, password: password)
                    accountStore.addAccount(account: newAccount)
                    showAlert(title: "Registered", message: "You have successfully registered", isSuccess: true)
                    usernameTextField.text = .none
                    passwordTextField.text = .none
                    confirmPasswordTextField.text = .none
                }
                else{
                    showAlert(title: "Wrong Confirm Password", message: "Please try again", isSuccess: false)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
