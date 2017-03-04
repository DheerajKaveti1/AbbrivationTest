//
//  AbbrevationCellTableViewCell.swift
//  Acronime
//
//  Created by Dheeraj Kaveti on 3/3/17.
//  Copyright © 2017 Dheeraj Kaveti. All rights reserved.
//

import UIKit

class AbbrevationCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblOtherTitles: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(obj:AbbrevationObject){
       
        lblTitle.text = obj.longForm
        if obj.longForms.count > 0 {
            lblOtherTitles.text =
                "Other Titles: "+obj.longForms.joined(separator: " , ")
            
        }else{
            lblOtherTitles.text = ""
        }
        
        if obj.freq > 0  && obj.since > 0 {
            lblDesc.text = "Frequency :" + String(obj.freq) + " , " + "Since :"+String(obj.since)
        }else{
            lblDesc.text = ""
        }
    }

}
