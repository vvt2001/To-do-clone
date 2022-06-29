//
//  ReminderViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class ListSelectorViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    var delegate: ListSelectorViewControllerDelegate?
    var dueDate: Date?
    var isEditMode: Bool!
    var listStore: ListStore!
    
    @IBAction func dismissView(){
        self.dismiss(animated: true)
        delegate?.listSelectorViewController(self, didTapAtDoneWithOpacity: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        optionsTable.delegate = self
        optionsTable.dataSource = self
        self.optionsTable.register(UINib(nibName: "ListSelectorTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ListSelectorTableViewCell")
        
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
extension ListSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStore.allList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListSelectorTableViewCell", for: indexPath) as! ListSelectorTableViewCell
        cell.createCell(list: listStore.allList[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditMode{
            delegate?.listSelectorViewController(self, selectForListOptions: true, listForIndex: listStore.allList[indexPath.row])
            delegate?.listSelectorViewController(self, didTapAtDoneWithOpacity: 1.0)
        }
        else{
            delegate?.listSelectorViewController(self, selectForAddTask: true, listForIndex: listStore.allList[indexPath.row])
            delegate?.listSelectorViewController(self, didTapAtDoneWithOpacity: 1.0)
        }
        self.dismiss(animated: true)
    }
}

protocol ListSelectorViewControllerDelegate{
    func listSelectorViewController(_ viewController: UIViewController, selectForAddTask bool: Bool, listForIndex list: List?)
    func listSelectorViewController(_ viewController: UIViewController, selectForListOptions bool: Bool, listForIndex list: List?)
    func listSelectorViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity  opacity: Float)
}

