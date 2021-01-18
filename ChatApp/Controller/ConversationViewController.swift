//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Monish Chaudhari on 18/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import UIKit
import Foundation

class SendMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 5.0
    }
}

class ReceivedMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backView.layer.cornerRadius = 5.0
    }
}

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var userFullNameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var lastSeenLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputBarView: UIView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var inputViewBottomInsent: NSLayoutConstraint!
    
    //MARK:- Local variables
    var convUser:ConversationUser?
    var originalFrame:CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        messageTextView.delegate = self
        userImageView.layer.cornerRadius = 15.0
        messageTextView.layer.cornerRadius = 5.0
        sendBtn.layer.cornerRadius = 17.5
        messageTextView.returnKeyType = .done
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(inputBarView.frame.origin.y)
        userFullNameLabel.text = (convUser?.firstName ?? "") + " " + (convUser?.lastName ?? "")
        lastSeenLabel.text = "Online"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        originalFrame = inputBarView.frame
    }
    
    //MARK:- Other Functions
    
    
    //MARK:- IBActions
    
    @IBAction func didTapBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didTapSendBtn(_ sender: UIButton) {
        print(#function)
        if messageTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return
        }
        
        messageTextView.resignFirstResponder()
        convUser?.Messages.append(Message(text: messageTextView.text!))
        tableView.insertRows(at: [IndexPath(row: (convUser!.Messages.count - 1), section: 0)], with: .automatic)
        messageTextView.text = ""
        if tableView.numberOfRows(inSection: 0) > 1 {
            tableView.scrollToRow(at: IndexPath(row: (convUser!.Messages.count-1), section: 0), at: .bottom, animated: true)
        }
        messageTextView.becomeFirstResponder()
    }
    
    //MARK:- Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convUser?.Messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msgData = convUser?.Messages[indexPath.row]
        if (indexPath.row % 2 == 0) {
            //Right
            let cell = tableView.dequeueReusableCell(withIdentifier: "SendMessageTableViewCell") as! SendMessageTableViewCell
            cell.messageLabel.text = msgData?.text
            cell.timestampLabel.text = msgData?.timestamp?.convertDateToString(with: "dd-MMM-yyyy hh:mm")
            return cell
        } else {
            //Left
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceivedMessageTableViewCell") as! ReceivedMessageTableViewCell
            cell.messageLabel.text = msgData?.text
            cell.timestampLabel.text = msgData?.timestamp?.convertDateToString(with: "dd-MMM-yyyy hh:mm")
            return cell
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            inputViewBottomInsent.constant = -(keyboardSize.height)
            print(inputViewBottomInsent.constant)
        }
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        inputViewBottomInsent.constant = 0
         print(inputViewBottomInsent.constant)
    }
    
}
