//
//  ViewController.swift
//  Film App
//
//  Created by William Yulio on 25/07/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating {
    
    var fetchedMovieData = [Movie](){
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    var totalPage = 1
    var currentPage = 1
    var fetchedGenreData: [Genre] = []
    
    let searchBarController = UISearchController(searchResultsController: nil)
    var filteredData = [Movie](){
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
//        self.tableView.refreshControl = UIRefreshControl()
//        self.tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        self.refreshData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.definesPresentationContext = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.definesPresentationContext = false
    }
    
    @objc func refreshData(){
        
        currentPage = 1
        loadData(page: 1, refresh: true, query: searchBarController.searchBar.text ?? "")
    }
    
    func style(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        searchBarController.searchBar.delegate = self
        searchBarController.searchResultsUpdater = self
        searchBarController.obscuresBackgroundDuringPresentation = false
        searchBarController.searchBar.sizeToFit()
        searchBarController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchBarController
    }
    
    func layout() {
        view.addSubview(tableView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }
    
    func getFilteredData(searchedText: String = String()) {
        let filteredListData: [Movie] = fetchedMovieData.filter({ (object) -> Bool in
            searchedText.isEmpty ? true : object.title.lowercased().contains(searchedText.lowercased())
        })
        filteredData = filteredListData
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBarController.searchBar.text != ""{
            return filteredData.count
        }else{
            return fetchedMovieData.count
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchBarController.searchBar.text != ""{

            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
                fatalError("The tableview couldn't dequeue a Custom Cell in ViewController")
            }
            let dataCell = filteredData[indexPath.row]
            cell.configure(title: dataCell.originalTitle, posterURL: dataCell.posterPath, year: dataCell.releaseDate, genreId: dataCell.genreIDS, genreList: fetchedGenreData)
            //        cell.configure(title: "test")
            return cell

        }
            
        if currentPage < totalPage && indexPath.row == fetchedMovieData.count - 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier, for: indexPath) as? LoadingTableViewCell else {
                fatalError("The tableview couldn't dequeue a Custom Cell in ViewController")
            }
            cell.configure(text: "Loading ...")
            return cell
            
        }else{
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
                fatalError("The tableview couldn't dequeue a Custom Cell in ViewController")
            }
            let dataCell = fetchedMovieData[indexPath.row]
            cell.configure(title: dataCell.originalTitle, posterURL: dataCell.posterPath, year: dataCell.releaseDate, genreId: dataCell.genreIDS, genreList: fetchedGenreData)
            //        cell.configure(title: "test")
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if currentPage < totalPage && indexPath.row == fetchedMovieData.count - 1{
            currentPage += 1
            loadData(page: currentPage,refresh: false, query: searchBarController.searchBar.text ?? "")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextPage = DetailViewController()
        nextPage.configure(posterURL: fetchedMovieData[indexPath.row].backdropPath, overview: fetchedMovieData[indexPath.row].overview, title: fetchedMovieData[indexPath.row].title, genreId: fetchedMovieData[indexPath.row].genreIDS, genreList: fetchedGenreData)
        nextPage.movieId = fetchedMovieData[indexPath.row].id
        self.navigationController?.pushViewController(nextPage, animated: true)
    }
    
    func loadData(page: Int, refresh: Bool = false, query: String){
        
        if refresh{
            self.tableView.refreshControl?.beginRefreshing()
        }
        
        networkManager.shared.fetchMovieData(page: page){ [weak self] result in
            DispatchQueue.main.async{
                if refresh{
                    self?.fetchedMovieData.removeAll()
                    self?.tableView.refreshControl?.endRefreshing()
                }
                switch result {
                case .success(let data):
                    self?.fetchedMovieData.append(contentsOf: data.results)
                    self?.totalPage = data.totalPages
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
//        networkManager.shared.fetchSearchMovie(query: query){ [weak self] result in
//            DispatchQueue.main.async{
//                if refresh{
//                    self?.filteredData.removeAll()
//                    self?.tableView.refreshControl?.endRefreshing()
//                }
//                switch result {
//                case .success(let data):
//                    self?.filteredData.append(contentsOf: data.results)
//                    self?.totalPage = data.totalPages
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
        
        networkManager.shared.fetchGenresData{ result in
            DispatchQueue.main.async {
                if self.fetchedGenreData.isEmpty{
                    self.fetchedGenreData = result.genres
                }
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchBarController.searchBar
        getFilteredData(searchedText: searchBar.text ?? String())
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            getFilteredData(searchedText: searchBar.text ?? String())
        }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        searchBar.text = String()
        getFilteredData()
    }


}

