//
//  ViewController.swift
//  Dezerv-iOS-App
//
//  Created by Harsh Kumar Agrawal on 17/04/23.
//

import UIKit

class MainViewController: UIViewController, MasterViewModelDelegate {
    
    //MARK: Updating tableView
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    func updateCellAt(_ indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    //MARK: IBOutlets & IBActions
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var viewAllButtonView: UIView!
    
    @IBAction func viewAllButton(_ sender: Any) {
        self.pageType = .home
        self.viewAllButtonView.isHidden = true
        self.updateUI()
        pageTitle = pageType.rawValue
        navigationItem.title = pageTitle
        title = pageTitle
    }
    
    //MARK: Properties
    var viewModel: MasterViewModel?
    var pageTitle = "Home Page - Apparels"
    var pageType = Category.home
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = MasterViewModel()
        viewModel?.delegate = self
        
        if !NetworkManager.shared.isNetworkAvailable() {
            print("No INTERNET -- ")
            self.showAlertController(withTitle: "No Internet Connection Available !", actionHandler: { action in
                self.dismiss(animated: true) {
                    exit(0)
                }
            })
            
        }
        viewModel?.makeNetworkCall()
        tableView.registerNib(ApparelTableViewCell.self)
    }
    override func viewWillAppear(_ animated: Bool) {
        
        pageTitle = pageType.rawValue
        navigationItem.title = pageTitle
        title = pageTitle
        if pageType == .home {
            self.viewAllButtonView.isHidden = true
        } else {
            self.viewAllButtonView.isHidden = false
        }
    }
}

//MARK: TableView Datasource and Delegate Methods
extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if pageType != .home {
            return viewModel?.categoryApparelMap[pageType]?.count ?? 0
        }
        return viewModel?.getApparelCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ApparelTableViewCell", for: indexPath) as!
        ApparelTableViewCell
        guard let vm = viewModel else {return cell}
        
        if pageType != .home {
            let list = viewModel?.categoryApparelMap[pageType]
            let id = list?[indexPath.row].id
            cell.setupCell(id, vm)
        } else {
            cell.setupCell(indexPath.row + 1, vm)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let presentedVC = self.storyboard?.instantiateViewController(withIdentifier: String(describing: DetailsViewController.self)) as! DetailsViewController
        
        guard let vm = viewModel else {return}
        presentedVC.viewModel = vm
        
        if pageType != .home {
            let list = viewModel?.categoryApparelMap[pageType]
            let id = list?[indexPath.row].id
            presentedVC.id = id
        } else {
            presentedVC.id = indexPath.row + 1
        }
        
        presentedVC.modalPresentationStyle = .overFullScreen
        presentedVC.modalTransitionStyle = .coverVertical
        navigationController?.pushViewController(presentedVC, animated: true)
    }
}
