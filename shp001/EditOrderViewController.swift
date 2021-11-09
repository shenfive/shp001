//
//  EditOrderViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/8.
//

import UIKit
import Firebase

class EditOrderViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    

    
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var poNumberLabel: UILabel!
    @IBOutlet weak var orderDatePicker: UIDatePicker!
    @IBOutlet weak var productNumber: UITextField!
    @IBOutlet weak var productName: UITextField!
    @IBOutlet weak var paymentPickerView: UIPickerView!
    @IBOutlet weak var uniPrice: UITextField!
    @IBOutlet weak var quantity: UITextField!
    @IBOutlet weak var discountPickerView: UIPickerView!
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var isFirstOrder: UISegmentedControl!
    @IBOutlet weak var selectSales: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    var ref:DatabaseReference!
    var theOrder:Order = Order()
    var editAction:(()->())? = nil
    var reflasuhAction:(()->())? = nil

    var discountLavel:[String] = []
    var paymentArray:[String] = []

    var disCountRate = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        

        discountPickerView.delegate = self
        discountPickerView.dataSource = self
        paymentPickerView.delegate = self
        paymentPickerView.dataSource = self
        
        
        ref = Database.database().reference()
        mainContainer.layer.cornerRadius = 20
        submitButton.layer.cornerRadius = 22
        cancelButton.layer.cornerRadius = 22
        selectSales.layer.cornerRadius = 16.5
        
        poNumberLabel.text = theOrder.poNumber
        orderDatePicker.setDate(theOrder.time, animated: false)
        productName.text = theOrder.productName
        productNumber.text = theOrder.productNumber
        
        disCountRate = theOrder.disconuntRate
        salesLabel.text = theOrder.sales
        
        if theOrder.isFirstOrder == true {
            self.isFirstOrder.selectedSegmentIndex = 0
        }else{
            self.isFirstOrder.selectedSegmentIndex = 1
        }
        
        discountLavel = ["原價","九五折","九折","八五折","八折","七五折","七折","六五折","六折"]
        paymentArray = ["請選擇","現金","線上刷卡","店面刷卡","其他"]
 
        uniPrice.text = "\(theOrder.uniprice)"
        quantity.text = "\(theOrder.qry)"
        
        calTotalPrice()
  
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for i in 0...paymentArray.count-1{
            if theOrder.payMent == paymentArray[i]{
                paymentPickerView.selectRow(i, inComponent: 0, animated: true)
            }
        }
        switch theOrder.disconuntRate {
        case 0.95:
            discountPickerView.selectRow(1, inComponent: 0, animated: true)
        case 0.9:
            discountPickerView.selectRow(2, inComponent: 0, animated: true)
        case 0.85:
            discountPickerView.selectRow(3, inComponent: 0, animated: true)
        case 0.8:
            discountPickerView.selectRow(4, inComponent: 0, animated: true)
        case 0.75:
            discountPickerView.selectRow(5, inComponent: 0, animated: true)
        case 0.7:
            discountPickerView.selectRow(6, inComponent: 0, animated: true)
        case 0.65:
            discountPickerView.selectRow(7, inComponent: 0, animated: true)
        case 0.6:
            discountPickerView.selectRow(8, inComponent: 0, animated: true)
        default :
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
                self.total.text = "訂單總額: \(priceString)"
            }
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView{
        case discountPickerView:
            setDisconutRate()
        case paymentPickerView:
            break
        default:
            break
        }
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
    
    @IBAction func submit(_ sender: Any) {
        let alert = UIAlertController(title: "提示", message: "你確定要做出修改嗎？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { action in
            self.saveOrder()
            self.showAlert("已修正") { action in
                self.reflasuhAction?()
                self.dismiss(animated: true, completion: nil)
            }
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func saveOrder(){
        let orderDate = orderDatePicker.date
        let procuctNumber = productNumber.text ?? ""
        let productName = productName.text ?? ""
        let theQuantity = Double(quantity.text ?? "") ?? 0
        let theUniPrice = Double(uniPrice.text ?? "") ?? 0
        setDisconutRate()
        
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
        

        let poNumber = theOrder.poNumber


        let formater = DateFormatter()
        formater.dateFormat = "yyyyMM"
        let categoryString = formater.string(from: orderDate)
        let orgCatgoryString = formater.string(from: theOrder.time)
        
        let payment = self.paymentArray[self.paymentPickerView.selectedRow(inComponent: 0)]
        
        let order = ["time":Int(orderDate.timeIntervalSince1970 * 1000),
                     "poNumber":poNumber,
                     "sales":self.salesLabel.text ?? "",
                     "pname":productName,
                     "isFirstPO":self.isFirstOrder.selectedSegmentIndex == 0 ? true:false,
                     "pnum":procuctNumber,
                     "qry":theQuantity,
                     "upi":theUniPrice,
                     "drate":self.disCountRate,
                     "pay":payment] as [String:Any]
        self.ref.child("order/\(categoryString)/\(self.theOrder.key)").setValue(order)
        if categoryString != orgCatgoryString {
            self.ref.child("order/\(orgCatgoryString)/\(self.theOrder.key)").removeValue()
        }
        self.ref.child("base/pot").setValue(ServerValue.timestamp())
        
        self.showAlert("完成訂單！") { alert in
            self.dismiss(animated: true) {
                self.reflasuhAction?()
            }
            
        }
        
        
    }
    
    
    @IBAction func selectMemberAction(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "introducerPickerViewController") as! IntroducerPickerViewController
        nextVC.setIntroduerAction = {
            self.salesLabel.text = "\($1)    \($0)"
            nextVC.dismiss(animated: true) {
            }
        }
        present(nextVC, animated: true) {
        }
    }
}
