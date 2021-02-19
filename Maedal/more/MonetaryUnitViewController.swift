//
//  MonetaryUnitViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/02/05.
//

import UIKit

class MonetaryUnitViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sampleView: UILabel!
    @IBOutlet weak var unitLocationView: UISegmentedControl!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var unitLocationDescriptionView: UILabel!
    
    private var data = CurrencyUnit.currencies
    private let price = "100"
    private var unit: String?
    
    var onValueChangeListener: ((_ unit: String, _ onRight: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        setUnitLocationDescription()
        setSampleView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - PickerView protocol subs
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        unit = data[row]
        setSampleView()
    }
    
    // MARK: - Value Change Listener
    @IBAction func onConfirmButtonClick(_ sender: UIBarButtonItem) {
        onValueChangeListener?(unit ?? data[0], unitLocationView.selectedSegmentIndex != 0)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSegmentedControllChange(_ sender: UISegmentedControl) {
        setUnitLocationDescription()
        setSampleView()
    }
    
    @IBAction func onCustomUnitClick(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("currency_custom_title", comment: ""), message: NSLocalizedString("currency_custom_content", comment: ""), preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: NSLocalizedString("confirm", comment: ""), style: .default) { (action) in
            // TODO
            if let custom = alert.textFields?[0].text {
                if !custom.isEmpty {
                    self.unit = custom
                }
                self.setSampleView()
            }
        }
        alert.addAction(confirm)
        
        let cancel = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        alert.addTextField { (textField) in
            textField.placeholder = NSLocalizedString("currency_custom_placeholder", comment: "")
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    private func setUnitLocationDescription() {
        if unitLocationView.selectedSegmentIndex == 0 {
            unitLocationDescriptionView.text = NSLocalizedString("currency_unit_left_description", comment: "")
        } else {
            unitLocationDescriptionView.text = NSLocalizedString("currency_unit_right_description", comment: "")
        }
    }
    
    private func setSampleView() {
        if unitLocationView.selectedSegmentIndex == 0 {
            sampleView.text = (unit ?? data[0]) + price
        } else {
            sampleView.text = price + (unit ?? data[0])
        }
    }
    
}
