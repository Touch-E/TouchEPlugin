//
//  AttributeCell.swift
//  Touch E Demo
//
//  Created by Kishan on 12/02/24.
//

import UIKit

class AttributeCell: UITableViewCell {
    @IBOutlet weak var attributeTBL: UITableView!
    
    var attributeARY : [AttGroup]?
    var editAttribute : ((Int,Int) -> Void)?
    var selectedValuse = NSMutableArray()
    public struct Identifiers {
        static let kAttributeItemCell = "AttributeItemCell"
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ConfigureTableView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func ConfigureTableView(){
        
        attributeTBL.delegate = self
        attributeTBL.dataSource = self
        attributeTBL.register(UINib(nibName: Identifiers.kAttributeItemCell, bundle: Bundle.module), forCellReuseIdentifier: Identifiers.kAttributeItemCell)
        attributeTBL.separatorStyle = .none
       
    }
    
}
extension AttributeCell : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributeARY?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = attributeTBL.dequeueReusableCell(withIdentifier: Identifiers.kAttributeItemCell, for: indexPath) as! AttributeItemCell
        cell.selectionStyle = .none
        cell.itemNameLBL.text = "\(attributeARY?[indexPath.row].name ?? "") :"
        cell.stausSelected = attributeARY?[indexPath.row].values?[0].name ?? ""
        cell.attributeValueARY = attributeARY?[indexPath.row].values
        cell.Configurecollection()
        if "\(attributeARY?[indexPath.row].name ?? "")" == "Color " || "\(attributeARY?[indexPath.row].name ?? "")" == "Color"{
            cell.isColor = true
        }else{
            cell.isColor = false
        }
        cell.itemCV.reloadData()
        
        if indexPath.row == (attributeARY?.count ?? 0) - 1{
            cell.sepLineUV.isHidden = true
        }
        self.selectedValuse.add(attributeARY?[indexPath.row].values?[0].name ?? "")
        cell.attributeChangeIndex = { indexx in
            self.selectedValuse.replaceObject(at: indexPath.row, with: self.attributeARY?[indexPath.row].values?[indexx].name ?? "")
            if let action = self.editAttribute {
                action(indexPath.row, indexx)
            }
       }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
