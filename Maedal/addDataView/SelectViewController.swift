//
//  SelectViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/31.
//

import UIKit

class SelectViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data: [SelectItemData]?
    var onItemSelectedListener: ((_ data: Any) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Tableview Protocol stubs
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let data = self.data?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectItemData") as! SelectTableViewCell
            
            cell.titleTextView.text = data.title
            cell.detailTextView.text = data.detail
            
            return cell
            
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onItemSelectedListener?(indexPath.row)
        navigationController?.popViewController(animated: true)
    }

}

class SelectTableViewCell: UITableViewCell {
    @IBOutlet weak var titleTextView: UILabel!
    @IBOutlet weak var detailTextView: UILabel!
}

struct SelectItemData {
    var data: Any?
    var title: String
    var detail: String?
}
