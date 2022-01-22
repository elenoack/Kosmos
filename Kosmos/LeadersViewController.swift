//
//  LeadersViewController.swift
//  Kosmos
//
//  Created by mac on 14.12.21.
//

import UIKit

class LeadersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let defaults = UserDefaultsStorage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
    }
    
    @IBAction func openMenu(_ sender: UIButton) {
        let nextViewController = storyboard!.instantiateViewController(withIdentifier: "HomeStoryboard")
        present(nextViewController, animated: false, completion: nil)
    }
}

// MARK: - UITableViewDataSource
extension LeadersViewController {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        defaults.list.count
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


   

   


