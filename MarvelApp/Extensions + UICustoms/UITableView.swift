//
//  UITableView.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 01/03/2024.
//

import UIKit

protocol Reusable {
    static var identifier: String { get }
}

extension Reusable {
    static var identifier: String {
        return String(describing: self)
    }
}

extension UITableView {
    
    func registerNib<Cell: UITableViewCell>(cell: Cell.Type) {
        let nibName = Cell.identifier // String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell {
        let nibName = Cell.identifier
        guard let cell = self.dequeueReusableCell(withIdentifier: nibName) as? Cell else {
            fatalError("Error in cell")
        }
        return cell
    }
    
}

extension UITableViewCell: Reusable {}
