//
//  IconViewController.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/31.
//

import UIKit

class IconViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var iconBackgroundView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    private var color: [String] = Array()
    private var icon: [String] = Array()
    private var selectedColor: String?
    private var selectedIcon: String?
    
    var onSaveClickListener: ((_ color: String, _ icon: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        initUI()
        initColorData()
        setColor()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Collectionview Protocol stubs
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return color.count
            
        case 1: return icon.count
            
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorSelectCell", for: indexPath) as! ColorCollectionViewCell
            
            cell.colorView.backgroundColor = Color.getColor(name: color[indexPath.row])
            
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconSelectCell", for: indexPath) as! IconCollectionViewCell
            
            cell.iconView.image = UIImage(named: icon[indexPath.row])
            
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedColor = color[indexPath.row]
            setColor()
            break
            
        case 1:
            iconImageView.image = UIImage(named: icon[indexPath.row])
            break
            
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onConfirmViewClick(_ sender: Any) {
        let selectedColor = self.selectedColor ?? self.color[0]
        let selectedIcon = self.selectedIcon ?? self.icon[0]
        self.onSaveClickListener?(selectedColor, selectedIcon)
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSectionChange(_ sender: UISegmentedControl) {
        collectionView.reloadData()
    }
    
    // MARK: - Initialization
    
    private func initUI() {
        iconBackgroundView.layer.cornerRadius = 24
        iconBackgroundView.layer.masksToBounds = true
    }
    
    private func initColorData() {
        color.removeAll()
        color.append(contentsOf: Color.colorNames)
        if segmentedControl.selectedSegmentIndex == 0 {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Functions
    
    private func setColor() {
        if let colorName = selectedColor {
            iconBackgroundView.backgroundColor = Color.getColor(name: colorName)
        } else {
            selectedColor = color[0]
            setColor()
        }
    }
    
}

class ColorCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var colorView: UIView!
    
    override func draw(_ rect: CGRect) {
        colorView.layer.cornerRadius = colorView.bounds.height / 2
    }
}

class IconCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconView: UIImageView!
}
