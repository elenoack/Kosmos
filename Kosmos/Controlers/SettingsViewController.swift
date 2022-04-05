//
//  SettingsViewController.swift
//  Kosmos
//
//  Created by mac on 20.11.21.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    @IBOutlet weak var namePlayerTextField: UITextField!
    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    private let defaults = UserDefaultsStorage()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        levelSegmentedControl.selectedSegmentIndex = defaults.level
        namePlayerTextField.text = defaults.namePlayer
    }
        
    @IBAction func openLeadersList(_ sender: UIButton) {
        let nextViewController = storyboard!.instantiateViewController(withIdentifier: "LeadersStoryboard")
        present(nextViewController, animated: false, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        defaults.level = levelSegmentedControl.selectedSegmentIndex
        defaults.namePlayer = namePlayerTextField.text 
        dismiss(animated: false, completion: nil)
    }    
}

