//
//  MoviesAppTests.swift
//  MoviesAppTests
//
//  Created by David López on 19/2/25.
//

import XCTest
@testable import MoviesApp

// MARK: - MoviesViewModelTests

final class MoviesViewModelTests: XCTestCase {
    
    var viewModelUnderTest: MoviesViewModel!
    var mockInteractor: MockMoviesInteractor!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockMoviesInteractor()
        viewModelUnderTest = MoviesViewModel(interactor: mockInteractor, favoritesManager: FavoritesManager())
    }
    
    override func tearDown() {
        viewModelUnderTest = nil
        mockInteractor = nil
        super.tearDown()
    }
    
    func testFetchMoviesSuccess() async throws {
        
        mockInteractor.mockGetMoviesResult = .success(MovieResponse(
            page: 1,
            totalPages: 1,
            totalResults: Movie.getMockMovies.count,
            results: Movie.getMockMovies
        ))
        
        // Run method to test
        await viewModelUnderTest.fetchMovies()
        
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5s
        
        XCTAssertEqual(mockInteractor.getMoviesCallCount, 1)
        
        // Verify states
        XCTAssertEqual(viewModelUnderTest.movies.count, 2)
        XCTAssertFalse(viewModelUnderTest.isLoading)
        XCTAssertNil(viewModelUnderTest.error)
        
        // Verify data in movies
        XCTAssertEqual(viewModelUnderTest.movies[0].id, 12345)
        XCTAssertEqual(viewModelUnderTest.movies[0].title, "Test Movie 1")
        XCTAssertEqual(viewModelUnderTest.movies[1].id, 67890)
        XCTAssertEqual(viewModelUnderTest.movies[1].title, "Test Movie 2")
        
        // Verify content state
        XCTAssertEqual(viewModelUnderTest.contentState, .contentView)
    }
    
    func testFetchMoviesError() async throws {
        
        // Configure mock -> error
        let testError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        mockInteractor.mockGetMoviesResult = .failure(testError)
        
        // Run method to test
        await viewModelUnderTest.fetchMovies()
        
        try await Task.sleep(nanoseconds: 500_000_000)
        
        XCTAssertEqual(mockInteractor.getMoviesCallCount, 1)
        
        // Verify states
        XCTAssertEqual(viewModelUnderTest.movies.count, 0)
        XCTAssertFalse(viewModelUnderTest.isLoading)
        XCTAssertNotNil(viewModelUnderTest.error)
        
        // Verify content state
        XCTAssertEqual(viewModelUnderTest.contentState, ContentState.error(testError, {}, {} ))
    }
    
    func testDontFetchWhenAlreadyLoading() async {
        viewModelUnderTest.isLoading = true
        await viewModelUnderTest.fetchMovies()
        XCTAssertEqual(mockInteractor.getMoviesCallCount, 0)
    }
    
    func testContentStateLoading() {
        viewModelUnderTest.isLoading = true
        XCTAssertEqual(viewModelUnderTest.contentState, .loading)
    }
    
    func testContentStateError() {
        let testError = NSError(domain: "TestError", code: 123, userInfo: [NSLocalizedDescriptionKey: "Test error"])
        viewModelUnderTest.error = testError
        XCTAssertEqual(viewModelUnderTest.contentState, .error(testError, {}, {} ))
    }
}

// MARK: - MoviesInteractorTests

final class MoviesInteractorTests: XCTestCase {
    
    var interactorUnderTest: MoviesInteractor!
    var mockService: MockMoviesService!
    
    override func setUp() {
        super.setUp()
        mockService = MockMoviesService()
        interactorUnderTest = MoviesInteractor(service: mockService)
    }
    
    override func tearDown() {
        interactorUnderTest = nil
        mockService = nil
        super.tearDown()
    }
    
    func testGetMoviesSuccess() async throws {
        
        let mockMovies = Movie.getMockMovies
        
        let expectedResponse = MovieResponse(
            page: 1,
            totalPages: 1,
            totalResults: mockMovies.count,
            results: mockMovies
        )
        
        mockService.mockGetMoviesResult = .success(expectedResponse)
        
        // Run method to test
        let result = try await interactorUnderTest.getMovies(page: 1)
        
        // Verify method was called
        XCTAssertEqual(mockService.getMoviesCallCount, 1)
        
        // Verify result
        XCTAssertEqual(result.page, expectedResponse.page)
        XCTAssertEqual(result.totalPages, expectedResponse.totalPages)
        XCTAssertEqual(result.totalResults, expectedResponse.totalResults)
        XCTAssertEqual(result.results.count, expectedResponse.results.count)
        XCTAssertEqual(result.results[0].id, expectedResponse.results[0].id)
        XCTAssertEqual(result.results[0].title, expectedResponse.results[0].title)
    }
    
    func testGetMoviesError() async {
        
        let testError = NetworkError.notFound
        mockService.mockGetMoviesResult = .failure(testError)
        
        // Run method to test and wait for error
        do {
            _ = try await interactorUnderTest.getMovies(page: 1)
            XCTFail("Expected error but got success")
            
        } catch {
            // Verify was called
            XCTAssertEqual(mockService.getMoviesCallCount, 1)
            // Verify error type
            XCTAssertEqual(error as? NetworkError, testError)
        }
    }
}

// MARK: - MoviesServiceTests

final class MoviesServiceTests: XCTestCase {
    
    var service: MoviesService!
    var mockClient: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        mockClient = MockAPIClient()
        service = MoviesService(client: mockClient)
    }
    
    override func tearDown() {
        service = nil
        mockClient = nil
        super.tearDown()
    }
    
    func testGetMoviesSuccess() async throws {
        
        guard let url = Bundle.main.url(forResource: "MockResponse", withExtension: "json"),
              let jsonData = try? Data(contentsOf: url) else {
            XCTFail("Failed to load MockResponse.json")
            return
        }
        
        mockClient.mockResponse = jsonData
        
        let result = try await service.getMovies(page: 1)
        
        XCTAssertEqual(mockClient.requestCallCount, 1)
        
        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.totalPages, 500)
        XCTAssertEqual(result.totalResults, 10000)
        XCTAssertEqual(result.results.count, 20)
        
        if let firstMovie = result.results.first {
            XCTAssertEqual(firstMovie.id, 1084199)
            XCTAssertEqual(firstMovie.title, "Companion")
            
        } else {
            XCTFail("First movie is missing from results")
        }
    }
    
    func testGetMoviesRequestError() async {
        
        mockClient.mockError = NSError(domain: "NetworkError", code: 404, userInfo: nil)
        
        do {
            _ = try await service.getMovies(page: 1)
            XCTFail("Expected error but got success")
            
        } catch {
            XCTAssertEqual(mockClient.requestCallCount, 1)
            XCTAssertEqual(error as? NetworkError, NetworkError.notFound)
        }
    }
    
    func testGetMoviesDecodingError() async {
        
        mockClient.mockResponse = "Invalid JSON data".data(using: .utf8)!
        
        do {
            _ = try await service.getMovies(page: 1)
            XCTFail("Expected error but got success")
            
        } catch {
            XCTAssertEqual(mockClient.requestCallCount, 1)
            XCTAssertEqual(error as? NetworkError, NetworkError.decodeError)
        }
    }
}
