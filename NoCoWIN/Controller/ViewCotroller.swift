//
//  ViewCotroller.swift
//  NoCoWIN
//
//  Created by Prateek Pande on 17/05/21.
//

import UIKit
import Alamofire
import PPModalStatusHUD

class ViewController: UIViewController{
    
    @IBOutlet weak var otpField: UITextField!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var cowinnImageView: UIImageView!
    
    @IBOutlet weak var appointmentScrollView: UIScrollView!
    @IBOutlet weak var appointmentFilterStack: UIStackView!
    @IBOutlet weak var ageLimitSegment: UISegmentedControl!
    @IBOutlet weak var dosageSegment: UISegmentedControl!
    @IBOutlet weak var cityPicker: UIPickerView!
    
    private var hudView: PPModalStatusView!
    
    static let TOKEN_KEY = "TOKEN"
    private static let USER_PHONE_KEY = "USER_PHONE"
    
    private var txnId: String?
    private var otp: String?
    private var slots: Slots?
    private var appointmentFilter: AppointmnetFilter?
    
    private var currentAction: Actions!{
        didSet{
            updateUICompnents()
            performAction()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        hudView = PPModalStatusView(frame: self.view.frame)
        
        if !(UserDefaults.standard.string(forKey: ViewController.TOKEN_KEY) ?? "").isEmpty{
            currentAction = .USER_INPUT_REQUEST_CENTER
        }
        else{
            currentAction = .USER_INPUT_PHONE
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cowinnImageView.layer.cornerRadius = cowinnImageView.frame.height/2
        actionBtn.layer.cornerRadius = 10
        self.ageLimitSegment.setTitle(AgeLimit.getDisplay(age: AgeLimit.Eighteen), forSegmentAt: 0)
        self.ageLimitSegment.setTitle(AgeLimit.getDisplay(age: AgeLimit.FortyFive), forSegmentAt: 1)
        
        self.dosageSegment.setTitle(Dosage.getDisplay(dose: Dosage.First_Dose), forSegmentAt: 0)
        self.dosageSegment.setTitle(Dosage.getDisplay(dose: Dosage.Booster_Dose), forSegmentAt: 1)
        
        if currentAction == .VIEW_APPOINTMENTS{
            self.slots = nil
            self.appointmentFilter = nil
            self.currentAction = .USER_INPUT_REQUEST_CENTER
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    @IBAction func btnOnClick(_ sender: UIButton!) {
        
        switch currentAction {
        case .USER_INPUT_PHONE:
            UserDefaults.standard.setValue(otpField.text, forKey: ViewController.USER_PHONE_KEY)
            currentAction = .USER_INPUT_OTP
        case .USER_INPUT_OTP:
            otp = otpField.text!
            currentAction = .GENERATE_TOKEN
        case .USER_INPUT_REQUEST_CENTER:
            currentAction = .REQUEST_CENTRE
        default:
            print("Invalid action : %s", currentAction)
        }
    }
    
    func updateUICompnents(){
        
        if currentAction == .USER_INPUT_OTP{
            otpField.textContentType = .oneTimeCode
        }
        else{
            otpField.textContentType = .telephoneNumber
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIView.AnimationOptions.curveEaseIn) {
            
            self.actionBtn.isEnabled = Actions.isUserInputRequired(_for: self.currentAction)
            self.actionBtn.setTitle(Actions.getActionName(_for: self.currentAction), for: .normal)
            
            self.otpField.placeholder = Actions.getFieldPlaceholder(_for: self.currentAction)
            self.otpField.isEnabled = self.actionBtn.isEnabled
            
            self.otpField.isHidden = !Actions.isUserInputRequired(_for: self.currentAction)
            
            if(self.currentAction == .USER_INPUT_REQUEST_CENTER){
                self.otpField.isHidden = true
                self.appointmentFilterStack.isHidden = false
            }
            else{
                self.appointmentFilterStack.isHidden = true
            }
            
        } completion: { _ in
            
        }

    }
    
    func performAction(){
        
        switch currentAction {
        case .USER_INPUT_PHONE:
            clearFields()
            if let phone = UserDefaults.standard.string(forKey: ViewController.USER_PHONE_KEY){
                self.otpField.text = phone
            }
        case .USER_INPUT_OTP:
            clearFields()
            if let phone = UserDefaults.standard.string(forKey: ViewController.USER_PHONE_KEY), !phone.isEmpty{
                requestOTP(number: phone)
            }
            else{
                currentAction = .USER_INPUT_PHONE
            }
            break
        case .GENERATE_TOKEN:
            if let tx = txnId, let otp = self.otp{
                getToken(txnId: tx, otp: otp)
            }
            else{
                currentAction = .USER_INPUT_OTP
            }
            clearFields()
        case .USER_INPUT_REQUEST_CENTER:
            break
        case .REQUEST_CENTRE:
            self.appointmentFilter = AppointmnetFilter(ageLimit: AgeLimit.allCases[ageLimitSegment.selectedSegmentIndex], dosage: Dosage.allCases[dosageSegment.selectedSegmentIndex])
            getCenters()
        case .VIEW_APPOINTMENTS:
            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            if #available(iOS 13.0, *) {
                if let appointmentVC = mainStoryboard.instantiateViewController(identifier: "appointmentVC") as? AppointmentsViewController{
                    appointmentVC.slots = self.slots
                    appointmentVC.filter = self.appointmentFilter
                    self.navigationController?.pushViewController(appointmentVC, animated: true)
                }
            } else {
                if let appointmentVC = mainStoryboard.instantiateViewController(withIdentifier: "appointmentVC") as? AppointmentsViewController{
                    appointmentVC.slots = self.slots
                    appointmentVC.filter = self.appointmentFilter
                    self.navigationController?.pushViewController(appointmentVC, animated: true)
                }
            }
        default:
            print("Invalid action performAction() : %s", currentAction)
        }
    }
    
    private func clearFields(){
        txnId = ""
        otp = ""
        otpField.text = ""
    }
    
    /*
     * Request OTP and return trasaction Id
     */
    func requestOTP(number: String){
        
        let params: Parameters = ["mobile": number]
        
        presentHUD(message: "Requesting OTP", image: UIImage(named: "success"))
        
        NetworkHelper.fetchRequest(endpoint: URLHelper.GENERATE_OTP, requestParams: params) { resp in
            
            if let response = resp?.data{
                // success
                print(response)
                
                let token = try? JSONDecoder().decode(Token.self, from: response)
                
                self.txnId = token?.txnId
                
                print("txnId: "+(self.txnId ?? ""))
            }
            else{
                self.presentHUD(message: "OTP generation request failed", image: UIImage(named: "fail"))
                print("OTP generation request failed")
                print(resp?.error)
                self.currentAction = Actions.USER_INPUT_PHONE
            }
        }
    }
    
    
    func getToken(txnId: String, otp: String){
        
        let otpHash: String = otp.sha256()
        
        if otpHash.isEmpty || txnId.isEmpty{
            print("Missing information otpHash: " + otpHash + " ; txnId: " + txnId)
            currentAction = Actions.USER_INPUT_PHONE
            return
        }
        
        let params: Parameters = ["otp": otpHash,
                                  "txnId": txnId]
        
        print(params)
        
        presentHUD(message: "Authenticating", image: UIImage(named: "success"))
        
        NetworkHelper.fetchRequest(endpoint: URLHelper.VALIDATE_OTP, requestParams: params) { (resp) in
            
            if let response = resp?.data{
                // success
                print(response)
                
                if let token = try? JSONDecoder().decode(Token.self, from: response){
                
                    UserDefaults.standard.setValue(token.token, forKey: ViewController.TOKEN_KEY)
                    
                    print("token: " + (token.token ?? ""))
                    
                    self.currentAction = Actions.USER_INPUT_REQUEST_CENTER
                }
            }
            else{
                self.presentHUD(message: "authentication failed", image: UIImage(named: "fail"))
                print("token generation failed")
                print(resp?.error)
                self.currentAction = Actions.USER_INPUT_OTP
            }
        }
    }
    
    func getCenters(){
        
        if let token = UserDefaults.standard.string(forKey: ViewController.TOKEN_KEY), !token.isEmpty{
            
            print("token: "+token)
            
            let dist = Districts.allCases[cityPicker.selectedRow(inComponent: 0)]
            
            let params: RequestParams = [URLQueryItem(name: "district_id", value: String(Districts.getDistrictId(district: dist))),
                                         URLQueryItem(name: "date", value: Utils.getDateAsString())]
            
            presentHUD(message: "Requesting Centers", image: UIImage(named: "success"))
            
            NetworkHelper.fetchRequest(endpoint: URLHelper.SLOTS_BY_CALENNDAR, queryParam: params) { response in
                
                if let data = response?.data{
                    if let slots = try? JSONDecoder().decode(Slots.self, from: data){
                        print(slots)
                        self.slots = slots
                        self.currentAction = .VIEW_APPOINTMENTS
                    }
                }
                else{
                    print("fetching centers failed")
                    print(response?.error)
                    
                    self.currentAction = Actions.USER_INPUT_PHONE
                }
            }
        }
        else if let phone = UserDefaults.standard.string(forKey: ViewController.USER_PHONE_KEY), !phone.isEmpty{
            currentAction = .USER_INPUT_OTP
        }
        else{
            currentAction = .USER_INPUT_PHONE
        }
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    private func presentHUD(message: String, image: UIImage?){
        hudView.set(image: image, headerText: message, descriptionText: nil)
        view.addSubview(hudView)
    }
}

extension ViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Districts.allCases.count
    }
}

extension ViewController: UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Districts.getDisplayName(district: Districts.allCases[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        self.selectedDistrict = Districts.allCases[row]
    }
}
