//
//  DetailsViewController.swift
//  Dezerv-iOS-App
//
//  Created by Harsh Kumar Agrawal on 18/04/23.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var apparelImageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var categoryButton: CustomUIButton!
    
    // MARK: IBActions
    @IBAction func showCategoryPage(_ sender: Any) {
        guard let homeVC = navigationController?.viewControllers[safe: 0] as? MainViewController else {return}
        
        homeVC.pageType = category ?? .home
        homeVC.updateUI()
        navigationController?.popViewController(animated: true)
    }
    
    weak var viewModel: ApparelCellViewModelDelegate?
    var id: Int?
    var pageTitle = "Details Screen"
    var category: Category?
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setGradient()
        navigationItem.title = pageTitle
        title = pageTitle
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(_:)))
        swipeGesture.direction = .right
        containerView.addGestureRecognizer(swipeGesture)
    }
    
    // MARK: Methods
    @objc func handleSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.direction == .right {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func setupUI() {
        
        guard let id = id, let viewModel = viewModel else {return}
        guard let data = viewModel.getApparelDataAtID(id) else { return }
        
        category = data.category
        apparelImageView.image = viewModel.getImageAtID(id) ?? UIImage(named: "image-404")
        countLabel.text = data.rating?.count == nil ? "" : String(describing: data.rating?.count ?? 1) + " left"
        
        if let rating = data.rating?.rate {
            ratingLabel.text = "⭐ " + String(describing: rating)
        } else {
            ratingLabel.text = ""
        }
        if let price = data.price {
            priceLabel.text = "$ " + String(describing: price)
        } else {
            priceLabel.text = ""
        }
        titleLabel.text = String(describing: data.title ?? "")
        descriptionLabel.text = String(describing: data.description ?? "")
        
        categoryButton.setTitle(String(describing: category?.rawValue ?? ""), for: .normal)
        if category == nil {
            categoryButton.isHidden = true
        } else {
            categoryButton.isHidden = false
        }
    }
    
    private func setGradient() {
        containerView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [UIColor.lightPink.cgColor, UIColor.systemBlue.cgColor] // set the colors for the gradient
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.2) // set the starting point to the left side of the view
        gradientLayer.endPoint = CGPoint(x: 4, y: 2) // set the ending point to the right side of the view
        containerView.layer.insertSublayer(gradientLayer, at: 0) // add the gradient layer to the view's layer
    }
}
