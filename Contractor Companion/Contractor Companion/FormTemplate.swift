//
//  FormTemplate.swift
//  Contractor Companion
//
//  Created by CampusUser on 3/12/19.
//  Copyright © 2019 Yarrcad. All rights reserved.
//

import Foundation
import SwiftEntryKit

struct TextFieldOptionSet: OptionSet {
    let rawValue: Int
    static let taskName = TextFieldOptionSet(rawValue: 1 << 0)
    static let date = TextFieldOptionSet(rawValue: 1 << 1)
    static let description = TextFieldOptionSet(rawValue: 1 << 2)
}

enum FormStyle {
    case light
    case dark
    
    var imageSuffix: String {
        switch self {
        case .dark:
            return "_light"
        case .light:
            return "_dark"
        }
    }
    
    var title: EKProperty.LabelStyle {
        let font = MainFont.medium.with(size: 16)
        switch self {
        case .dark:
            return .init(font: font, color: .white, alignment: .center)
        case .light:
            return .init(font: font, color: EKColor.Gray.a800, alignment: .center)
        }
    }
    
    var buttonTitle: EKProperty.LabelStyle {
        let font = MainFont.bold.with(size: 16)
        switch self {
        case .dark:
            return .init(font: font, color: .black)
        case .light:
            return .init(font: font, color: .white)
        }
    }
    
    var buttonBackground: UIColor {
        switch self {
        case .dark:
            return .white
        case .light:
            return .redish
        }
    }
    
    var placeholder: EKProperty.LabelStyle {
        let font = MainFont.light.with(size: 14)
        switch self {
        case .dark:
            return .init(font: font, color: UIColor(white: 0.8, alpha: 1))
        case .light:
            return .init(font: font, color: UIColor(white: 0.5, alpha: 1))
        }
    }
    
    var text: EKProperty.LabelStyle {
        let font = MainFont.light.with(size: 14)
        switch self {
        case .dark:
            return .init(font: font, color: .white)
        case .light:
            return .init(font: font, color: .black)
        }
    }
    
    var separator: UIColor {
        return .init(white: 0.8784, alpha: 0.6)
    }
}

class FormFieldPresetFactory {
    
    class func description(placeholderStyle: EKProperty.LabelStyle, textStyle: EKProperty.LabelStyle, separatorColor: UIColor, style: FormStyle) -> EKProperty.TextFieldContent {
        let descriptionPlaceholder = EKProperty.LabelContent(text: "Description", style: placeholderStyle)
        return .init(keyboardType: .emailAddress, placeholder: descriptionPlaceholder, textStyle: textStyle, leadingImage: UIImage(named: "ic_mail" + style.imageSuffix), bottomBorderColor: separatorColor)
    }
    
    class func taskName(placeholderStyle: EKProperty.LabelStyle, textStyle: EKProperty.LabelStyle, separatorColor: UIColor, style: FormStyle) -> EKProperty.TextFieldContent {
        let taskNamePlaceholder = EKProperty.LabelContent(text: "Task Name", style: placeholderStyle)
        return .init(keyboardType: .namePhonePad, placeholder: taskNamePlaceholder, textStyle: textStyle, leadingImage: UIImage(named: "ic_user" + style.imageSuffix), bottomBorderColor: separatorColor)
    }
    
    class func date(placeholderStyle: EKProperty.LabelStyle, textStyle: EKProperty.LabelStyle, separatorColor: UIColor, style: FormStyle) -> EKProperty.TextFieldContent {
        let datePlaceholder = EKProperty.LabelContent(text: "Creation Date", style: placeholderStyle)
        return .init(keyboardType: .decimalPad, placeholder: datePlaceholder, textStyle: textStyle, leadingImage: UIImage(named: "ic_phone" + style.imageSuffix), bottomBorderColor: separatorColor)
    }
    
    class func fields(by set: TextFieldOptionSet, style: FormStyle) -> [EKProperty.TextFieldContent] {
        var array: [EKProperty.TextFieldContent] = []
        let placeholderStyle = style.placeholder
        let textStyle = style.text
        let separatorColor = style.separator
        
        if set.contains(.taskName) {
            array.append(taskName(placeholderStyle: placeholderStyle, textStyle: textStyle, separatorColor: separatorColor, style: style))
        }
        if set.contains(.date) {
            array.append(date(placeholderStyle: placeholderStyle, textStyle: textStyle, separatorColor: separatorColor, style: style))
        }
        if set.contains(.description) {
            array.append(description(placeholderStyle: placeholderStyle, textStyle: textStyle, separatorColor: separatorColor, style: style))
        }
        return array
    }
}
