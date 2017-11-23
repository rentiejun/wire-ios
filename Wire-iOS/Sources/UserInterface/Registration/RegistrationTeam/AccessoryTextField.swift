//
// Wire
// Copyright (C) 2017 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//


import Foundation
import Cartography

class AccessoryTextField : UITextField {

    enum TextFieldType {
        case email
        case name
        case password
        case unknown
    }

    static let enteredTextFont = FontSpec(.normal, .regular, .inputText).font!
    static let placeholderFont = FontSpec(.small, .semibold).font!
    static private let ConfirmButtonWidth: CGFloat = 32

    var textFieldType: TextFieldType = .unknown

    let confirmButton: IconButton = {
        let iconButton = IconButton.iconButtonCircularLight()
        iconButton.frame.size = CGSize(width: AccessoryTextField.ConfirmButtonWidth, height: AccessoryTextField.ConfirmButtonWidth)
        iconButton.circular = true

        iconButton.setIcon(UIApplication.isLeftToRightLayout ? .chevronRight : .chevronLeft, with: ZetaIconSize.searchBar, for: .normal)
        iconButton.setIconColor(.textColor, for: .normal)
        iconButton.setIconColor(.textfieldColor, for: .disabled)

        iconButton.setBackgroundImageColor(.activeButtonColor, for: .normal)
        iconButton.setBackgroundImageColor(.inactiveButtonColor, for: .disabled)

        iconButton.accessibilityIdentifier = "AccessoryTextFieldConfirmButton"

        iconButton.isEnabled = false

        return iconButton
    }()

    let textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
    let placeholderInsets: UIEdgeInsets

    convenience init(frame: CGRect, textFieldType: TextFieldType? = .unknown) {
        self.init(frame: frame)

        if let textFieldType = textFieldType {
            self.textFieldType = textFieldType
        }
    }

    override init(frame: CGRect) {
        let os = ProcessInfo().operatingSystemVersion

        let leftInset: CGFloat = 16 + 8

        if os.majorVersion < 11 {
            // Placeholder frame calculation is changed in iOS 11, therefore the TOP inset is not necessary
            placeholderInsets = UIEdgeInsets(top: 8, left: leftInset, bottom: 0, right: 16)
        }
        else {
            placeholderInsets = UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: 16)
        }

        super.init(frame: frame)

        self.rightView = self.confirmButton;
        self.rightViewMode = .always;

        self.font = AccessoryTextField.enteredTextFont
        self.textColor = .textColor

        autocorrectionType = .no
        contentVerticalAlignment = .center
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            layer.cornerRadius = 4
        default:
            break
        }
        layer.masksToBounds = true
        backgroundColor = .textfieldColor

        ///TODO: blue blinking cursor

        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        createConstraints()

        self.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }

    func textFieldDidChange(textField: UITextField){
        if  let text = textField.text {
            confirmButton.isEnabled = text.count > 0
        }

    }
    private func createConstraints() {
        constrain(confirmButton) { confirmButton in
            confirmButton.width == confirmButton.height

            confirmButton.width == 32
        }
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let textRect = super.textRect(forBounds: bounds)

        return UIEdgeInsetsInsetRect(textRect, self.textInsets);
    }


    ///MARK:- placeholder
    func attributedPlaceholderString(placeholder: String) -> NSAttributedString {
        let attribute : [String : Any] = [NSForegroundColorAttributeName: UIColor.placeholderColor,
                                          NSFontAttributeName: AccessoryTextField.placeholderFont]
        return placeholder && attribute
    }

    override open var placeholder: String?  {
        set {
            if let newValue = newValue {
                attributedPlaceholder = attributedPlaceholderString(placeholder: newValue.uppercased())
            }
        }
        get {
            return super.placeholder
        }
    }

    override func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: UIEdgeInsetsInsetRect(rect, placeholderInsets))
    }

    ///MARK:- right accessory
    func rightAccessoryViewRect(forBounds bounds: CGRect, leftToRight: Bool) -> CGRect {
        var rightViewRect: CGRect
        let newY = bounds.origin.y + (bounds.size.height -  AccessoryTextField.ConfirmButtonWidth) / 2
        let xOffset: CGFloat = 16

        if leftToRight {
            rightViewRect = CGRect(x: CGFloat(bounds.maxX - AccessoryTextField.ConfirmButtonWidth - xOffset), y: newY, width: AccessoryTextField.ConfirmButtonWidth, height: AccessoryTextField.ConfirmButtonWidth)
        }
        else {
            rightViewRect = CGRect(x: bounds.origin.x + xOffset, y: newY, width: AccessoryTextField.ConfirmButtonWidth, height: AccessoryTextField.ConfirmButtonWidth)
        }

        return rightViewRect
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let leftToRight: Bool = UIApplication.isLeftToRightLayout
        if leftToRight {
            return rightAccessoryViewRect(forBounds: bounds, leftToRight: leftToRight)
        }
        else {
            return .zero
        }

    }

    ///TODO: leftViewRectForBounds
    ///TODO: paste. select
}
