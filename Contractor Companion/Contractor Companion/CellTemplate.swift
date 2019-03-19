//
//  CellTemplate.swift
//  Contractor Companion
//
//  Created by CampusUser on 3/11/19.
//  Copyright © 2019 Yarrcad. All rights reserved.
//

import Foundation

import FoldingCell
import UIKit

class CellTemplate: FoldingCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var opentitleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var closeNumberLabel: UILabel!
    @IBOutlet var openNumberLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var timeiLabel: UILabel!
    
    var counter = 0.0
    var timer = Timer()
    var isPlaying = false
    
    var number: Int = 0 {
        didSet {
            closeNumberLabel.text = "#" + String(number + 1)
            openNumberLabel.text = "#" + String(number + 1)
        }
    }
    
    var title: String = "Title"{
        didSet {
            titleLabel.text = title
            opentitleLabel.text = title
        }
    }
    
    var date: String = "Date"{
        didSet {
            dateLabel.text = date
        }
    }
    
    var desc: String = "Description"{
        didSet {
            descriptionLabel.text = desc
        }
    }
    
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        super.awakeFromNib()
    }
    
    override func animationDuration(_ itemIndex: NSInteger, type _: FoldingCell.AnimationType) -> TimeInterval {
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }
    
    @IBAction func resetTimer(_ sender: AnyObject) {
        
        timer.invalidate()
        isPlaying = false
        counter = 0.0
        timeLabel.text = String(counter)
    }
    
    @IBAction func cellReset(_ sender: UIButton) {
        sender.accessibilityIdentifier = String(number)
    }
    
    @objc func UpdateTimer() {
        counter = counter + 0.1
        timeLabel.text = String(format: "%.1f", counter)
        timeiLabel.text = String(format: "%.1f", counter)
    }
    
    @IBAction func ButtonClick(_ sender: UIButton){
        if(isPlaying) {
            timer.invalidate()
            isPlaying = false
        }
        else{
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTimer), userInfo: nil, repeats: true)
            isPlaying = true
        }
    }
}

// MARK: - Actions ⚡️

extension CellTemplate {
    
    @IBAction func buttonHandler(_: AnyObject) {
        print("tap")
    }
}
