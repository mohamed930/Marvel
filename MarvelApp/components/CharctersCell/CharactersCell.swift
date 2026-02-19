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
        // Initialization code
        
        showSkeleton()
    }
    
    func configureCell(_ model: CharacterEntity) {
        characterTitleLabel.text       = model.name
        characterDescribtionLabel.text = model.description
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            characterImageView.loadImageFromServer(model.thumbnailURL)
            
            hideSkeleton()
        }
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
