//
//  FirstViewController.swift
//  Contractor Companion
//
//  Created by CampusUser on 3/11/19.
//  Copyright © 2019 Yarrcad. All rights reserved.
//

import SwiftEntryKit
import FoldingCell
import UIKit

class TaskTableViewController: UITableViewController {
    
    private var roundButton = UIButton()
    private var Data: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 100)
    private var  rowsCount = 0
    
    enum Const {
        static let closeCellHeight: CGFloat = 179
        static let openCellHeight: CGFloat = 488
        //static let rowsCount = 10
    }
    
    override func viewWillAppear(_ animated: Bool){
        createFloatingButton()
    }
    
    override func viewWillDisappear(_ animated: Bool){
        roundButton.removeFromSuperview()
    }
    
    var cellHeights: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func createFloatingButton() {
        roundButton = UIButton(type: .custom)
        roundButton.translatesAutoresizingMaskIntoConstraints = false
        roundButton.backgroundColor = .white
        roundButton.setImage(UIImage(named:"AddButton"), for: .normal)
        roundButton.addTarget(self, action: #selector(ButtonClick(_:)), for: UIControl.Event.touchUpInside)
        // We're manipulating the UI, must be on the main thread:
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(self.roundButton)
                NSLayoutConstraint.activate([
                    keyWindow.trailingAnchor.constraint(equalTo: self.roundButton.trailingAnchor, constant: 15),
                    keyWindow.bottomAnchor.constraint(equalTo: self.roundButton.bottomAnchor, constant: 100),
                    self.roundButton.widthAnchor.constraint(equalToConstant: 75),
                    self.roundButton.heightAnchor.constraint(equalToConstant: 75)])
            }
            self.roundButton.layer.cornerRadius = 37.5
            self.roundButton.layer.shadowColor = UIColor.black.cgColor
            self.roundButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            self.roundButton.layer.masksToBounds = false
            self.roundButton.layer.shadowRadius = 2.0
            self.roundButton.layer.shadowOpacity = 0.5
            let scaleAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            scaleAnimation.duration = 0.8
            scaleAnimation.repeatCount = .greatestFiniteMagnitude
            scaleAnimation.autoreverses = true
            scaleAnimation.fromValue = 1.0;
            scaleAnimation.toValue = 1.05;
            self.roundButton.layer.add(scaleAnimation, forKey: "scale")
        }
    }
    
    @IBAction func ButtonClick(_ sender: UIButton){
        showSignupForm(loc: rowsCount, anoth: true)
    }

    
    private func showSignupForm(loc: Int, anoth: Bool) {
        var style: FormStyle
        style = .dark
        var attributes: EKAttributes
        attributes = .float
        attributes.windowLevel = .normal
        attributes.position = .center
        attributes.displayDuration = .infinity
        
        attributes.entranceAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .top,  spring: .init(damping: 1, initialVelocity: 0)))
        attributes.exitAnimation = .init(translate: .init(duration: 0.65, anchorPosition: .top, spring: .init(damping: 1, initialVelocity: 0)))
        attributes.popBehavior = .animated(animation: .init(translate: .init(duration: 0.65, spring: .init(damping: 1, initialVelocity: 0))))
        
        attributes.entryInteraction = .absorbTouches
        attributes.screenInteraction = .dismiss
        
        attributes.entryBackground = .gradient(gradient: .init(colors: [EKColor.Netflix.light, EKColor.Netflix.dark], startPoint: .zero, endPoint: CGPoint(x: 1, y: 1)))
        attributes.screenBackground = .color(color: .dimmedDarkBackground)
        
        attributes.border = .value(color: UIColor(white: 0.6, alpha: 1), width: 1)
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 3))
        attributes.scroll = .enabled(swipeable: false, pullbackAnimation: .jolt)
        attributes.statusBar = .light
        
        attributes.positionConstraints.keyboardRelation = .bind(offset: .init(bottom: 15, screenEdgeResistance: 0))
        attributes.positionConstraints.maxSize = .init(width: .constant(value: UIScreen.main.minEdge), height: .intrinsic)
        
        let title = EKProperty.LabelContent(text: "Create a Task", style: style.title)
        let textFields = FormFieldPresetFactory.fields(by: [.taskName, .date, .description], style: style)
        let button = EKProperty.ButtonContent(label: .init(text: "Save", style: style.buttonTitle), backgroundColor: style.buttonBackground, highlightedBackgroundColor: style.buttonBackground.withAlphaComponent(0.8)) {
            self.Data[loc][0] = textFields[0].textContent
            self.Data[loc][1] = textFields[1].textContent
            self.Data[loc][2] = textFields[2].textContent
            if (anoth){
            self.rowsCount += 1
            self.setup()
            }
            self.refreshHandler()
            SwiftEntryKit.dismiss()
        }
        let contentView = EKFormMessageView(with: title, textFieldsContent: textFields, buttonContent: button)
        attributes.lifecycleEvents.didAppear = {
            contentView.becomeFirstResponder(with: 0)
        }
        SwiftEntryKit.display(entry: contentView, using: attributes, presentInsideKeyWindow: true)
    }
    
    private func setup() {
        cellHeights = Array(repeating: Const.closeCellHeight, count: rowsCount)
        tableView.estimatedRowHeight = Const.closeCellHeight
        tableView.rowHeight = UITableView.automaticDimension
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        if #available(iOS 10.0, *) {
            tableView.refreshControl = UIRefreshControl()
            tableView.refreshControl?.addTarget(self, action: #selector(refreshHandler), for: .valueChanged)
        }
    }
    
    @IBAction func cellReset(_ sender: UIButton) {
        showSignupForm(loc: Int(sender.accessibilityIdentifier!)!, anoth: false)
    }
    
    @objc func refreshHandler() {
        let deadlineTime = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: { [weak self] in
            if #available(iOS 10.0, *) {
                self?.tableView.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        })
    }
}

// MARK: - TableView

extension TaskTableViewController {
    
    override func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return rowsCount
    }
    
    override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as CellTemplate = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == Const.closeCellHeight {
            cell.unfold(false, animated: false, completion: nil)
        } else {
            cell.unfold(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
        cell.title = Data[indexPath.row][0]
        cell.date = Data[indexPath.row][1]
        cell.desc = Data[indexPath.row][2]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == Const.closeCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = Const.openCellHeight
            cell.unfold(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = Const.closeCellHeight
            cell.unfold(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
    }
}


