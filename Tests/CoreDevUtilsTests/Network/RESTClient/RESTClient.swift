//
//  
//  

import XCTest
@testable import CoreDevUtils

private struct SampleResponse: Codable {
    let text: String
}

private struct MockPath: Path {
    func asURL(parameters: [String : String]) -> URL {
        return URL(string: "/sample")!
    }
}

class RESTClientTest: XCTestCase {
    
    func testGetRequest() {
        let srcSample = SampleResponse(text: "Sample Text")
        let path = MockPath()
        let response = HTTPURLResponse(url: path.asURL(parameters: [:]),
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let data = try! JSONEncoder().encode(srcSample)
        
        let mockSession = MockURLSession(data: data, response: response, error: nil)
        let getClient = RESTClient(
            baseURL: "https://127.0.0.1",
            session: mockSession
            )
        
        getClient.get(path: MockPath()) {
            switch $0 {
            case .success(let response):
                let sample: SampleResponse = try! JSONDecoder().decode(SampleResponse.self, from: response.data!)
                XCTAssertEqual(sample.text, srcSample.text)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    
    func testPostRequest() {
        let srcSample = SampleResponse(text: "Sample Text")
        let path = MockPath()
        let response = HTTPURLResponse(url: path.asURL(parameters: [:]),
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let data = try! JSONEncoder().encode(srcSample)
        
        let mockSession = MockURLSession(data: data, response: response, error: nil)
        let getClient = RESTClient(
            baseURL: "https://127.0.0.1",
            session: mockSession
            )
        
        getClient.post(path: MockPath(), data: nil) {
            switch $0 {
            case .success(let response):
                let sample: SampleResponse = try! JSONDecoder().decode(SampleResponse.self, from: response.data!)
                XCTAssertEqual(sample.text, srcSample.text)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testPutRequest() {
        let srcSample = SampleResponse(text: "Sample Text")
        let path = MockPath()
        let response = HTTPURLResponse(url: path.asURL(parameters: [:]),
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let data = try! JSONEncoder().encode(srcSample)
        
        let mockSession = MockURLSession(data: data, response: response, error: nil)
        let getClient = RESTClient(
            baseURL: "https://127.0.0.1",
            session: mockSession
            )
        
        getClient.put(path: MockPath(), data: nil) {
            switch $0 {
            case .success(let response):
                let sample: SampleResponse = try! JSONDecoder().decode(SampleResponse.self, from: response.data!)
                XCTAssertEqual(sample.text, srcSample.text)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
    
    func testDeleteRequest() {
        let srcSample = SampleResponse(text: "Sample Text")
        let path = MockPath()
        let response = HTTPURLResponse(url: path.asURL(parameters: [:]),
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: nil)
        let data = try! JSONEncoder().encode(srcSample)
        
        let mockSession = MockURLSession(data: data, response: response, error: nil)
        let getClient = RESTClient(
            baseURL: "https://127.0.0.1",
            session: mockSession
            )
        
        getClient.put(path: MockPath(), data: nil) {
            switch $0 {
            case .success(let response):
                let sample: SampleResponse = try! JSONDecoder().decode(SampleResponse.self, from: response.data!)
                XCTAssertEqual(sample.text, srcSample.text)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
    }
}
