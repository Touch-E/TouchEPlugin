//
//  PaymentCardCell.swift
//  Touch E Demo
//
//  Created by Parth on 22/02/24.
//

import UIKit

class PaymentCardCell: UITableViewCell {

    @IBOutlet weak var cardListCV: UICollectionView!
    @IBOutlet weak var noPaymentLBL: UILabel!
    public struct Identifiers {
        static let kCardCVCell = "CardCVCell"
    }
    var cellExpand : (()->Void)?
    var cardListData : CardModel?
    var deleteCardActionM : ((Int)->Void)?
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
        cardListCV.delegate = self
        cardListCV.dataSource = self
        cardListCV.register(UINib(nibName: Identifiers.kCardCVCell, bundle: Bundle.module), forCellWithReuseIdentifier: Identifiers.kCardCVCell)
        
    }
    @IBAction func expandClick_Action(_ sender: UIButton) {
        if let action = cellExpand{
           action()
       }
    }
    func getInitialCollectionViewContentSize() -> CGSize {
        if let flowLayout = cardListCV.collectionViewLayout as? UICollectionViewFlowLayout {
            return flowLayout.collectionViewContentSize
        }
        return CGSize.zero
    }
    
}
extension PaymentCardCell : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  cardListData?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardListCV.dequeueReusableCell(withReuseIdentifier: Identifiers.kCardCVCell, for: indexPath) as! CardCVCell
        cell.makeDefaultUV.isHidden = true
        cell.deleteTitleLBL.text = "Delete"
        let dic = cardListData?[indexPath.row]
        if indexPath.row == 0{
            cell.makeDefaultUV.isHidden = true
            cell.sepraterLineUV.isHidden = false
            cell.deleteTitleLBL.text = "Delete"
            cell.topTitleLBL.text = "Default cards"
        }else if indexPath.row == 1{
            cell.makeDefaultUV.isHidden = false
            cell.sepraterLineUV.isHidden = true
            cell.deleteTitleLBL.text = ""
            cell.topTitleLBL.text = "Other cards"
        }else{
            cell.makeDefaultUV.isHidden = false
            cell.sepraterLineUV.isHidden = true
            cell.deleteTitleLBL.text = ""
            cell.topTitleLBL.text = ""
        }
        
        cell.cardNumberLBL.text = dic?.number ?? ""
        
        cell.deleteCardAction = {
            if let action = self.deleteCardActionM{
                action(indexPath.row)
            }
        }
        
        let dateString = dic?.expDate ?? "NA"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let previousDay = calendar.date(byAdding: .day, value: -1, to: date)
            let components = calendar.dateComponents([.year, .month], from: previousDay ?? Date())
            if let year = components.year, let month = components.month {
                let dateString1 = String(format: "%02d/%02d", month, year % 100)
                print(dateString1) // Output: 03/30
                cell.expLBL.text = dateString1
            }
        }
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cardListCV.layer.bounds.height / 1.5 , height: 300)
    }

}
