//
//  ViewController.swift
//  ExampleApp
//
//  Created by Parth on 18/04/24.
//

import UIKit
import TouchEPlugin
class ViewController: UIViewController {

    @IBOutlet weak var dataTBL: UITableView!
    @IBOutlet weak var cartCountBTN: UIButtonX!
    var VideoListData : HomeData?
    var CartDataARY : CartData?
    public struct Identifiers {
        static let kMovieTBLCell = "MovieTBLCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConfigureTableView()
        GetMovieDetail()
        GetCartDataCount()
    }
    @IBAction func backAction_Click(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func ConfigureTableView(){
        dataTBL.delegate = self
        dataTBL.dataSource = self
        dataTBL.register(UINib(nibName: Identifiers.kMovieTBLCell, bundle: nil), forCellReuseIdentifier: Identifiers.kMovieTBLCell)
    }
    func GetMovieDetail(){
        TouchEPluginVC.shared.getMovieDetail { result in
            switch result {
            case .success(let homeData):
                self.VideoListData = homeData
                self.dataTBL.reloadData()
            case .failure(let error):
                self.ShowAlert1(title: "Error", message: "\(error.localizedDescription)")
            }
        }
    }
    func GetCartDataCount(){
        TouchEPluginVC.shared.getCartDataCount { result in
            switch result {
            case .success(let cartData):
                self.CartDataARY = cartData
                self.cartCountBTN.setTitle("\(self.CartDataARY?.count ?? 0)", for: .normal)
            case .failure(let error):
                self.ShowAlert1(title: "Error", message: "\(error.localizedDescription)")
            }
        }
    }
    
    @IBAction func profileAction_Click(_ sender: UIButton) {
        let viewcontroller = ProfileVC()
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    @IBAction func cartAction_Click(_ sender: Any) {
        let viewcontroller = MyCartVC()
        self.navigationController?.pushViewController(viewcontroller, animated: true)
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataTBL.dequeueReusableCell(withIdentifier: Identifiers.kMovieTBLCell, for: indexPath) as! MovieTBLCell
        cell.VideoList = VideoListData
        cell.titleLBL.text = "Movie(\(VideoListData?.count ?? 0))"
        cell.movieListCV.reloadData()
       
        cell.MovieClick = { (videoDic) -> Void in
            let viewcontroller = VideoDetailViewController()
            viewcontroller.modalPresentationStyle = .custom
            viewcontroller.VideoListData = videoDic
            self.navigationController?.pushViewController(viewcontroller, animated: true)

        }
        return cell
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 215
           
    }
    
}
