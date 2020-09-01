//
//  SearchControllerViewController.swift
//  GithubSearch
//
//  Created George Kyrylenko on 30.08.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import RxSwift
import RxCocoa

class SearchControllerViewController: UIViewController, UISearchBarDelegate, SearchControllerViewProtocol {
    
	var presenter: SearchControllerPresenterProtocol?
    private let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    var searchReposResults = [RepoUIModel]()
    var searchText = ""
    var isLoacalResults = false
    @IBOutlet weak var searchResultsTableView: UITableView!
    
	override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        prepareSearchBar()
        prepareTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func prepareNavigationBar(){
        self.title = "Git Serch"
        let historyItem = UIBarButtonItem(image: UIImage(systemName: "tray.full"), style: .plain, target: self, action: #selector(historyButtonAction))
        self.navigationItem.leftBarButtonItem = historyItem
        let loginTitle = (presenter?.isLoginedUser() ?? false) ? "LogOut" : "LogIn"
        let loginLogoutItem = UIBarButtonItem(title: loginTitle, style: .plain, target: self, action: #selector(loginButtonAction))
        self.navigationItem.rightBarButtonItem = loginLogoutItem
    }
    
    @objc func historyButtonAction(){
        isLoacalResults = true
        presenter?.getStoredResults()
    }
    
    @objc func loginButtonAction(){
        if(!(presenter?.isLoginedUser() ?? false)){
            let alert = UIAlertController(title: "Login to GitHub", message: nil, preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.tag = 0
                textField.placeholder = "Email"
            }
            alert.addTextField { (textField) in
                textField.tag = 0
                textField.placeholder = "Password"
                textField.isSecureTextEntry = true
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "LogIn", style: .default, handler: {(action) in
                guard let emailTextField = alert.textFields?[0],
                      let passwordTextField = alert.textFields?[1] else {return}
                self.presenter?.login(with: emailTextField.text ?? "", and: passwordTextField.text ?? "")
                
            }))
            self.present(alert, animated: true)
        } else {
            self.presenter?.logOut()
            self.navigationItem.rightBarButtonItem?.title = "LogIn"
        }
    }
    
    func prepareTableView(){
        searchResultsTableView.register(UINib(nibName: "GitCell", bundle: nil), forCellReuseIdentifier: "GitCell")
        searchResultsTableView.isEditing = true
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
    }

    func prepareSearchBar(){
        searchController.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        searchText = searchBar.text ?? ""
        isLoacalResults = false
        presenter?.searchRepo(by: searchText)
    }
    
    func add(searchResults: [RepoUIModel], isNewSearch: Bool) {
        if isNewSearch{
            searchReposResults = searchResults
            searchResultsTableView.reloadData()
            if !searchReposResults.isEmpty{
                searchResultsTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        } else {
            searchResultsTableView.beginUpdates()
            let firstIndex = searchReposResults.count
            searchReposResults.append(contentsOf: searchResults)
            let lastIndex = searchReposResults.count - 1
            var indexPathes = [IndexPath]()
            for i in firstIndex...lastIndex{
                indexPathes.append(IndexPath(row: i, section: 0))
            }
            searchResultsTableView.insertRows(at: indexPathes, with: .automatic)
            searchResultsTableView.endUpdates()
        }
    }
    
    func loginSuccess() {
        self.navigationItem.rightBarButtonItem?.title = "LogOut"
        let alert = UIAlertController(title: "Login Succes", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func onError(error: String) {
        let alert = UIAlertController(title: "ERROR", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

extension SearchControllerViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchReposResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isLoacalResults, indexPath.row == searchReposResults.count - 3{
            presenter?.searchRepo(by: searchText)
        }
        let repo = searchReposResults[indexPath.row]
        let gitCell = tableView.dequeueReusableCell(withIdentifier: "GitCell") as! GitCell
        gitCell.repoNameLbl.text = String(repo.name?.prefix(30) ?? "NO NAME")
        gitCell.repoStarsLbl.text = "\(repo.stars ?? 0)"
        gitCell.isWatchedRepo.isHidden = !repo.isViewed
        presenter?.markAsViewed(repo: searchReposResults[indexPath.row])
        return gitCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: searchReposResults[indexPath.row].url ?? "") else { return }
        UIApplication.shared.open(url)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return isLoacalResults
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            tableView.beginUpdates()
            presenter?.remove(repo: searchReposResults[indexPath.row])
            searchReposResults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let repo = searchReposResults[sourceIndexPath.row]
        searchReposResults.remove(at: sourceIndexPath.row)
        searchReposResults.insert(repo, at: destinationIndexPath.row)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool{
        return isLoacalResults
    }

//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath){
//
//    }
}
