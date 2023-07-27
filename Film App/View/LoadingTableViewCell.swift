//
//  LoadingTableViewCell.swift
//  Film App
//
//  Created by William Yulio on 26/07/23.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
//    let loading = activityIndi

    static let identifier = "LoadingCell"
    let labelLoading = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.style()
        self.layout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func style(){
        labelLoading.translatesAutoresizingMaskIntoConstraints = false
        labelLoading.font = UIFont.Poppins(size: 16)
        labelLoading.textColor = .black
        labelLoading.numberOfLines = 2
    }
    
    func layout(){
        self.contentView.addSubview(labelLoading)
        
        NSLayoutConstraint.activate([
            
            labelLoading.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelLoading.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        ])
    }
    
    func configure(text: String){
        labelLoading.text = text
    }

}
