//
//  CharactersViewController.swift
//  MarvelApp
//
//  Created by Mohamed Ali on 19/02/2026.
//

import UIKit
import Combine

class CharactersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingMoreView: UIView!
    @IBOutlet weak var loadingIndecator: UIActivityIndicatorView!
    
    var viewmodel: CharactersViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewmodel: CharactersViewModel) {
        self.viewmodel = viewmodel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        registerTableView()
        
        subscribeToCharacterPublisher()
        subscribeToErrorPublisher()
        subscribeToPagaignLoadingBehaviour()
        
        fetchCharacters()
    }
    
    func configureUI() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func registerTableView() {
        tableView.registerNib(cell: CharactersCell.self)
    }
    
    func subscribeToCharacterPublisher() {
        viewmodel.charactersObservable.sink(receiveValue: { [weak self] _ in
            guard let self = self else { return }
            
            self.tableView.reloadData()
        }).store(in: &cancellables)
    }
    
    func subscribeToErrorPublisher() {
        viewmodel.errorMessagePublisher.sink(receiveValue: { [weak self] str in
            guard let self = self else { return }
            
            guard let str else { return }
            
            self.showAlert(title: "Error", describition: str)
            
        }).store(in: &cancellables)
    }
    
    func subscribeToPagaignLoadingBehaviour() {
        viewmodel.pagaignLoadingBehaviour.sink(receiveValue: { [weak self] isloading in
            guard let self = self else { return }
            
            loadingMoreView.isHidden = !isloading
            isloading ? loadingIndecator.startAnimating() : loadingIndecator.stopAnimating()
            
        }).store(in: &cancellables)
    }
    
    func fetchCharacters() {
        viewmodel.fetchCharacters()
    }
}


extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewmodel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CharactersCell = tableView.dequeue() as CharactersCell
        
        cell.configureCell(viewmodel.characters[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewmodel.moveToCharacterDetails(index: indexPath.row)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !viewmodel.pagaignLoadingBehaviour.value else { return }

        guard let tableView = scrollView as? UITableView else { return }

        let visibleRows = tableView.indexPathsForVisibleRows ?? []
        guard let lastVisible = visibleRows.max() else { return }

        let totalRows = viewmodel.characters.count // مهم

        // Trigger قبل النهاية بـ 3 عناصر (أفضل UX)
        if lastVisible.row >= totalRows - 3 {
            viewmodel.fetchNextPageOperation()
        }
    }
}
