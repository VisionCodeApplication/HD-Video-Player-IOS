//
//  VideoListCell.swift
//  HD Video Player
//
//  Created by iMac on 09/11/21.
//

import UIKit

class VideoListCell: UITableViewCell {

    
    @IBOutlet var filelbl: UILabel!
    @IBOutlet var countlbl: UILabel!
    @IBOutlet var Cellview: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
