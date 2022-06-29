//
//  ReminderViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class ListOptionsViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    var delegate: ListOptionsViewControllerDelegate?
    var dueDate: Date?
    var isDuplicatable: Bool!
    
    @IBAction func dismissView(){
        self.dismiss(animated: true)
        delegate?.listOptionsViewController(self, didTapAtDoneWithOpacity: 1.0)
    }
    
    func presentSortViewController()
    {
        let sortOptionsViewController = SortOptionsViewController()
        sortOptionsViewController.transitioningDelegate = self
        sortOptionsViewController.modalTransitionStyle = .crossDissolve
        sortOptionsViewController.modalPresentationStyle = .custom
        sortOptionsViewController.delegate = self
        self.present(sortOptionsViewController, animated: true, completion: nil)
    }
    
    func presentThemeSelectorViewController()
    {
        let themeSelectorViewController = ThemeSelectorViewController()
        themeSelectorViewController.transitioningDelegate = self
        themeSelectorViewController.modalTransitionStyle = .crossDissolve
        themeSelectorViewController.modalPresentationStyle = .custom
        themeSelectorViewController.delegate = self
        self.present(themeSelectorViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        optionsTable.delegate = self
        optionsTable.dataSource = self
        self.optionsTable.register(UINib(nibName: "ListOptionsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ListOptionsTableViewCell")
        
        optionsTable.rowHeight = 60
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presentingViewController)
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
            presentSortViewController()
        case 2:
            presentThemeSelectorViewController()
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
    func sortOptionsViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity opacity: Float) {
        delegate?.listOptionsViewController(self, didTapAtDoneWithOpacity: opacity)
    }
    
    func sortOptionsViewController(_ viewController: UIViewController, didTapAtIndex index: Int) {
        delegate?.listOptionsViewController(self, didTapAtImportance: true, didSelectSortOptionsWithIndex: index)
    }
}

// MARK: - ThemeSelectorViewControllerDelegate

extension ListOptionsViewController: ThemeSelectorViewControllerDelegate{
    func themeSelectorViewController(_ viewController: UIViewController, didSelectThemeWithType type: themeType) {
        delegate?.listOptionsViewController(self, didTapAtChangeTheme: true, didSelectThemeWithType: type)
    }
    func themeSelectorViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity  opacity: Float){
        delegate?.listOptionsViewController(self, didTapAtDoneWithOpacity: opacity)
    }
}

protocol ListOptionsViewControllerDelegate{
    func listOptionsViewController(_ viewController: UIViewController, didTapAtEdit bool: Bool)
    func listOptionsViewController(_ viewController: UIViewController, didTapAtImportance bool: Bool, didSelectSortOptionsWithIndex index: Int)
    func listOptionsViewController(_ viewController: UIViewController, didTapAtChangeTheme bool: Bool, didSelectThemeWithType type: themeType)
    func listOptionsViewController(_ viewController: UIViewController, didTapAtDuplicateList bool: Bool)
    func listOptionsViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity  opacity: Float)
}


