//
//  SortOptionsViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 11/05/2022.
//

import UIKit

class SortOptionsViewController: UIViewController {
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    var delegate: SortOptionsViewControllerDelegate?
    
    @IBAction func goBack(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    @IBAction func dismiss(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.sortOptionsViewController(self, didTapAtDoneWithOpacity: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        optionsTable.delegate = self
        optionsTable.dataSource = self
        self.optionsTable.register(UINib(nibName: "SortOptionsTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "SortOptionsTableViewCell")
        
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
extension SortOptionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortOptionsTableViewCell", for: indexPath) as! SortOptionsTableViewCell
        cell.createOptionCell(index: indexPath.row)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.sortOptionsViewController(self, didTapAtIndex: indexPath.row)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

protocol SortOptionsViewControllerDelegate{
    func sortOptionsViewController(_ viewController: UIViewController, didTapAtIndex index: Int)
    func sortOptionsViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity  opacity: Float)
}
