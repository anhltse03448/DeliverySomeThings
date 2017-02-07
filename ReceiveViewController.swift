//
//  ReceiveViewController.swift
//  giaohangongvong
//
//  Created by Anh Tuan on 1/19/17.
//  Copyright © 2017 Anh Tuan. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReceiveViewController: UIViewController {
    let identifier = "ReceiveTableViewCell" ;
    let identifierTapped = "ReceiveTappedTableViewCell"
    var selectedIndexPaths = [IndexPath]()
    static let sharedInstance = ReceiveViewController()
    var listReceive = [ReceivePerson]()
    @IBOutlet weak var tbl : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.register(UINib.init(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        tbl.register(UINib.init(nibName: identifierTapped, bundle: nil), forCellReuseIdentifier: identifierTapped)
        tbl.isEditing = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let session = UserDefaults.standard.value(forKey: UtilsConvert.convertKeyDefault(keyDefault: KeyDefault.session))
        let sessionBase64 = (session as! String).toBase64()
        let param : [String : String] = ["session" : sessionBase64]
        var tmp = [ReceivePerson]()
        Alamofire.request("http://www.giaohangongvang.com/api/nhanvien/list-donhang-nhan", method: .post, parameters: param).responseJSON { (response) in
            let json = JSON(data: response.data!)
            let datas = json["detail"].arrayValue
            for item in datas {
                let rcPerson = ReceivePerson(json: item)
                tmp.append(rcPerson)
            }
            self.listReceive = tmp
            DispatchQueue.main.async {
                self.tbl.reloadData()
            }
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ReceiveViewController : UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell.lbl.text = "\(indexPath.row)"
        if selectedIndexPaths.contains(indexPath) {
            let cell = tbl.dequeueReusableCell(withIdentifier: identifierTapped, for: indexPath) as! ReceiveTappedTableViewCell
            cell.accessoryType = .none
            return cell
        } else {
            let cell = tbl.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ReceiveTableViewCell
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listReceive.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let smallHeight: CGFloat = 70.0
        let expandedHeight: CGFloat = 100.0
        if selectedIndexPaths.contains(indexPath) {
            return expandedHeight
        }
        return smallHeight
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedIndexPaths.contains(indexPath) {
            let index = selectedIndexPaths.index(of: indexPath)
            selectedIndexPaths.remove(at: index!)
        } else {
            selectedIndexPaths.append(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.none
    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        if (editing) {
//            for view in self.view.subviews as [UIView] {
//                //if type(of: view).description().rangeOfString("Reorder") != nil 
//                if view.description.range(of: "Reorder") != nil
//                {
//                    for subview in view.subviews as! [UIImageView] {
//                        //if subview.isKindOfClass(UIImageView) 
//                        if subview.isKind(of: UIImageView.self)
//                        {
//                            subview.image = UIImage(named: "image")
//                        }
//                    }
//                }
//            }
//        }
//    }
}
