//
//  MoviesAppUITests.swift
//  MoviesAppUITests
//
//  Created by David López on 19/2/25.
//

import XCTest

final class MoviesAppUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
        
    }
    
    @MainActor
    func testMoviesListDisplayed() {
        
        XCTAssertTrue(app.navigationBars["Movies"].exists)
        
        let moviesList = app.collectionViews.firstMatch
        XCTAssertTrue(moviesList.exists)
        XCTAssertTrue(moviesList.cells.count > 0)
    }
    
    @MainActor
    func testPaginationWorks() {
        
        let initialPageText = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Page'")).firstMatch.label
        
        let moviesList = app.collectionViews.firstMatch
        for _ in 0..<5 {
            moviesList.swipeUp(velocity: .fast)
        }
        
        let expectation = XCTestExpectation(description: "Wait for more content to load")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
        
        // Verify page has changed
        let updatedPageText = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'Page'")).firstMatch.label
        XCTAssertNotEqual(initialPageText, updatedPageText)
    }
    
    @MainActor
    func testMovieDetailDisplayed() {
        
        let firstMovie = app.collectionViews.cells.firstMatch
        let movieTitle = firstMovie.staticTexts.element(boundBy: 0).label
        firstMovie.tap()
        
        XCTAssertTrue(app.staticTexts[movieTitle].exists)
        
        XCTAssertTrue(app.staticTexts["Overview"].exists)
        
        let voteView = app.staticTexts.matching(NSPredicate(format: "label CONTAINS '%'")).firstMatch
        XCTAssertTrue(voteView.exists)
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
