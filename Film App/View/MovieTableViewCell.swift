//
//  MovieTableViewCell.swift
//  Film App
//
//  Created by William Yulio on 25/07/23.
//

import UIKit
import SDWebImage
class MovieTableViewCell: UITableViewCell {
    
    static let identifier = "CustomCell"
    let movieTitle = UILabel()
    let moviePoster = UIImageView()
    let yearReleased = UILabel()
    let movieGenres = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style()
        self.layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func style(){

        moviePoster.translatesAutoresizingMaskIntoConstraints = false
        moviePoster.layer.cornerRadius = 4
//        moviePoster.contentMode = .
        moviePoster.clipsToBounds = true
        
        movieTitle.translatesAutoresizingMaskIntoConstraints = false
        movieTitle.font = UIFont.Poppins(size: 16)
        movieTitle.textColor = .black
        movieTitle.numberOfLines = 2
        
        yearReleased.translatesAutoresizingMaskIntoConstraints = false
        yearReleased.font = UIFont.Poppins(size: 16)
        yearReleased.textColor = UIColor(rgb: 0x777777)
        
        movieGenres.translatesAutoresizingMaskIntoConstraints = false
        movieGenres.font = UIFont.Poppins(size: 12)
        movieGenres.textColor = UIColor(rgb: 0x777777)
        movieGenres.numberOfLines = 2
    }
    
    func layout() {
        self.contentView.addSubview(moviePoster)
        self.contentView.addSubview(movieTitle)
        self.contentView.addSubview(yearReleased)
        self.contentView.addSubview(movieGenres)
        
        NSLayoutConstraint.activate([
            
            moviePoster.topAnchor.constraint(equalTo: contentView.topAnchor),
            moviePoster.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            moviePoster.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            moviePoster.heightAnchor.constraint(equalToConstant: 150),
            moviePoster.widthAnchor.constraint(equalToConstant: 150),
            
            movieTitle.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 10),
            movieTitle.topAnchor.constraint(equalTo: contentView.topAnchor),
            movieTitle.widthAnchor.constraint(equalToConstant: 200),
            
            yearReleased.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 10),
            yearReleased.topAnchor.constraint(equalTo: movieTitle.bottomAnchor),
            
            movieGenres.leadingAnchor.constraint(equalTo: moviePoster.trailingAnchor, constant: 10),
            movieGenres.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            movieGenres.widthAnchor.constraint(equalToConstant: 250),

        ])
    }
    
    func configure(title: String, posterURL: String?, year: String, genreId: [Int], genreList: [Genre]){
        
        var genreName : [String] = []
        movieTitle.text = title
        
        yearReleased.text = year.substring(to: 4)
        
        if let posterURL = posterURL {
            guard let CompleteURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)") else {return}
            self.moviePoster.sd_setImage(with: CompleteURL)
        }
        
        for data in genreList{
            if ((genreId.firstIndex(where: { $0 == data.id })) != nil){
                genreName.append(data.name)
            }
        }
        
        movieGenres.text = genreName.joined(separator: ", ")
        
    }

}
