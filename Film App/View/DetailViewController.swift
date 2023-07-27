//
//  DetailViewController.swift
//  Film App
//
//  Created by William Yulio on 26/07/23.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var fetchedMovieCast = [CastElement]()
    {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }

    var overviewText = UITextView()
    var horizontalStackView = UIStackView()
    var movieTitle = UILabel()
    var movieDuration = UILabel()
    var HDText = UILabel()
    var movieGenre = UILabel()
    var backdropImage = UIImageView()
    var containerView = UIView()
    var castTitle = UILabel()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 300)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    let layoutCollectionView = UICollectionViewFlowLayout()
    var movieId: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        loadData(movieId: movieId)
        layout()
        
    }
    
    func style(){
        containerView.translatesAutoresizingMaskIntoConstraints = false

        backdropImage.translatesAutoresizingMaskIntoConstraints = false
        backdropImage.clipsToBounds = true
        
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 20
        horizontalStackView.alignment = .fill
        
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.font = UIFont.Poppins(.bold, size: 20)
        movieTitle.textColor = .black
        movieTitle.numberOfLines = 2
        
        movieDuration.translatesAutoresizingMaskIntoConstraints = false
        movieDuration.font = UIFont.Poppins(.medium, size: 16)
        movieDuration.textColor = UIColor(rgb: 0x777777)
        movieDuration.text = "1h 24m"
        
        HDText.translatesAutoresizingMaskIntoConstraints = false
        HDText.font = UIFont.Poppins(.medium, size: 16)
        HDText.textColor = UIColor(rgb: 0x777777)
        HDText.text = " HD "
        HDText.layer.borderWidth = 1
        HDText.layer.borderColor = UIColor(rgb: 0x777777).cgColor
        HDText.layer.cornerRadius = 6
        
        movieGenre.translatesAutoresizingMaskIntoConstraints = false
        movieGenre.font = UIFont.Poppins(.medium, size: 16)
        movieGenre.textColor = UIColor(rgb: 0x777777)
        movieGenre.numberOfLines = 2
        
        overviewText.translatesAutoresizingMaskIntoConstraints = false
        overviewText.font = UIFont.Poppins(size: 16)
        overviewText.textColor = UIColor(rgb: 0x777777)
        overviewText.textAlignment = .left
        overviewText.sizeToFit()
        overviewText.isScrollEnabled = false
        
        castTitle.translatesAutoresizingMaskIntoConstraints = false
        castTitle.font = UIFont.Poppins(.semibold, size: 18)
        castTitle.textColor = .black
        castTitle.text = "Cast"

        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func layout() {
        view.addSubview(containerView)
        containerView.addSubview(backdropImage)
        containerView.addSubview(movieTitle)
        containerView.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(movieDuration)
        horizontalStackView.addArrangedSubview(HDText)
        containerView.addSubview(movieGenre)
        
        view.addSubview(overviewText)
        view.addSubview(castTitle)
        view.addSubview(collectionView)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 300),
            
            backdropImage.topAnchor.constraint(equalTo: containerView.topAnchor),
            backdropImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backdropImage.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            backdropImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            overviewText.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 30),
            overviewText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            view.trailingAnchor.constraint(equalTo: overviewText.trailingAnchor, constant: 10),
            
            castTitle.topAnchor.constraint(equalTo: overviewText.bottomAnchor, constant: 20),
            castTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            collectionView.topAnchor.constraint(equalTo: castTitle.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            movieTitle.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 10),
            view.trailingAnchor.constraint(equalTo: movieTitle.trailingAnchor, constant: 10),
            movieTitle.bottomAnchor.constraint(equalTo: horizontalStackView.topAnchor),
            movieTitle.heightAnchor.constraint(equalToConstant: 60),
            
            horizontalStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 10),
            horizontalStackView.bottomAnchor.constraint(equalTo: movieGenre.topAnchor, constant: -20),
            
            movieGenre.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 10),
            view.trailingAnchor.constraint(equalTo: movieGenre.trailingAnchor, constant: 10),
            movieGenre.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            movieTitle.heightAnchor.constraint(equalToConstant: 60),
            

        ])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("total data\(fetchedMovieCast.count)")
        return fetchedMovieCast.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else {
            fatalError("The collection view couldn't dequeue a Custom Cell in ViewController")
        }

        let dataCell = fetchedMovieCast[indexPath.row]
        cell.configure(profileURL: dataCell.profilePath, cast: dataCell.name)
        //        cell.configure(title: "test")
        
//        let cell = UICollectionViewCell()
        
        return cell
    }
    
    func configure(posterURL: String?, overview: String, title: String, genreId: [Int], genreList: [Genre]){
        
        var genreName : [String] = []
        movieTitle.text = title
        
        overviewText.text = overview
        
        if let posterURL = posterURL {
            guard let CompleteURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)") else {return}
            self.backdropImage.sd_setImage(with: CompleteURL)
        }

        for data in genreList{
            if ((genreId.firstIndex(where: { $0 == data.id })) != nil){
                genreName.append(data.name)
            }
        }

        movieGenre.text = genreName.joined(separator: ", ")
        
    }
    
    func loadData(movieId: Int){
        networkManager.shared.fetchCastMovie(movieId: movieId){ [weak self] result in
            DispatchQueue.main.async{
                switch result {
                case .success(let data):
                    self?.fetchedMovieCast.append(contentsOf: data.cast)
                    print(self?.fetchedMovieCast)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    

}
