//
//  SymbolTableViewCell.swift
//  Forex
//
//  Created by Shabab Rahman on 3/9/19.
//  Copyright © 2019 Shabab Rahman. All rights reserved.
//

import UIKit

protocol SymbolTableViewCellDelegate: class {
    func symbolTableViewCellValueDidChange(_ cell: SymbolTableViewCell)
    }

class SymbolTableViewCell: UITableViewCell {
    
    
    weak var delegate: SymbolTableViewCellDelegate?
    
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBAction func favoriteSwitchValueChanged(_ sender: UISwitch) {
        delegate?.symbolTableViewCellValueDidChange(self)
    }
    
    
}
