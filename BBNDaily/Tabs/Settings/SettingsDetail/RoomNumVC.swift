//
//  RoomNumVC.swift
//  BBNDaily
//
//  Created by Mike Veson on 7/22/22.
//

import Foundation
import UIKit
import ProgressHUD

class RoomNumVC: TextFieldVC {
    @IBOutlet weak var TextField: UITextField!
    static var link: ClassesOptionsPopupVC!
    @IBAction func pressed(_ sender: Any) {
        guard var text = TextField.text, text.trimmingCharacters(in: .whitespacesAndNewlines) != "", !text.contains("~"), !text.contains("/") else {
            ProgressHUD.colorAnimation = .red
            ProgressHUD.showFailed("Please complete fields! (Don't use any ~ or /)")
            return
        }
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
        ClassesOptionsPopupVC.newClass.Room = text
        self.performSegue(withIdentifier: "days", sender: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        TextField.resignFirstResponder()
        dismissKeyboard()
        return true
    }
    func hideKeyboardWhenTappedAbove() {
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.location(in: view).y > TextField.frame.origin.y && touch.location(in: view).y < TextField.frame.maxY {
            return false
        }
        view.unbindToKeyboard()
        view.endEditing(true)
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAbove()
        maxLength = 25
        TextField.delegate = self
        TextField.text = ClassesOptionsPopupVC.newClass.Room
    }
}