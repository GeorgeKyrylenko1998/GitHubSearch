//
//  GitCell.swift
//  GithubSearch
//
//  Created by George Kyrylenko on 31.08.2020.
//  Copyright © 2020 TestApp. All rights reserved.
//

import UIKit

class GitCell: UITableViewCell {

    @IBOutlet weak var repoNameLbl: UILabel!
    @IBOutlet weak var repoStarsLbl: UILabel!
    @IBOutlet weak var isWatchedRepo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCell()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCell(){
        isWatchedRepo.layer.cornerRadius = 3
    }
}
