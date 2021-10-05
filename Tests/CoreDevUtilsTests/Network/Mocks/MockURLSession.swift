//
//  
//  

import Foundation

private class MockURLSessionDataTask: URLSessionDataTask {
    private let data: Data?
    private let _response: URLResponse?
    private let _error: Error?
    
    override var response: URLResponse? {
        _response
    }
    
    override var error: Error? {
        _error
    }
    
    var completionHandler: ((Data?, URLResponse?, Error?) -> Void)?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        self.data = data
        self._response = response
        self._error = error
    }
    
    override func resume() {
        completionHandler?(data, response, error)
    }
}

class MockURLSession: URLSession {
    private let mockTask: MockURLSessionDataTask
    private var url: URL?
    
    init(data: Data?, response: URLResponse?, error: Error?) {
        mockTask = MockURLSessionDataTask(
            data: data,
            response: response,
            error: error
        )
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        self.url = url
        mockTask.completionHandler = completionHandler
        return mockTask
    }
}
