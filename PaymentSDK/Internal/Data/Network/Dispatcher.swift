//
//  Dispatcher.swift
//  PaymentSDK
//
//  Created by Maksims Moisja on 20/02/2025.
//

class Dispatcher<T: TargetType> {

    private let logger: LoggerService
    private let provider: NetworkService

    var apiToken: String? {
        didSet {
            logger.log(event: "Did set API token")
        }
    }

    init(logger: LoggerService, provider: NetworkService = URLSession.shared) {
        self.provider = provider
        self.logger = logger
    }

    func execute<ResultObject: Decodable>(target: T) async throws(NetworkError) -> ResultObject {
        do {
            let request = try makeRequest(from: target)

            logger.log(
                event: "Did start network request",
                metadata: [
                    "url": request.url?.absoluteString ?? "nil",
                    "method": request.httpMethod ?? "nil",
                    "body": String(describing: try? JSONSerialization.jsonObject(with: request.httpBody ?? Data())),
                ]
            )
            let (data, response) = try await provider.data(for: makeRequest(from: target))
            logger.log(
                event: "Did end network request",
                metadata: ["response": String(describing: response as? HTTPURLResponse)]
            )

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                throw NetworkError.invalidStatusCode(-1)
            }

            guard (200...299).contains(statusCode) else {
                throw NetworkError.invalidStatusCode(statusCode)
            }

            return try JSONDecoder().decode(ResultObject.self, from: data)
        }
        catch let error as DecodingError {
            throw .decodingFailed(error)
        }
        catch let error as EncodingError {
            throw .encodingFailed(error)
        }
        catch let error as URLError {
            throw .requestFailed(error)
        }
        catch let error as NetworkError {
            throw error
        }
        catch {
            throw .otherError(error)
        }
    }

    private func makeRequest(from target: TargetType) throws -> URLRequest {
        guard let apiToken else { throw NetworkError.apiTokenNotSet }

        var urlRequest = URLRequest(url: target.baseURL.appending(path: target.path))
        urlRequest.httpMethod = target.method.rawValue

        var headers = target.headers ?? [String: String]()
        headers["Authorization"] = "Bearer \(apiToken)"

        urlRequest.allHTTPHeaderFields = headers

        switch target.task {
        case .requestJSONEncodable(let encodable):
            urlRequest.httpBody = try JSONEncoder().encode(encodable)
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        return urlRequest
    }

}
