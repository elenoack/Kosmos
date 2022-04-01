//
//  LeadersViewController.swift
//  Kosmos
//
//  Created by mac on 14.12.21.
//

import UIKit

class LeadersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    // MARK: - Properties
    let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    @IBOutlet weak var tableView: UITableView!
    private let defaults = UserDefaultsStorage()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBlurView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func openMenu(_ sender: UIButton) {
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension LeadersViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return defaults.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        configuration.text = defaults.list[indexPath.row]
        cell.textLabel?.text = defaults.list[indexPath.row]
        cell.backgroundColor = .lightGray
        return cell
    }
}

// MARK: - private
private extension LeadersViewController {
    
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

   

   


