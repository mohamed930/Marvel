//
//  CharacterDetailsViewController.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 20/02/2026.
//

import UIKit
import SwiftUI

class CharacterDetailsViewController: UIViewController {
    
    @ObservedObject var viewmodel: CharacterDetailsViewModel
    
    init(viewmodel: CharacterDetailsViewModel) {
        self.viewmodel = viewmodel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addHosting(CharacterDetailsView(viewmodel: viewmodel))
    }
    
}
