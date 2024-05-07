//
//  PersonalinformationTBLCell.swift
//  
//
//  Created by Jaydip Godhani on 16/04/24.
//

import UIKit

class PersonalinformationTBLCell: UITableViewCell {

    @IBOutlet weak var txtFirstName: UITextFieldX!
    @IBOutlet weak var txtSecoundName: UITextFieldX!
    @IBOutlet weak var txtEmail: UITextFieldX!
    @IBOutlet weak var txtMobileNumber: UITextFieldX!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       fillData()
    }
    
    func fillData(){
        txtFirstName.text = "\(profileData.value(forKey: "firstName") ?? "NA")"
        txtSecoundName.text = "\(profileData.value(forKey: "lastName") ?? "NA")"
        txtEmail.text = "\(profileData.value(forKey: "emailAddress")!)"
        txtMobileNumber.text = "\(profileData.value(forKey: "phoneNumber") ?? "NA")"
    }
}
