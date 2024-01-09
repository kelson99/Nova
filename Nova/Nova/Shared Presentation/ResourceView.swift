//
//  ResourceView.swift
//  Nova
//
//  Created by Kelson Hartle on 1/9/24.
//

import Foundation

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}
