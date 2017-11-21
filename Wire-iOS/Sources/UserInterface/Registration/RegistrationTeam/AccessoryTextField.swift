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

class AccessoryTextField : UITextField {
    static let enteredTextFont = FontSpec(.small, .regular, .inputText).font!
    static let placeholderFont = FontSpec(.small, .semibold).font!

    let confirmButton: IconButton = {
        let iconButton = IconButton.iconButtonCircularLight()

        iconButton.setIcon(UIApplication.isLeftToRightLayout ? .chevronRight : .chevronLeft, with: ZetaIconSize.actionButton, for: .normal) ///TODO: < 32? or .Medium?
        iconButton.setBackgroundImageColor(.activeButtonColor, for: .normal)
        iconButton.setBackgroundImageColor(.inactiveButtonColor, for: .disabled)

        iconButton.circular = true

        return iconButton
    }()

    let textInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 8)
    let placeholderInsets: UIEdgeInsets

    override init(frame: CGRect) {
        if Float(UIDevice.current.systemVersion) ?? 0.0 < 11.0 {
            // Placeholder frame calculation is changed in iOS 11, therefore the TOP inset is not necessary
            placeholderInsets = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        }
        else {
            placeholderInsets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let textRect = super.textRect(forBounds: bounds)

        return UIEdgeInsetsInsetRect(textRect, self.textInsets);
    }


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
    ///TODO: rightViewRectForBounds, leftViewRectForBounds
    ///TODO: paste. select
}


///TODO: delegate
///TODO: type: email, name....
///TODO: valid (ZMUser)
///TODO: snapshot test
