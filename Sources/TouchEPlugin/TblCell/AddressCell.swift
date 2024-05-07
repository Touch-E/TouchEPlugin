//
//  AddressCell.swift
//  Touch E Demo
//
//  Created by Parth on 21/02/24.
//

import UIKit

class AddressCell: UITableViewCell {

    @IBOutlet weak var addressCV: UICollectionView!
    public struct Identifiers {
        static let kAddressCVCell = "AddressCVCell"
    }
    var addressListData : AddressData?
    var cellExpand : (()->Void)?
    var addAddressAction : (()->Void)?
    var changeAddressAction : ((Int)->Void)?
    var deleteAddressAction : ((Int)->Void)?
    var editAddressAction : ((Int)->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        Configurecollection()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func Configurecollection(){
        addressCV.delegate = self
        addressCV.dataSource = self
        addressCV.register(UINib(nibName: Identifiers.kAddressCVCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kAddressCVCell)
        
    }
    @IBAction func cellExpandClick_Action(_ sender: UIButton) {
         if let action = cellExpand{
            action()
        }
    }
    @IBAction func addAddressClic_Action(_ sender: UIButton) {
        if let action = addAddressAction{
            action()
        }
    }
}
extension AddressCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  addressListData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = addressCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kAddressCVCell, for: indexPath) as! AddressCVCell
        cell.primaryUV.isHidden = true
        cell.onlyPrimaryUV.isHidden = true
        let dic = addressListData?[indexPath.row]
        if indexPath.row == 0{
            cell.sepraterLineUV.isHidden = false
            cell.deleteBTN.isHidden = true
            cell.primaryAdsLBL.text = "Primary address"
            cell.makePrimaryUV.isHidden = true
            if dic?.shippingAddress?.address ?? "" == dic?.billingAddress?.address ?? "" && dic?.shippingAddress?.zipcode ?? "" == dic?.billingAddress?.zipcode ?? "" && dic?.shippingAddress?.city ?? "" == dic?.billingAddress?.city ?? "" && dic?.shippingAddress?.country ?? "" == dic?.billingAddress?.country ?? ""{
                cell.primaryUV.isHidden = false
                cell.onlyPrimaryUV.isHidden = true
            }else{
                cell.primaryUV.isHidden = true
                cell.onlyPrimaryUV.isHidden = false
            }
        }else if indexPath.row == 1{
            cell.makePrimaryUV.isHidden = false
            cell.sepraterLineUV.isHidden = true
            cell.deleteBTN.isHidden = false
            cell.primaryAdsLBL.text = "Other shipping addresses"
        }else{
            cell.makePrimaryUV.isHidden = false
            cell.sepraterLineUV.isHidden = true
            cell.deleteBTN.isHidden = false
            cell.primaryAdsLBL.text = ""
        }
        
        cell.addressTypeLBL.text = dic?.name ?? ""
        cell.sAddressLBL.text = dic?.shippingAddress?.address ?? ""
        cell.sZipCodeLBL.text = dic?.shippingAddress?.zipcode ?? ""
        cell.sCityLBL.text = dic?.shippingAddress?.city ?? ""
        cell.sCountryLBL.text = dic?.shippingAddress?.country ?? ""
        
        cell.baddressLBL.text = dic?.billingAddress?.address ?? ""
        cell.bZipCodeLBL.text = dic?.billingAddress?.zipcode ?? ""
        cell.bCityLBL.text = dic?.billingAddress?.city ?? ""
        cell.bCountryLBL.text = dic?.billingAddress?.country ?? ""
        
        cell.makePrimaryAction = {
            //cell.selectionIMG.image = UIImage(named: "check-box") 
           if let action = self.changeAddressAction{
                action(indexPath.row)
            }
        }
        cell.deleteClickAction = {
            if let action = self.deleteAddressAction{
                action(indexPath.row)
            }
        }
        
        cell.editClickAction = {
            if let action = self.editAddressAction{
                action(indexPath.row)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: addressCV.layer.bounds.height / 1.5 , height: 335)
    }

}
