//
//  TableViewCell.swift
//  AppDraft2
//
//  Created by Matthew Morris on 4/6/22.
//

import UIKit

class TableViewCell: UITableViewCell {
    var titleLbl: UILabel!
    var dateLbl: UILabel!
    var checkMark: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLbl = UILabel()
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
//        titleLbl.textColor = UIColor(white: 0.95, alpha: 1)
        titleLbl.textColor = .black
        titleLbl.font = .systemFont(ofSize: 24, weight: .medium)
        titleLbl.font = UIFont(name: "Arial", size: 24)
        
        dateLbl = UILabel()
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        dateLbl.textColor = .darkGray
        dateLbl.font = .systemFont(ofSize: 12)
        
        contentView.addSubview(titleLbl)
        contentView.addSubview(dateLbl)
        
        let viewsDict = [
            "title": titleLbl,
            "date": dateLbl
        ]
        
        for view in viewsDict.keys {
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[\(view)]-|", options: [], metrics: nil, views: viewsDict as [String : Any]))
        }
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title][date]-|", options: [], metrics: nil, views: viewsDict as [String : Any]))
        
    }
    
    func setUp(goal: Goal) {
        titleLbl.text = goal.title
        dateLbl.text = "Complete by: \(goal.date.formatted(date: .abbreviated, time: .omitted))"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
