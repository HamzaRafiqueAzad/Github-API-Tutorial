//
//  ViewController.swift
//  Github API Tutorial
//
//  Created by Hamza Rafique Azad on 9/8/22.
//

import UIKit

class ViewController: UIViewController {
    
    private var apiManager = APIManager()
    
    private var per_page = 9
    
    private var page = 1
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        
        return searchBar
    }()
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        
        return view
    }()
    
    private let endLabel: UILabel = {
        let label = UILabel()
        label.text = "No Users Found."
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .center
        return label
    }()
    
    private var tableView: UITableView?
    
    private var users = [UserModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureSearchBar()
        configureExploreCollection()
        configureDimmedView()
        
        apiManager.delegate = self
        NetworkMonitor.shared.delegate = self
    }
    
    private func configureDimmedView() {
        view.addSubview(dimmedView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar
        
        searchBar.delegate = self
    }
    
    private func configureExploreCollection() {
        tableView = UITableView(frame: .zero)
        tableView?.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        tableView?.delegate = self
        tableView?.dataSource = self
        guard let tableView = tableView else {
            return
        }
        tableView.separatorStyle = .singleLine
        view.addSubview(tableView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView?.frame = view.bounds
        dimmedView.frame = view.bounds
        
        endLabel.frame = CGRect(x: view.center.x, y: view.center.y, width: view.width / 2, height: view.height / 4)
        endLabel.center = view.center
        view.addSubview(endLabel)
        endLabel.isHidden = true
        
    }
    
    
}

extension ViewController: NetworkMonitorDelegate {
    func updateConnection() {
        if !(NetworkMonitor.shared.isConnected) {
            DispatchQueue.main.async {
                self.showAlert()
            }
        }
    }
    func showAlert() {
        let alertController = UIAlertController (title: "Title", message: "Go to Settings?", preferredStyle: .alert)

            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in

                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }

                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
    }
    
    
}

extension ViewController: APIManagerDelegate {
    func didUpdate(_ apiManager: APIManager, userModel: [UserModel]) {
        for user in userModel {
            users.append(user)
        }
        if users.count == 0 {
            DispatchQueue.main.async {
                //                self.view.del
                self.endLabel.isHidden = false
                self.tableView?.reloadData()
            }
            
        } else {
            DispatchQueue.main.async {
                self.endLabel.isHidden = true
                self.tableView?.reloadData()
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
        if users.count == 0 {
            DispatchQueue.main.async {
                if NetworkMonitor.shared.isConnected && !error.localizedDescription.isEmpty{
                    self.endLabel.text = "No user found"
                } else if NetworkMonitor.shared.isConnected {
                    self.endLabel.text = "Exceeded API Search Limit."
                } else {
                    self.endLabel.text = "No Internet Connection."
                }
                self.endLabel.isHidden = false
                self.tableView?.reloadData()
            }
        }
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        didCancelSearch()
        guard let text = searchBar.text, !text.isEmpty else { return }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didCancelSearch))
        
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0.4
        } completion: { done in
        }
    }
    
    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        users = []
        page = 1
        if let text = searchBar.text, !text.isEmpty {
        apiManager.fetchUsers(userLogin: searchBar.text!, page: page)
        }
        UIView.animate(withDuration: 0.2) {
            self.dimmedView.alpha = 0
        } completion: { done in
            if done {
                self.dimmedView.isHidden = true
            }
        }
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
        
        cell.configure(debug: users[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 9
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if users.count < 9 {
            return
        }
        if indexPath.row + 1 == users.count {
            page += 1
            apiManager.fetchUsers(userLogin: searchBar.text!, page: page)
        }
    }
    
    
}

