//
//  MusicListFile.swift
//  HD Video Player
//
//  Created by iMac on 09/11/21.
//

import UIKit

class MusicListFile: UITableViewCell {

    @IBOutlet var Cellview: UIView!
    @IBOutlet var img: UIImageView!
    @IBOutlet var Musicfilelbl: UILabel!
    @IBOutlet var Musictimelbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
