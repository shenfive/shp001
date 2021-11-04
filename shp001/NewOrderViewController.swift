//
//  NewOrderViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/30.
//

import UIKit
import Firebase

class NewOrderViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {


    @IBOutlet weak var orderDatePicker: UIDatePicker!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var selectMember: UIButton!
    @IBOutlet weak var discountPickerView: UIPickerView!
    @IBOutlet weak var paymentPickerView: UIPickerView!
    @IBOutlet weak var productNumber: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var uniPrice: UITextField!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var remarkTextField: UITextField!
    
    var disCountRate = 1.0
    
    var ref:DatabaseReference!
    var selectedSales:String? = nil
    var discountLavel:[String] = []
    var paymentArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "新增訂單"
        
        ref = Database.database().reference()
        discountPickerView.delegate = self
        discountPickerView.dataSource = self
        paymentPickerView.delegate = self
        paymentPickerView.dataSource = self
        
        selectMember.layer.cornerRadius = 16.5
        
        discountLavel = ["原價","九五折","九折","八五折","八折","七五折","七折","六五折","六折"]
        paymentArray = ["請選擇","現金","線上刷卡","店面刷卡","其他"]
        
    }
    
    @IBAction func selectMemberAction(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "introducerPickerViewController") as! IntroducerPickerViewController
        nextVC.setIntroduerAction = {
            self.selectedSales = $0
            self.salesLabel.text = "\($1)    \($0)"
            nextVC.dismiss(animated: true) {
            }
        }
        present(nextVC, animated: true) {
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        submitButton.layer.cornerRadius = 20
        submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView{
        case discountPickerView:
            return discountLavel.count
        case paymentPickerView:
            return paymentArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView{
        case discountPickerView:
            return discountLavel[row]
        case paymentPickerView:
            return paymentArray[row]
        default:
            return nil
        }
    }
    @IBAction func endUniPriceOrQuentry(_ sender: Any) {
        calTotalPrice()
    }
    
    func setDisconutRate(){
        
        switch discountPickerView.selectedRow(inComponent: 0){
        case 0:
            disCountRate = 1.0
        case 1:
            disCountRate = 0.95
        case 2:
            disCountRate = 0.9
        case 3:
            disCountRate = 0.85
        case 4:
            disCountRate = 0.8
        case 5:
            disCountRate = 0.75
        case 6:
            disCountRate = 0.7
        case 7:
            disCountRate = 0.65
        case 8:
            disCountRate = 0.6
        default:
            break
        }
        calTotalPrice()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView{
        case discountPickerView:
            setDisconutRate()
        default:
            break
        }
    }
    
    

    func calTotalPrice(){
        if let qty = Double(quantity.text ?? ""){
            if let uniPrice = Double(uniPrice.text ?? ""){
                let price = qty * uniPrice * disCountRate
          

                let formatter = NumberFormatter()
                formatter.maximumFractionDigits = 0
                formatter.numberStyle = .currency
                let priceString = formatter.string(from: NSNumber(value: price)) ?? ""
                self.totalPrice.text = "\(priceString)"
            }
        }
    }
  
    @IBAction func submitAction(_ sender: Any) {
        let orderDate = orderDatePicker.date
        let procuctNumber = productNumber.text ?? ""
        let productName = productName.text ?? ""
        let theQuantity = Double(quantity.text ?? "") ?? 0
        let theUniPrice = Double(uniPrice.text ?? "") ?? 0
        setDisconutRate()
        let remark = remarkTextField.text ?? ""
        
        if selectedSales == nil{
            showAlert("請指定業務員", action: nil)
            return
        }
        
        if procuctNumber == ""  {
            showAlert("請輸入產品編號", action: nil)
            return
        }
        
        
        if productName == "" {
            showAlert("請輸入產品名稱", action: nil)
            return
        }
        
        if theUniPrice == 0 {
            showAlert("請輸入產品單價", action: nil)
            return
        }
        
        if theQuantity == 0 {
            showAlert("請輸入產品數量", action: nil)
            return
        }
    
        if paymentPickerView.selectedRow(inComponent: 0) == 0 {
            showAlert("請選擇付款方式", action: nil)
            return
        }
        
        Tools.showIndicator(inController: self)
        
        let header = Int.random(in: 100...999)
        var poNumber = "\(header)"

        ref.child("base/poCo").observeSingleEvent(of: .value) { snapshot in
            let counter = snapshot.value as! Int
            self.ref.child("base/poCo").setValue(counter+1)
            let numberString = String(format: "%08d", counter)
            poNumber += numberString
            let formater = DateFormatter()
            formater.dateFormat = "yyyyMM"
            let categoryString = formater.string(from: orderDate)
            
            
            let order = ["time":Int(orderDate.timeIntervalSince1970 * 1000),
                         "poNumber":poNumber,
                         "sales":self.salesLabel.text ?? "",
                         "pname":productName,
                         "pnum":procuctNumber,
                         "qry":theQuantity,
                         "upi":theUniPrice,
                         "drate":self.disCountRate,
                         "pay":self.paymentArray[self.paymentPickerView.selectedRow(inComponent: 0)],
                         "rm":remark] as [String:Any]
            self.ref.child("order/\(categoryString)").childByAutoId().setValue(order)
            self.ref.child("base/pot").setValue(ServerValue.timestamp())
            
            self.showAlert("完成訂單！") { alert in
                Tools.removeIndicator(inController: self)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
   
    }
    
    
    
}
