//
//  HomeViewController.swift
//  Kosmos
//
//  Created by mac on 19.11.21.
//


import UIKit

class HomeViewController: UIViewController {
    // MARK: - Properties
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    var background = UIImageView(image: UIImage(named: "HomeBackground"))
    let newGameButton = UIButton(title: NSLocalizedString("new_game", comment: ""),font: UIFont(name: "UsuallyfontBold", size: 24), color: .red)
    let settingsButton = UIButton(title: NSLocalizedString("settings", comment: ""),font: UIFont(name: "UsuallyfontRegular", size: 24), color: .black)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var _: UIStatusBarStyle = .lightContent
    }
    
    @objc func showGameScreen() {
        let nextViewController = storyboardInstance.instantiateViewController(withIdentifier: "gameStoryboard")
        present(nextViewController, animated: false, completion: nil)
    }
    
    @objc func showSettingsScreen() {
        let nextViewController = storyboardInstance.instantiateViewController(withIdentifier: "SettingsStoryboard")
        present(nextViewController, animated: false, completion: nil)
    }
}

// MARK: - Private

private extension HomeViewController {
    
    func setupViews() {
        view.backgroundColor = .systemFill
        background.contentMode = .scaleAspectFill
        background.frame = CGRect(x: CGFloat.zero, y: CGFloat.zero, width: view.bounds.width, height: view.frame.height)
        view.addSubview(background)
        
        newGameButton.frame = CGRect(x: CGFloat.zero, y: view.center.y, width: view.bounds.width, height: 50)
        newGameButton.backgroundColor = .white
        newGameButton.alpha = 0.65
        view.addSubview(newGameButton)
        newGameButton.addTarget(self, action: #selector(showGameScreen), for: .touchUpInside)
        
        settingsButton.frame = CGRect(x: CGFloat.zero, y: view.center.y + newGameButton.frame.height + 12, width: view.bounds.width, height: 45)
        settingsButton.backgroundColor = .white
        settingsButton.alpha = 0.65
        view.addSubview(settingsButton)
        settingsButton.addTarget(self, action:#selector(showSettingsScreen), for: .touchUpInside)
    }
}


