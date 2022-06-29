//
//  NoteViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 25/06/2022.
//

import UIKit

class NoteViewController: UIViewController {

    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var previreButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    var task: Task!
    var delegate: NoteViewControllerDelegate?
    
    @IBAction func done(){
        task.setNote(note: noteTextView.text)
        delegate?.noteViewControllerDidTapAtDone(self)
        self.dismiss(animated: true)
    }
    
    @IBAction func preview(){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noteTextView.text = task.getNote()
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

protocol NoteViewControllerDelegate{
    func noteViewControllerDidTapAtDone(_ viewController: UIViewController)
}


