//
//  AddingMovieViewController.swift
//  Dolfin
//
//  Created by igor on 05.01.2021.
//

import Foundation
import UIKit

protocol DataEnteredDelegate: class {
    func userEnterInfo(info1: String, info2: String, info3: String)
}

class AddingMovieViewController: UIViewController, UITextFieldDelegate {
    weak var delegate: DataEnteredDelegate? = nil
    @IBOutlet weak var buttonAddMovie: UIButton!
    @IBOutlet weak var titleNewMovie: UITextField!
    @IBOutlet weak var typeNewMovie: UITextField!
    @IBOutlet weak var yearNewMovie: UITextField!
    
    @IBAction func buttonAddNewMovie(_ sender: Any) {
        delegate?.userEnterInfo(info1: titleNewMovie.text!, info2: typeNewMovie.text!, info3: yearNewMovie.text!)
        _ = self.navigationController?.popViewController(animated: true)
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonAddMovie.isEnabled = false
        titleNewMovie.delegate = self
        typeNewMovie.delegate = self
        yearNewMovie.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let title = titleNewMovie.text ?? ""
        let year = yearNewMovie.text ?? ""
        let type = typeNewMovie.text ?? ""
        buttonAddMovie.isEnabled = !title.isEmpty && !year.isEmpty && !type.isEmpty && Int(year) != nil
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
