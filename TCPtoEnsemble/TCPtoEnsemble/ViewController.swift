//
//  ViewController.swift
//  TCPtoEnsemble
//
//  Created by Nick Barton on 7/11/16.
//  Copyright © 2016 Nick Barton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK - Variables
    var connection = EnsembleConnection(ipAddress: "127.0.0.1", port: 8000)
    
    // MARK - Outlets
    @IBOutlet weak var ipaddressTF: UITextField!
    @IBOutlet weak var portTF: UITextField!
    @IBOutlet weak var ConnectionLabel: UILabel!
    
    // MARK - Actions    
    @IBAction func SendMessage(sender: UIButton){
        let message = sender.currentTitle!
        sendMessageTCP(message)
    }
    
    @IBAction func ConnectToEnsemble(sender: AnyObject) {
        if let ensIp = ipaddressTF.text, ensPort = Int(portTF.text!){
            connection.connect(ensIp,p: ensPort)
        }else{
            connection.connect("127.0.0.1",p: 8000)
        }
        checkConnection()
    }
    
    // MARK - System Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkConnection()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkConnection() {
            ConnectionLabel.backgroundColor = connection.checkConnection()
    }
    
    // MARK - TCP Functions
    func sendMessageTCP(fileName: String){
        if connection.connected {
            var text:String?
            let path = NSBundle.mainBundle().pathForResource(fileName, ofType: "txt")
            
            let fm = NSFileManager()
            let exists = fm.fileExistsAtPath(path!)
            if(exists){
                let c = fm.contentsAtPath(path!)
                let cString = NSString(data: c!, encoding: NSUTF8StringEncoding)
                text = cString as? String
                text = text!.stringByReplacingOccurrencesOfString("\n", withString: "\r")
                text = text!.stringByAppendingString("\r")
            } else {
                print("Message Not Sent -- No message found at file path")
            }
            if let string = text {
                let acks = connection.sendString(string)
                if connection.success {
                    print("\(fileName) Sent")
                    print("Received \(acks.count) ACKs")
                }else{
                    print("Message Not Sent -- Connection issue:\(connection.errmsg)")
                    checkConnection()
                }
            }else {
                print("Message Not Sent -- Failed to create message")
            }
        }else{
            print("No Connection")
        }
    }

}

