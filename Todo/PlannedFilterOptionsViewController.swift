//
//  PlannedFilterOptionsViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 20/04/2022.
//

import UIKit

class PlannedFilterOptionsViewController: UIViewController {
    var delegate: PlannedFilterOptionsViewControllerDelegate?
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    @IBAction func dismissView(){
        self.dismiss(animated: true)
        delegate?.plannedFilterOptionsViewController(self, didTapAtDoneWithOpacity: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.preferredContentSize = CGSize(width: 100, height: 100)
        
        optionsTable.delegate = self
        optionsTable.dataSource = self
        self.optionsTable.register(UINib(nibName: "FilterOptionsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "FilterOptionsTableViewCell")
        
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
extension PlannedFilterOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterOptionsTableViewCell", for: indexPath) as! FilterOptionsTableViewCell
        cell.createOptionCell(index: indexPath.row)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.plannedFilterOptionsViewController(self, didTapAtIndex: indexPath.row)
        self.dismiss(animated: true)
        delegate?.plannedFilterOptionsViewController(self, didTapAtDoneWithOpacity: 1.0)
    }
}

protocol PlannedFilterOptionsViewControllerDelegate{
    func plannedFilterOptionsViewController(_ viewController: UIViewController, didTapAtIndex index: Int)
    func plannedFilterOptionsViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity  opacity: Float)
}
