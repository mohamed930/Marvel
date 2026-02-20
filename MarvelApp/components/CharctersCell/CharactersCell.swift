//
//  CharactersCell.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import UIKit
import SkeletonView

class CharactersCell: UITableViewCell {
    
    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var characterTitleLabel: UILabel!
    @IBOutlet weak var characterDescribtionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Avoid showing XIB placeholder text before binding real data.
        characterTitleLabel.text = nil
        characterDescribtionLabel.text = nil
        characterImageView.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        characterTitleLabel.text = nil
        characterDescribtionLabel.text = nil
        characterImageView.image = nil
    }
    
    func configureCell(_ model: CharacterEntity) {
        hideSkeleton()
        
        characterTitleLabel.text       = model.name
        characterDescribtionLabel.text = model.description
        
        characterImageView.loadImageFromServer(model.thumbnailURL)
    }
    
    func showSkeleton() {
        // Use animated skeleton for a polished look
        characterImageView.showAnimatedGradientSkeleton()
        characterTitleLabel.showAnimatedGradientSkeleton()
        characterDescribtionLabel.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeleton() {
        characterImageView.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.2))
        characterTitleLabel.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.2))
        characterDescribtionLabel.hideSkeleton(reloadDataAfter: false, transition: .crossDissolve(0.2))
    }
    
}
