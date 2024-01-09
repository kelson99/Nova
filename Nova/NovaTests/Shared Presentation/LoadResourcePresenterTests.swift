//
//  LoadResourcePresenterTests.swift
//  NovaTests
//
//  Created by Kelson Hartle on 1/9/24.
//

import Nova
import XCTest

final class LoadResourcePresenterTests: XCTestCase {
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoading_displaysNoErrorMessage_andStartsLoading() {
        let (sut, view) = makeSUT()
        sut.didStartLoading()
        XCTAssertEqual(view.messages, [
            .display(errorMesasge: .none),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingResource_displaysResourceAndStopsLoading() {
        let (sut, view) = makeSUT(mapper: { resource in
            resource + " view model"
        })
        sut.didFinishLoading(with: "resource")
        XCTAssertEqual(view.messages, [
            .display(resourceViewModel: "resource view model"),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithMapperError_displaysErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT(mapper: { resource in
            throw anyNSError()
        })
        
        sut.didFinishLoading(with: "resource")
        XCTAssertEqual(view.messages, [
            .display(errorMesasge: "Error loading daily challenge"),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didFinishLoading(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMesasge: "Error loading daily challenge"),
            .display(isLoading: false)
        ])
    }
    
    private typealias SUT = LoadResourcePresenter<String, ViewSpy>
    private func makeSUT(
        mapper: @escaping SUT.Mapper = { _ in "any" },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: SUT, view: ViewSpy) {
        let view = ViewSpy()
        let sut = SUT(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        return (sut, view)
    }
    
    private class ViewSpy: ResourceView, ResourceLoadingView, ResourceErrorView {
        
        typealias ResourceViewModel = String
        
        enum Message: Hashable {
            case display(errorMesasge: String?)
            case display(isLoading: Bool)
            case display(resourceViewModel: String)
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: ResourceErrorViewModel) {
            messages.insert(.display(errorMesasge: viewModel.message))
        }
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
    }
}



