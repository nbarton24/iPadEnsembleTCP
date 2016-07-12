//
//  EnsembleConnection.swift
//  TCPtoEnsemble
//
//  Created by Nick Barton on 7/11/16.
//  Copyright © 2016 Nick Barton. All rights reserved.
//

import Foundation
import UIKit

class EnsembleConnection {
    
    var tcp:TCPClient = TCPClient(addr: "127.0.0.1", port: 8000)
    var connected:Bool
    var success:Bool
    var errmsg:String
    
    init(ipAddress: String,port: Int) {
        tcp.addr = ipAddress
        tcp.port = port
        connected = false
        success = true
        errmsg = ""
    }
    
    func connect(ipAdd: String,p: Int) -> (Bool,String){
        
        tcp.addr = ipAdd
        tcp.port = p
        (success,errmsg) = tcp.connect(timeout: 10)
        if success {
            connected = true
            return (true,errmsg)
        }else{
            return (false,errmsg)
        }
    }
    
    func disconnect() -> (Bool,String){
        
        (success,errmsg) = tcp.close()
        if success {
            connected = false
            return (true,errmsg)
        }else {
            return (false,errmsg)
        }
    }
    
    func sendString(input: String) -> [String]{
        var acks:[String] = [String]()
        let occourances = input.componentsSeparatedByString("MSH")
        //print("There are \(occourances.count) messages")
        
        (success,errmsg) = tcp.send(str: input)
        var data = [UInt8]?()
        
        for _ in 2...occourances.count {
            data=tcp.read(1024*10,timeout:10)
            if data != nil {
                let str=String(bytes: data!, encoding: NSUTF8StringEncoding)
                acks.append(str!)
                continue
            }
        }
        
        return acks
    }
    
    func checkConnection()-> UIColor{
        if connected {
            return UIColor.greenColor()
        }else{
            return UIColor.redColor()
        }
    }
    
}