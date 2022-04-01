//
//  SettingsViewController.swift
//  Kosmos
//
//  Created by mac on 20.11.21.
//

import UIKit

class SettingsViewController: UIViewController {
    // MARK: - Properties
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    @IBOutlet weak var namePlayerTextField: UITextField!
    @IBOutlet weak var levelSegmentedControl: UISegmentedControl!
    private let defaults = UserDefaultsStorage()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurView()
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

// MARK: - private
private extension SettingsViewController {
    
    func setupBlurView() {
        view.addSubview(blurView)
        blurView.effect = UIBlurEffect(style: .extraLight)
        blurView.alpha = 0.25
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor)
        ])
    }
}
