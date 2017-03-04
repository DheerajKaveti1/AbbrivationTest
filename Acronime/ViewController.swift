    //
//  ViewController.swift
//  Acronime
//
//  Created by Dheeraj Kaveti on 3/3/17.
//  Copyright © 2017 Dheeraj Kaveti. All rights reserved.
//

import UIKit
class ViewController: UIViewController,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource{
    let netowrk = NetworkClass()
    var hud: MBProgressHUD = MBProgressHUD()
    var abbreviationList = [AbbrevationObject]()
    
    @IBOutlet weak var lblNoResults: UILabel!
    @IBOutlet weak var sentLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    @IBOutlet weak var abbrevTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        self.hud.mode = MBProgressHUDMode.indeterminate
        self.hud.labelText = "Loading..."
        self.view.bringSubview(toFront: self.hud)
        self.hud.isHidden = true
        abbrevTableView.tableFooterView = UIView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

      //MARK:- USER ACTION DONE AND TEXT RETURN METHODS
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.characters.count)! > 0 {
            self.didTapOnDone(textField)
            textField.resignFirstResponder()
            return true
        }
        return false
    }
    
    
    @IBAction func didTapOnDone(_ sender: Any) {
        if inputTextField.text?.characters.count == 0 {
            let alert = UIAlertController(title: "Please enter a word", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel) { action in
                // perhaps use action.title here
            })
            self.present(alert, animated: true, completion: nil)
            return
        }
        shouHud()
        sentLabel.text = inputTextField.text!
        abbreviationList.removeAll()
        reloadTableData()
        netowrk.downloadData(arcType: .SF, parameter: (inputTextField.text?.uppercased())!,  success: {
            (jsonDict, response) in
            if jsonDict is NSArray{
                if (jsonDict as! NSArray).count > 0 {
                self.convertToDict(dict: (jsonDict as! NSArray)[0] as! NSDictionary)
                }
                DispatchQueue.main.async {
                    self.hideHud()
                }
            }
         
        }, failure: {(error) in
            print((error?.localizedDescription)! as String)
            DispatchQueue.main.async {
                self.hideHud()
            }
        })
    }
    
        //MARK:- Conversion METHODS
    
    func convertToDict(dict:NSDictionary){
        for (key,val)in dict{
            if key as! String == "lfs" {
                 if val is NSArray{
                    abbreviationList = getAbbrvList(val: val as! NSArray)
                }
            }
        }
    }
    

    func getAbbrvList(val:NSArray)->[AbbrevationObject]{
        var array = [AbbrevationObject]()
       
            for values in val  {
                let abb = AbbrevationObject()
                if values is NSDictionary{
                    for (key1,val1) in (values as! NSDictionary){
                        if key1 as! String == "lf"{
                            abb.longForm = val1 as! String
                        }
                        if key1 as! String == "freq"{
                            abb.freq = val1 as! Int
                        }
                        if key1 as! String == "since"{
                            abb.since = val1 as! Int
                        }
                        if key1 as! String == "vars"{
                            let some = getAbbrvList(val: val1 as! NSArray)
                            abb.longForms = some.map({$0.longForm})
                        }
                    }
                }
              array.append(abb)
            }
        
        return array
    }
    
    //MARK:- HUD METHODS

    func shouHud() {
       hud.isHidden = false
       reloadTableData()
    }
    func hideHud(){
        hud.isHidden = true
        reloadTableData()
    }
    
    func reloadTableData(){
        if abbreviationList.count > 0 {
            lblNoResults.isHidden = true
        }else{
            lblNoResults.isHidden = false
        }
        inputTextField.resignFirstResponder()
        abbrevTableView.reloadData()
    }
    
    //MARK:- TABLE VIEW METHODS
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return abbreviationList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AbbrevationCell", for: indexPath) as! AbbrevationCell
        cell.configureCell(obj: abbreviationList[indexPath.row])
        return cell
    }
}

