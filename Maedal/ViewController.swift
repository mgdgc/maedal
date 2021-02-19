//
//  ViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/12.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let segAdd = "segAdd"
    private let segMore = "segMore"
    private let segItemDetail = "segItemDetail"
    
    // UITableView
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var addButton: UIButton!
    
    // TotalSpendView
    @IBOutlet weak var totalSpendView: CardView!
    @IBOutlet weak var totalSpendAmountView: UILabel!
    
    // TotalNumberView
    @IBOutlet weak var totalNumberView: UIView!
    @IBOutlet weak var totalNumberAmountView: UILabel!
    @IBOutlet weak var totalNumberDescriptionView: UILabel!
    
    // NextPaymentView
    @IBOutlet weak var nextPaymentView: UIView!
    @IBOutlet weak var nextPaymentBillView: UILabel!
    @IBOutlet weak var nextPaymentDescriptionView: UILabel!
    
    // UpcomingView
    @IBOutlet weak var upcomingView: UIView!
    @IBOutlet weak var upcomingTableView: UITableView!
    @IBOutlet weak var upcomingTableHeight: NSLayoutConstraint!
    
    // Data
    private var data: [Subscription] = Array()
    private var monthlyData: [Subscription] = Array()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Detail UITableView
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.tableFooterView = UIView()
        detailTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: CGFloat.leastNormalMagnitude))
        
        // Monthly UITableView
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        upcomingTableView.separatorColor = UIColor.clear
        
        initAll()
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segMore {
            let navController = segue.destination as? UINavigationController
            let vc = navController?.topViewController as? MoreViewController
            vc?.onViewControllerDisappear = {
                // Re-initialize Data
                self.setTotalSpendView()
                self.setNextPaymentView()
            }
        } else if segue.identifier == segAdd {
            let navController = segue.destination as? UINavigationController
            let vc = navController?.topViewController as? MoreViewController
            vc?.onViewControllerDisappear = {
                self.initAll()
            }
        }
    }
    
    //
    // MARK: - UITableView protocol stubs
    //
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.isEqual(detailTableView) {
            if data.isEmpty {
                return 1
            } else {
                return data.count
            }
            
        } else if tableView.isEqual(upcomingTableView) {
            if monthlyData.isEmpty {
                return 1
            } else {
                return monthlyData.count
            }
            
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.isEqual(detailTableView) {
            if data.isEmpty {
                return tableView.dequeueReusableCell(withIdentifier: "ItemAddCell") as! ItemAddCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewDetailCell") as! DetailViewCell
                return cell
            }
            
        } else if tableView.isEqual(upcomingTableView) {
            if monthlyData.count == 0 {
                return tableView.dequeueReusableCell(withIdentifier: "MonthlyNoItemCell") as! MonthlyNoItemCell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyViewCell") as! MonthlyViewCell
                
                let date = Subscription.getDateFromString(from: data[indexPath.row].date)
                let format = DateFormatter()
                format.dateFormat = "MM"
                
                cell.dateView.text = format.string(from: date)
                cell.nameView.text = data[indexPath.row].name
                
                return cell
            }
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEqual(detailTableView) {
            if indexPath.row == data.count {
                addItem()
            }
            
        } else if tableView.isEqual(upcomingTableView) {
            // TODO
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell is ItemAddCell || cell is MonthlyNoItemCell {
            setTableViewHeight()
        }
    }
    
    private func setTableViewHeight() {
        DispatchQueue.main.async {
            self.tableViewHeight.constant = self.detailTableView.contentSize.height
            self.upcomingTableHeight.constant = self.upcomingTableView.contentSize.height
        }
    }
    
    //
    // MARK: - Button action
    //
    @IBAction func onMoreButtonClick(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: segMore, sender: nil)
    }
    
    @IBAction func onAddButtonClick(_ sender: Any) {
        addItem()
    }
    
    private func addItem() {
        performSegue(withIdentifier: segAdd, sender: nil)
    }
    
    // MARK: - Initialize Data & UI
    
    private func initAll() {
        initUI()
        initData()
        
        // Upcoming View
        setUpcomingView()
        
        // Total Subscription number
        totalNumberAmountView.text = String(data.count)
        
        // Total Subscription price
        setTotalSpendView()
        
        // Next Payment
        setNextPaymentView()
    }
    
    private func initUI() {
        // make views' corner round
        let cornerRadius = CGFloat(10)
        totalNumberView.layer.cornerRadius = cornerRadius
        totalNumberView.layer.masksToBounds = true
        nextPaymentView.layer.cornerRadius = cornerRadius
        nextPaymentView.layer.masksToBounds = true
        upcomingView.layer.cornerRadius = cornerRadius
        upcomingView.layer.masksToBounds = true
        
    }
    
    private func initData() {
        let manager = DatabaseManager()
        data.removeAll()
        for d in manager.get() {
            data.append(d)
        }
        
        detailTableView.reloadData()
        
    }
    
    private func setUpcomingView() {
        monthlyData.removeAll()
        
        let current = Date()
        for i in 0..<data.count {
            if monthlyData.count <= 3 {
                let itemDate = Subscription.getDateFromString(from: data[i].date)
                
                if current == itemDate || current < itemDate {
                    monthlyData.append(data[i])
                }
            } else {
                break
            }
        }
        
        upcomingTableView.reloadData()
    }
    
    private func setTotalSpendView() {
        totalSpendAmountView.text = Subscription.getPriceString(price: sumPrices())
    }
    
    private func setNextPaymentView() {
        let nextPayment = getNextPayment()
        nextPaymentBillView.text = Subscription.getPriceString(price: nextPayment?.price ?? 0)
        nextPaymentDescriptionView.text = nextPayment?.name ?? NSLocalizedString("next_payment_description", comment: "")
    }
    
    // MARK: - Functions
    
    private func sumPrices() -> Double {
        var sum: Double = 0
        for d in data {
            sum = sum + d.price
        }
        return sum
    }
    
    private func getNextPayment() -> Subscription? {
        for d in data {
            if Subscription.getDateFromString(from: d.date) >= Date() {
                return d
            }
        }
        return nil
    }
    
    private func calculateCateogory() {
        // TODO
    }

}

// MARK: - Other Classes

class CircleView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
}

class CardView: UIView {
    override func layoutSubviews() {
        let cornerRadius = CGFloat(20)
        super.layer.cornerRadius = cornerRadius
        super.layer.shadowOpacity = 0.2
        super.layer.shadowOffset = CGSize(width: 0, height: 3)
        super.layer.shadowRadius = 10
        super.layer.masksToBounds = false
    }
}

class DetailViewCell: UITableViewCell {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var itemTitleView: UILabel!
    @IBOutlet weak var itemPaymentDateView: UILabel!
    @IBOutlet weak var itemPriceView: UILabel!
}

class ItemAddCell: UITableViewCell {
    @IBOutlet weak var textView: UILabel!
}

class MonthlyViewCell: UITableViewCell {
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var dateView: UILabel!
    @IBOutlet weak var dateBackgroundView: UIView!
    @IBOutlet weak var nameView: UILabel!
    
    override func draw(_ rect: CGRect) {
        cellBackgroundView.layer.cornerRadius = cellBackgroundView.bounds.height / 2
        dateBackgroundView.layer.cornerRadius = dateBackgroundView.bounds.height / 2
    }
}

class MonthlyNoItemCell: UITableViewCell {
    @IBOutlet weak var textView: UILabel!
}
