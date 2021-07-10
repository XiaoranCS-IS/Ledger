//
//  AddGroupRecordTableViewCell.swift
//  LedgerApp
//
//  Created by 李笑然 on 2020/12/15.
//

import UIKit

class AddGroupRecordTableViewCell: UITableViewCell {
    var nameLabel: UILabel?
    @IBOutlet weak var selectSwitch: UISwitch!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        //ui
        self.nameLabel = UILabel(frame: CGRect(x: 100, y: 0, width: self.contentView.frame.width - 170, height: 60))
        self.nameLabel!.textColor = UIColor.black
        self.nameLabel!.font = UIFont.systemFont(ofSize: 24)
        self.nameLabel!.textAlignment = .left

//        self.selectSwitch = UISwitch(frame: CGRect(x: self.contentView.frame.width - 100, y: 15, width: 100, height: 60))
//        self.selectSwitch!.onTintColor = UIColor(red: 64/225, green: 61/225, blue: 114/225, alpha: 1)
        
        self.contentView.addSubview(self.nameLabel!)
//        self.contentView.addSubview(self.selectSwitch!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
