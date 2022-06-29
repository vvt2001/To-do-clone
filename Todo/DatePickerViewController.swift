//
//  DatePickerViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 27/04/2022.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setDueButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var delegate: DatePickerViewControllerDelegate?
    var currentDate = Date()
    @IBAction func datePickerChanged(_ sender: UIDatePicker){
        currentDate = datePicker.date
    }
    @IBAction func goBack(_ sender: UIButton){
        self.dismiss(animated: true)
    }
    @IBAction func setDue(_ sender: UIButton){
        delegate?.datePickerViewController(self, didSetDue: currentDate)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.datePickerViewController(self, didTapAtDoneWithOpacity: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

protocol DatePickerViewControllerDelegate{
    func datePickerViewController(_ viewController: UIViewController, didSetDue date: Date)
    func datePickerViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity  opacity: Float)
}
