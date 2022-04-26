//
//  InitialVC.swift
//  Demo 1
//
//  Created by Demo MACBook Pro on 21/04/22.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import UIKit

class InitialVC: UIViewController {

    @IBOutlet weak var lblInformation: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupLayout()
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupLayout() {
        self.lblInformation.text = "Do it now. sometimes later becomes never".localized()
        self.btnLogin.setTitle("Login".localized(), for: [])
    }
    
    //MARK:- UIButton Action
    @IBAction func btnLoginTapped(_ sender: UIButton) {
        let vc = GlobalData.mainStoryBoard().instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
