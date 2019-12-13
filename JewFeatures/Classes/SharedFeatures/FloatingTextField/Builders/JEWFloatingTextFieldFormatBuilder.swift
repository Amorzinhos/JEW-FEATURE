//
//  JEWFloatingTextFieldDelegateBuilder.swift
//  JewFeatures
//
//  Created by Joao Gabriel Medeiros Perei on 23/11/19.
//

import Foundation

public class JEWFloatingTextFieldFormatBuilder: NSObject, JEWFloatingTextFieldBuilderProtocol {
    
    private var floatingTextField: JEWFloatingTextField
    public init(with floatingTextField: JEWFloatingTextField) {
        self.floatingTextField = floatingTextField
        super.init()
    }
    
    public func setAll(withPlaceholder placeholder: String) -> JEWFloatingTextFieldFormatBuilder {
        return setPlaceholder(text: placeholder)
            .setSelectedColor()
            .setTextFieldTextColor()
            .setSmallFont()
            .setBigFont()
            .setRequired()
            .setKeyboardType()
            .setTextFieldType()
            .setTextFieldValueType()
            .setTextFieldAutoCorrection()
            .setTextFieldKeyboardAppearance()
    }
    
    public func setPlaceholder(text: String = String()) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.placeholderLabel.text = text
        return self
    }
    
    public func setSelectedColor(color: UIColor = .JEWDefault()) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.selectedColor = color
        return self
    }
    
    public func setTextFieldTextColor(color: UIColor = .JEWBlack()) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.textFieldTextColor = color
        return self
    }
    
    public func setSmallFont(font: UIFont = .JEW11()) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.smallFont = font
        return self
    }
    
    public func setBigFont(font: UIFont = .JEW16()) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.bigFont = font
        return self
    }
    
    public func setRequired(isRequired: Bool = false) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.required = isRequired
        return self
    }
    
    public func setKeyboardType(type: UIKeyboardType = .default) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.textField.keyboardType = type
        return self
    }
    
    public func setTextFieldType(type: JEWFloatingTextFieldType? = nil) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.typeTextField = type
        return self
    }
    
    public func setTextFieldValueType(type: JEWFloatingTextFieldValueType? = nil) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.valueTypeTextField = type
        return self
    }
    
    public func setTextFieldAutoCorrection(isOn: UITextAutocorrectionType = .no) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.textField.autocorrectionType = isOn
        return self
    }
    
    public func setTextFieldKeyboardAppearance(appearance: UIKeyboardAppearance = .default) -> JEWFloatingTextFieldFormatBuilder {
        self.floatingTextField.textField.keyboardAppearance = appearance
        return self
    }
    
    
    public func setup() {
        if self.floatingTextField.required {
            floatingTextField.placeholderLabel.text = "\(floatingTextField.placeholderLabel.text ?? String())\(JEWFloatingTextField.requiredCharacter)"
        }
        
        if self.floatingTextField.textField.text != nil && self.floatingTextField.textField.text != String() {
            self.floatingTextField.openKeyboard()
        }
    }
    
}
