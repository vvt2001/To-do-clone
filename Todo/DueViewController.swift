//
//  ReminderViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 22/04/2022.
//

import UIKit

class DueViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var optionsTable: UITableView!
    @IBOutlet weak var dismissButton: UIBarButtonItem!
    
    var delegate: DueViewControllerDelegate?
    var dueDate: Date?

    @IBAction func dismissView(){
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        optionsTable.delegate = self
        optionsTable.dataSource = self
        self.optionsTable.register(UINib(nibName: "DueTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "DueTableViewCell")
        
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
extension DueViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DueTableViewCell", for: indexPath) as! DueTableViewCell
        cell.createOptionCell(index: indexPath.row)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row{
        case 0:
            dueDate = Date()
        case 1:
            var dateComponent = DateComponents()
            dateComponent.day = 1
            dueDate = Calendar.current.date(byAdding: dateComponent, to: Date())
        case 2:
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            
            let myDate = dateFormatter.date(from: dateFormatter.string(from: date))!
            
            let myCalendar = Calendar(identifier: .gregorian)
            let weekDay = myCalendar.component(.weekday, from: myDate)

            
            var dateComponent = DateComponents()
            if weekDay == 1{
                dateComponent.day = 1
            }
            else{
                dateComponent.day = 9 - weekDay
            }
            dueDate = Calendar.current.date(byAdding: dateComponent, to: date)!
        case 3:
            let datePickerViewController = DatePickerViewController()
            datePickerViewController.delegate = self
            present(datePickerViewController, animated: true, completion: nil)
        default:
            break
        }
        if indexPath.row != 3{
            delegate?.dueViewController(self, didTapAtIndex: indexPath.row, dateForIndex: dueDate)
            self.dismiss(animated: true)
        }
    }
}

protocol DueViewControllerDelegate{
    func dueViewController(_ viewController: UIViewController, didTapAtIndex index: Int, dateForIndex date: Date?)
}

// MARK: - DatePickerViewControllerDelegate
extension DueViewController: DatePickerViewControllerDelegate{
    func datePickerViewController(_ viewController: UIViewController, didSetDue date: Date) {
        dueDate = date
        delegate?.dueViewController(self, didTapAtIndex: 3, dateForIndex: dueDate)
   }
}
