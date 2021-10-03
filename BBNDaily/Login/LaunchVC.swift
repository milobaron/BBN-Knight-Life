//
//  LaunchVC.swift
//  BBNDaily
//
//  Created by Mike Veson on 9/12/21.
//

import UIKit
import GoogleSignIn
import Firebase
import ProgressHUD
import InitialsImageView
import SafariServices
import FSCalendar
import WebKit


class LaunchVC: UIViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FirebaseAuth.Auth.auth().currentUser != nil {
            LoginVC.fullName = (FirebaseAuth.Auth.auth().currentUser?.displayName ?? "").replacingOccurrences(of: "**", with: "")
            LoginVC.email = FirebaseAuth.Auth.auth().currentUser?.email ?? ""
            LoginVC.phoneNum = FirebaseAuth.Auth.auth().currentUser?.phoneNumber ?? ""
            
            let db = Firestore.firestore()
            db.collection("special-schedules").getDocuments { (snapshot, error) in
                if error != nil {
                    ProgressHUD.showFailed("Failed to find 'special-schedules'")
                } else {
                    //                var isCreated = false
                    var newArray = [String: [block]]()
                    var reasonArray = [String: String]()
                    var newArray2 = [String: [block]]()
                    for document in (snapshot?.documents)! {
//                            documen
                        let arrayl1 = document.data()["blocks-l1"] as? [[String: String]] ?? [[String: String]]()
                        var blocksl1 = [block]()
                        for x in arrayl1 {
                            blocksl1.append(block(name: x["name"] ?? "", startTime: x["startTime"] ?? "", endTime: x["endTime"] ?? "", block: x["block"] ?? "", reminderTime: x["reminderTime"] ?? "", length: 0))
                        }
                        
                        let array = document.data()["blocks"] as? [[String: String]] ?? [[String: String]]()
                        var blocks = [block]()
                        for x in array {
                            blocks.append(block(name: x["name"] ?? "", startTime: x["startTime"] ?? "", endTime: x["endTime"] ?? "", block: x["block"] ?? "", reminderTime: x["reminderTime"] ?? "", length: 0))
                        }
                        let date = document.data()["date"] as? String ?? "N/A"
                        newArray[date] = blocks
                        newArray2[date] = blocksl1
                        reasonArray[date] = document.data()["reason"] as? String ?? "N/A"
                    }
                    LoginVC.specialDayReasons = reasonArray
                    LoginVC.specialSchedules = newArray
                    LoginVC.specialSchedulesL1 = newArray2
                    for x in LoginVC.specialSchedulesL1 {
                        if x.value.isEmpty {
                            LoginVC.specialSchedulesL1[x.key] = LoginVC.specialSchedules[x.key]
                        }
                    }
                }
            }
            db.collection("users").getDocuments { (snapshot, error) in
                if error != nil {
                    ProgressHUD.showFailed("Failed to find 'users'")
                } else {
                    for document in (snapshot?.documents)! {
                        if let id = document.data()["uid"] as? String {
                            if id == FirebaseAuth.Auth.auth().currentUser?.uid {
                                LoginVC.blocks = document.data()
                                if ((LoginVC.blocks["googlePhoto"] ?? "") as! String) == "true" {
                                    LoginVC.setProfileImage(useGoogle: true, width: UInt(self.view.frame.width), completion: {_ in
                                        
                                    })
                                }
                                else {
                                    LoginVC.setProfileImage(useGoogle: false, width: UInt(self.view.frame.width), completion: {_ in
                                    })
                                }
                                self.callTabBar()
                                return
                            }
                        }
                    }
                    self.callTabBar()
                }
            }
            
        }
        else {
            self.performSegue(withIdentifier: "NotSignedIn", sender: nil)
        }
    }
    func callTabBar() {
        self.performSegue(withIdentifier: "SignedIn", sender: nil)
    }
}
