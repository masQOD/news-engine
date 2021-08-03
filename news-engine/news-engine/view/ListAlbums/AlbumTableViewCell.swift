//
//  AlbumTableViewCell.swift
//  news-engine
//
//  Created by Qodir Masruri on 03/08/21.
//

import UIKit

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var photoImg: UIImageView!
    @IBOutlet weak var albumnameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
