//
//  ChatUserListViewController.swift
//  ChatApp
//
//  Created by Monish Chaudhari on 18/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import UIKit
import Foundation

class ChatUserTableViewCell:UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messagePreviewLabel: UILabel!
    @IBOutlet weak var lastMessageDayLabel: UILabel!
    @IBOutlet weak var viewChatBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImageView.layer.cornerRadius = 25.0
    }
}

class ChatUserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Local variables
    var ConversationUsers = [ConversationUser]()
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        prepareDataSourceArray()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    //MARK:- Other Functions
    private func prepareDataSourceArray() {
        ConversationUsers.append(ConversationUser(firstName: "Monish", lastName: "Chaudhari"))
    }
    
    //MARK:- IBActions
    
    //MARK:- Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ConversationUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatUserTableViewCell") as! ChatUserTableViewCell
        let convUser = ConversationUsers[indexPath.row]
        cell.userNameLabel.text = (convUser.firstName ?? "") + " " + (convUser.lastName ?? "")
        cell.messagePreviewLabel.text = convUser.Messages.last?.text
        cell.lastMessageDayLabel.text = "Today"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "ConversationViewController") as! ConversationViewController
        chatVC.convUser = ConversationUsers[indexPath.row]
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}


extension Date {
    func convertDateToString(with outputFormat:String = "MM/dd/yyyy") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = outputFormat
        return  dateFormatter.string(from: self)
    }
}
