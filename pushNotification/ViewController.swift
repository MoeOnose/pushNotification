//
//  ViewController.swift
//  pushNotification
//
//  Created by 小野瀬萌 on 2018/07/31.
//  Copyright © 2018年 小野瀬萌. All rights reserved.
//

import UIKit
//push通知できるライブラリ
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var text: UITextField!
    
    var result = ""
    let timerNotificationIdentifier = "Id1"
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        text.delegate = self
    }
    
    
    //enter押したときにkeyboard閉じるメソッド
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
 
        result = name.text! + text.text!
        
        //keyboardを閉じる
        //becomeFirstResponder()て閉じるんじゃなくて開けるんじゃ、、、、
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func startPush() {
        //5秒後にpush通知を送る
        //通知飛ばしていいかの許可
  
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if (settings.authorizationStatus == .authorized) {
                self.push()
            } else {
                UNUserNotificationCenter.current().requestAuthorization(options: [.sound,.badge, .alert], completionHandler: { (granted, error) in
                    if let errorMessage = error {
                        print(errorMessage)
                    } else {
                        //granted はtrueの扱い
                        if(granted){
                            self.push()
                        }
                    }
                })
            }
        }
    }
    //Hack: 名前わかりにくすぎる
    func push() {
        //通知にtextFieldにある文字列をセット
        let content = UNMutableNotificationContent()
        content.title = name.text!
        content.subtitle = text.text!
        //アイコンセット
        let timerIconURL = Bundle.main.url(forResource: "sunrise", withExtension: "jpg")!
        let attach = try! UNNotificationAttachment(identifier: timerNotificationIdentifier, url: timerIconURL, options: nil)
        
        content.attachments.append(attach)
        
        //5秒後に送信する
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: timerNotificationIdentifier, content: content, trigger: trigger)
        //if letはエラーがnilじゃなかったらってこと
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let errorMessage = error{
                print(errorMessage)
            } else {
                print("配信完了")
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func button(_ sender: Any) {
        startPush()
    }
    
}

