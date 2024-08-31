import XCTest

class CronicaUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }

    // Test for displaying item content list correctly
    func testItemContentListDisplaysCorrectly() throws {
        let trendingText = app.staticTexts["EmptyStateMessage"]
        
        if trendingText.exists {
            // Verify the empty state message is visible
            XCTAssertTrue(trendingText.exists, "The empty state message should be displayed when there are no items.")
        } else {
            // Verify that the items are displayed correctly
            let items = app.images.matching(identifier: "PosterImage")
            XCTAssertTrue(items.count > 0, "The items should be displayed in the list.")
        }
    }

    // Test interaction with a link in a poster image
    func testPosterImageLinks() throws {
        let posterImages = app.images.matching(identifier: "PosterImage")
        
        if posterImages.count > 0 {
            let firstPoster = posterImages.element(boundBy: 0)
            XCTAssertTrue(firstPoster.exists, "The first poster image should exist.")
            firstPoster.tap()
            
            let safari = app.webViews.firstMatch
            XCTAssertTrue(safari.waitForExistence(timeout: 5), "The web view should be displayed after tapping the poster image.")
        }
    }

    // Test placeholder image displays correctly
    func testPlaceholderImageDisplays() throws {
        let placeholderImage = app.images["popcorn.fill"]
        XCTAssertTrue(placeholderImage.exists, "The placeholder image should be displayed when there is no data.")
    }
    
    // Test that the list can be scrolled
    func testItemContentListScrolling() throws {
        let items = app.images.matching(identifier: "PosterImage")
        
        if items.count > 0 {
            let firstItem = items.element(boundBy: 0)
            let lastItem = items.element(boundBy: items.count - 1)
            let exists = lastItem.waitForExistence(timeout: 5)
            
            if !exists {
                app.scrollViews.element.swipeUp()
            }
            
            XCTAssertTrue(lastItem.exists, "The last item in the list should be visible after scrolling.")
        }
    }

    // Test interaction with a link in a poster image
    func testPosterImageLinkNavigation() throws {
        let firstPosterImage = app.images.matching(identifier: "PosterImage").element(boundBy: 0)
        
        if firstPosterImage.exists {
            firstPosterImage.tap()
            
            let detailView = app.otherElements["DetailViewIdentifier"]
            XCTAssertTrue(detailView.waitForExistence(timeout: 5), "Tapping the poster image should navigate to the detail view.")
        } else {
            XCTFail("The first poster image does not exist or is not tappable.")
        }
    }

    // Test empty state handling on reload
    func testEmptyStateOnReload() throws {
        let initialItems = app.images.matching(identifier: "PosterImage")
        if initialItems.count > 0 {
            app.buttons["ReloadButtonIdentifier"].tap()
            
            let trendingText = app.staticTexts["EmptyStateMessage"]
            XCTAssertTrue(trendingText.waitForExistence(timeout: 5), "The empty state message should be displayed after reloading with no items.")
        } else {
            XCTFail("Initial items are not available for testing.")
        }
    }

    // Test navigation to other sections of the app
    func testNavigationToOtherSections() throws {
        let menuButton = app.buttons["MenuButtonIdentifier"]
        menuButton.tap()
        
        let targetView = app.otherElements["TargetViewIdentifier"]
        XCTAssertTrue(targetView.waitForExistence(timeout: 5), "Tapping the menu button should navigate to the correct section of the app.")
    }

    // Test search functionality
    func testSearchFunctionality() throws {
        let searchField = app.searchFields["SearchFieldIdentifier"]
        let searchButton = app.buttons["SearchButtonIdentifier"]
        
        searchField.tap()
        searchField.typeText("Test Query")
        searchButton.tap()
        
        let searchResults = app.staticTexts["SearchResultIdentifier"]
        XCTAssertTrue(searchResults.waitForExistence(timeout: 5), "Search results should be displayed after searching.")
        
        let clearButton = app.buttons["ClearButtonIdentifier"]
        clearButton.tap()
        
        XCTAssertFalse(searchResults.exists, "Search results should be cleared after pressing the clear button.")
    }

    // Test refresh button functionality
    func testRefreshButtonFunctionality() throws {
        let initialItemCount = app.images.matching(identifier: "PosterImage").count
        
        app.buttons["RefreshButtonIdentifier"].tap()
        
        let refreshedItemCount = app.images.matching(identifier: "PosterImage").count
        XCTAssertNotEqual(initialItemCount, refreshedItemCount, "The item count should be updated after tapping the refresh button.")
    }

    // Performance test for app launch
    func testPerformanceOfItemLoading() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            app.launch()
        }
    }
}
