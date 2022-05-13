//
//  ReminderViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class ListOptionsViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    var delegate: ListOptionsViewControllerDelegate?
    var dueDate: Date?
    var isDuplicatable: Bool!
    
    @IBAction func dismissView(){
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        optionsTable.delegate = self
        optionsTable.dataSource = self
        self.optionsTable.register(UINib(nibName: "ListOptionsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ListOptionsTableViewCell")
        
        optionsTable.rowHeight = 60
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

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ListOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDuplicatable{
            return 4
        }
        else{
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListOptionsTableViewCell", for: indexPath) as! ListOptionsTableViewCell
        cell.createOptionCell(index: indexPath.row)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            delegate?.listOptionsViewController(self, didTapAtEdit: true)
            self.dismiss(animated: true)
        case 1:
            let sortOptionsViewController = SortOptionsViewController()
            sortOptionsViewController.delegate = self
            present(sortOptionsViewController, animated: true, completion: nil)
        case 2:
            let themeSelectorViewController = ThemeSelectorViewController()
            themeSelectorViewController.delegate = self
            present(themeSelectorViewController, animated: true, completion: nil)
        case 3:
            delegate?.listOptionsViewController(self, didTapAtDuplicateList: true)
            self.dismiss(animated: true)
        default:
            break
        }
    }
}

// MARK: - SortOptionsViewControllerDelegate
extension ListOptionsViewController: SortOptionsViewControllerDelegate{
    func sortOptionsViewController(_ viewController: UIViewController, didTapAtIndex index: Int) {
        delegate?.listOptionsViewController(self, didTapAtImportance: true, didSelectSortOptionsWithIndex: index)
    }
}

// MARK: - ThemeSelectorViewControllerDelegate

extension ListOptionsViewController: ThemeSelectorViewControllerDelegate{
    func themeSelectorViewController(_ viewController: UIViewController, didSelectThemeWithType type: themeType) {
        delegate?.listOptionsViewController(self, didTapAtChangeTheme: true, didSelectThemeWithType: type)
    }
}

protocol ListOptionsViewControllerDelegate{
    func listOptionsViewController(_ viewController: UIViewController, didTapAtEdit bool: Bool)
    func listOptionsViewController(_ viewController: UIViewController, didTapAtImportance bool: Bool, didSelectSortOptionsWithIndex index: Int)
    func listOptionsViewController(_ viewController: UIViewController, didTapAtChangeTheme bool: Bool, didSelectThemeWithType type: themeType)
    func listOptionsViewController(_ viewController: UIViewController, didTapAtDuplicateList bool: Bool)


}


