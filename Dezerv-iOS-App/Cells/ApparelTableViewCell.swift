//
//  ApparelTableViewCell.swift
//  Dezerv-iOS-App
//
//  Created by Harsh Kumar Agrawal on 18/04/23.
//

import UIKit

protocol ApparelCellViewModelDelegate: AnyObject {
    func getApparelDataAtID(_ id: Int) -> Apparel?
    func getImageAtID(_ id: Int) -> UIImage?
}

class ApparelTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var apparelImageView: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: CustomUIView!
    
    // MARK: LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // MARK: Setup Cell
    func setupCell(_ id: Int?, _ viewModel: ApparelCellViewModelDelegate) {
        
        setGradient()
        
        guard let id = id else {return}
        guard let data = viewModel.getApparelDataAtID(id) else { return }
        
        
        apparelImageView.image = viewModel.getImageAtID(id) ?? UIImage(named: "image-404")
        countLabel.text = data.rating?.count == nil ? "" : String(describing: data.rating?.count ?? 1)
        
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
    }
    
    func setGradient() {
        containerView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [UIColor.lightPink.cgColor, UIColor.systemBlue.cgColor] // set the colors for the gradient
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.2) // set the starting point to the left side of the view
        gradientLayer.endPoint = CGPoint(x: 4, y: 2) // set the ending point to the right side of the view
        containerView.layer.insertSublayer(gradientLayer, at: 0) // add the gradient layer to the view's layer
    }
}
