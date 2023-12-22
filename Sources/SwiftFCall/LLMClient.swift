import AsyncHTTPClient
import Foundation
import NIOCore
import NIOFoundationCompat

public final class LLMClient {
    private let model: String
    private let functionSchemas: [String]
    private let baseURL: String
    private let client: AsyncHTTPClient.HTTPClient

    deinit {
        try? client.syncShutdown()
    }

    public init(
        model: String,
        functionSchemas: [String],
        baseURL: String
    ) {
        self.model = model
        self.functionSchemas = functionSchemas
        self.baseURL = baseURL
        client = AsyncHTTPClient.HTTPClient()
    }

    public func generate(for userQuery: String) async throws -> Generate.ModelResponse {
        let promptInput = Prompt.Input(
            functionSchemas: functionSchemas,
            userQuery: userQuery
        )
        let input = try Generate.Input(
            model: model,
            prompt: renderTemplate(input: promptInput),
            stream: false
        )
        let bodyByteBuffer = try ByteBuffer(data: JSONEncoder().encode(input))
        var request = HTTPClientRequest(url: "\(baseURL)/generate")
        request.method = .POST
        request.headers = ["Content-Type": "application/json"]
        request.body = .bytes(bodyByteBuffer)
        let response = try await client.execute(request, timeout: .minutes(1))
        let body = try await response.body.collect(upTo: 1_024 * 1_024)
        return try JSONDecoder().decode(Generate.ModelResponse.self, from: Data(body.readableBytesView))
    }
}
