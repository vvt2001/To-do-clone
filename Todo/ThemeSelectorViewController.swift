//
//  ThemeSelectorViewController.swift
//  Todo
//
//  Created by Vũ Việt Thắng on 11/05/2022.
//

import UIKit

class ThemeSelectorViewController: UIViewController {
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var whiteButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var purpleButton: UIView!
    @IBOutlet weak var tealButton: UIView!
    
    var delegate: ThemeSelectorViewControllerDelegate?
    
    @IBAction func changeThemeToWhite(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.themeSelectorViewController(self, didSelectThemeWithType: .white)
    }
    
    @IBAction func changeThemeToRed(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.themeSelectorViewController(self, didSelectThemeWithType: .red)
    }
    
    @IBAction func changeThemeToBlue(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.themeSelectorViewController(self, didSelectThemeWithType: .blue)
    }
    
    @IBAction func changeThemeToGreen(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.themeSelectorViewController(self, didSelectThemeWithType: .green)
    }
    
    @IBAction func changeThemeToYellow(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.themeSelectorViewController(self, didSelectThemeWithType: .yellow)
    }
    
    @IBAction func changeThemeToPurple(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.themeSelectorViewController(self, didSelectThemeWithType: .purple)
    }
    
    @IBAction func changeThemeToTeal(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.themeSelectorViewController(self, didSelectThemeWithType: .teal)
    }
    
    @IBAction func dismiss(_ sender: UIButton){
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        delegate?.themeSelectorViewController(self, didTapAtDoneWithOpacity: 1.0)
    }
    
    @IBAction func goBack(_ sender: UIButton){
        self.dismiss(animated: true)
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

protocol ThemeSelectorViewControllerDelegate{
    func themeSelectorViewController(_ viewController: UIViewController, didSelectThemeWithType type: themeType)
    func themeSelectorViewController(_ viewController: UIViewController, didTapAtDoneWithOpacity  opacity: Float)
}
