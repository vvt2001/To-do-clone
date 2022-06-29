//
//  LoginViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 24/06/2022.
//

import UIKit
import RealmSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    var realm: [Realm] = []
    var accountStore: AccountStore!
    
    private func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction private func login(_ sender: UIButton) {
        if let username = usernameTextField.text, let password = passwordTextField.text, username != "", password != ""{
            if let index = accountStore.allAccounts.firstIndex(where: {$0.getUsername() == username && $0.getPassword() == password}){
                let account = accountStore.allAccounts[index]
                account.setIsLoggedIn(isLoggedIn: true)
                let menuViewController = MenuViewController()
                menuViewController.account = account
                navigationController?.pushViewController(menuViewController, animated: true)
            }
            else{
                showAlert(title: "Wrong Username or Password", message: "Please try again")
            }
        }
    }
    
    @IBAction private func register(_ sender: UIButton) {
        let registerViewController = RegisterViewController()
        registerViewController.accountStore = accountStore
        navigationController?.pushViewController(registerViewController, animated: true)
    }
    
    private func initDatabase(){
        let defaultPath = Realm.Configuration.defaultConfiguration.fileURL
        print(defaultPath)
        
        //try! FileManager.default.removeItem(atPath: defaultPath!.path)
//        try! Database.realm.write({
//            Database.realm.deleteAll()
//        })
        
        lazy var realm:Realm = {
            return try! Realm(fileURL: defaultPath!)
        }()
        Database.realm = realm

//        Database.realm = try! Realm(fileURL: defaultPath!)
        
        let accounts = Database.realm.objects(Account.self)
        for value in accounts{
            accountStore.allAccounts.append(value)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        initDatabase()

        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "Login", style: .plain, target: nil, action: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for account in accountStore.allAccounts{
            if account.getIsLoggedIn(){
                let menuViewController = MenuViewController()
                menuViewController.account = account
                navigationController?.pushViewController(menuViewController, animated: true)
                break
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
