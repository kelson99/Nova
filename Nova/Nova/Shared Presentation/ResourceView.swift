//
//  ResourceView.swift
//  Nova
//
//  Created by Kelson Hartle on 1/9/24.
//

import Foundation

public struct ResourceErrorViewModel {
    public let message: String?
    
    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}

public protocol ResourceErrorView {
    func display(_ viewModel: ResourceErrorViewModel)
}

public struct ResourceLoadingViewModel {
    public let isLoading: Bool
}

public protocol ResourceLoadingView {
    func display(_ viewModel: ResourceLoadingViewModel)
}

public protocol ResourceView {
    associatedtype ResourceViewModel
    
    func display(_ viewModel: ResourceViewModel)
}

public final class LoadResourcePresenter<Resource, View: ResourceView> {
    public typealias Mapper = (Resource) throws -> View.ResourceViewModel
    
    private let resourceView: View
    private let loadingView: ResourceLoadingView
    private let errorView: ResourceErrorView
    private let mapper: Mapper
    
    public static var loadError: String {
        "Error loading daily challenge"
    }
    
    public init(resourceView: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView, mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = mapper
    }
    
    public init(resourceView: View, loadingView: ResourceLoadingView, errorView: ResourceErrorView) where Resource == View.ResourceViewModel {
        self.resourceView = resourceView
        self.loadingView = loadingView
        self.errorView = errorView
        self.mapper = { $0 }
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoading(with resource: Resource) {
        do {
            resourceView.display(try mapper(resource))
            loadingView.display(ResourceLoadingViewModel(isLoading: false))
        } catch {
            didFinishLoading(with: error)
        }
    }
    
    public func didFinishLoading(with error: Error) {
        errorView.display(.error(message: Self.loadError))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
}
