//
//  MessageCell.swift
//  Firechat
//
//  Created by Nikita Nesporov on 05.04.2022.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCellViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupCellViews() { 
        messageView.layer.cornerRadius = messageView.frame.size.height / 5
        messageLabel.numberOfLines = 0 
    }
}
