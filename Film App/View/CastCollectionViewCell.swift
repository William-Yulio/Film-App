//
//  CastCollectionViewCell.swift
//  Film App
//
//  Created by William Yulio on 27/07/23.
//

import UIKit
import SDWebImage

class CastCollectionViewCell: UICollectionViewCell {
    static let identifier = "CastCollectionCell"
    let castName = UILabel()
    let castProfile = UIImageView()
    let stackView = UIStackView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func style(){
        
        castProfile.translatesAutoresizingMaskIntoConstraints = false
        castProfile.layer.masksToBounds = false
        castProfile.layer.cornerRadius = 200 / 2
        castProfile.clipsToBounds = true
        
        castName.translatesAutoresizingMaskIntoConstraints = false
        castName.font = UIFont.Poppins(size: 16)
        castName.textColor = .black
        castName.numberOfLines = 2
        
    }
    
    func layout() {

        contentView.addSubview(castProfile)
        contentView.addSubview(castName)

        
        NSLayoutConstraint.activate([
            
            castProfile.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            castProfile.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            castProfile.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            castProfile.widthAnchor.constraint(equalToConstant: 200),
            castProfile.heightAnchor.constraint(equalToConstant: 200),
            
            castName.topAnchor.constraint(equalTo: castProfile.bottomAnchor, constant: 20),
            castName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

        ])
    }
    func configure(profileURL: String?, cast: String){
        
        castName.text = cast
        
        if let profileURL = profileURL {
            guard let CompleteURL = URL(string: "https://image.tmdb.org/t/p/w500/\(profileURL)") else {return}
            self.castProfile.sd_setImage(with: CompleteURL)
        }
        
    }
    
}

