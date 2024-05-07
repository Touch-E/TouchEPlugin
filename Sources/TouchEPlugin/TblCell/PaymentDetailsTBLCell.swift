//
//  PaymentDetailsTBLCell.swift
//  
//
//  Created by Jaydip Godhani on 16/04/24.
//

import UIKit

class PaymentDetailsTBLCell: UITableViewCell, UITextFieldDelegate {
    
    
    @IBOutlet weak var paypalCheckImg: UIImageView!
    @IBOutlet weak var cardCheckImg: UIImageView!
    @IBOutlet weak var saveCardCheckImg: UIImageView!
    @IBOutlet weak var defultSaveCheckIMG: UIImageView!
    @IBOutlet weak var nameTF: UITextFieldX!
    @IBOutlet weak var cardNumberTF: CardNumberTextField!
    @IBOutlet weak var exDateTF: CardExpireDateTextField!
    @IBOutlet weak var cvvTF: UITextFieldX!
    @IBOutlet weak var saveCardUV: UIView!
    @IBOutlet weak var saveCardUVHeightCON: NSLayoutConstraint!
    @IBOutlet weak var cardNumberLBL: UILabel!
    @IBOutlet weak var expLBL: UILabel!
    
    var addCardClick : ((Int) -> Void)?
    var saveClike : (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardNumberTF.delegate = self
        nameTF.delegate = self
        exDateTF.delegate = self
        cvvTF.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func addCardClick_Action(_ sender: UIButton) {
        
        if sender.tag == 1{
            paypalCheckImg.image =  UIImage(named: "check-box-empty")
            cardCheckImg.image =  UIImage(named: "check-box")
            defultSaveCheckIMG.image =  UIImage(named: "check-box-empty")
            if let action = addCardClick{
                action(1)
            }
        }else if sender.tag == 0{
            paypalCheckImg.image =  UIImage(named: "check-box")
            cardCheckImg.image =  UIImage(named: "check-box-empty")
            defultSaveCheckIMG.image =  UIImage(named: "check-box-empty")
            if let action = addCardClick{
                action(0)
            }
        }else{
            paypalCheckImg.image =  UIImage(named: "check-box-empty")
            cardCheckImg.image =  UIImage(named: "check-box-empty")
            defultSaveCheckIMG.image =  UIImage(named: "check-box")
            if let action = addCardClick{
                action(2)
            }
        }
        
    }
    @IBAction func saveCardClick_Action(_ sender: UIButton) {
        if let action = saveClike{
            action()
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == cardNumberTF{
            cardNumber = cardNumberTF.text ?? "".replacingOccurrences(of: " ", with: "")
        }else if textField == nameTF{
            cardHolderName = nameTF.text ?? ""
        }else if textField == exDateTF{
            expDate = exDateTF.text ?? ""
        }else{
            cvv = cvvTF.text ?? ""
        }
    
    }
}



class CardNumberTextField: UITextField, UITextFieldDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        placeholder = "Card Number"
                attributedPlaceholder = NSAttributedString(string: "Card Number", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                borderStyle = .roundedRect
                textColor = .white
                keyboardType = .numberPad
                delegate = self
        
        backgroundColor = .clear
        
        addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            let formattedText = formatCardNumber(text)
            textField.text = formattedText
        }
    }
    
    private func formatCardNumber(_ text: String) -> String {
        var formattedText = text.replacingOccurrences(of: " ", with: "")
        formattedText = formattedText.replacingOccurrences(of: "\\W", with: "", options: .regularExpression)
        var result = ""
        let chunkSize = 4
        for index in 0..<formattedText.count {
            let currentIndex = formattedText.index(formattedText.startIndex, offsetBy: index)
            if index % chunkSize == 0 && index > 0 {
                result.append(" ")
            }
            result.append(formattedText[currentIndex])
        }
        return result
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 19
    }
}







class CardExpireDateTextField: UITextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        placeholder = "MM/YY"
                attributedPlaceholder = NSAttributedString(string: "MM/YY", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                borderStyle = .roundedRect
                textColor = .white
                keyboardType = .numberPad
        
        backgroundColor = .clear
        
        self.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        
        if text.count > 5 {
            textField.text = String(text.prefix(5))
        }
        
        if text.count == 2 && !text.contains("/") {
            textField.text?.append("/")
        }
    }
}
