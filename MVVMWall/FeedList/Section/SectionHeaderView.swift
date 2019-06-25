//
//  SectionHeaderView.swift
//  MVVMWall
//
//  Created by praveen velanati on 6/23/19.
//  Copyright © 2019 praveen velanati. All rights reserved.
//

import Foundation
import UIKit

public class SectionHeaderView: UIView {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        label.font = UIFont(name: "AmericanTypewriter-Condensed", size: 17)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.backgroundColor = UIColor.lightGray
        return view
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialView()
        setupConstrint()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupInitialView()
        setupConstrint()
    }
    
    public func setTitle(_ text: String) {
        self.titleLabel.text = text
    }
    
    private func setupInitialView() {
        self.backgroundColor = UIColor.white
    }
    
    
    private func setupConstrint() {
        
        NSLayoutConstraint.activate(titleLabel.edgeConstraints(top: 5, left: 10, bottom: 5, right: 10))
        
        NSLayoutConstraint.activate([
            separator.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            separator.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            separator.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            separator.heightAnchor.constraint(equalToConstant: 1)
            ])
    }
}

