import Foundation

public enum Generate {}

extension Generate {
    public struct Input: Codable {
        public var model: String
        public var prompt: String
        public var stream: Bool

        public init(model: String, prompt: String, stream: Bool) {
            self.model = model
            self.prompt = prompt
            self.stream = stream
        }
    }
}

extension Generate {
    public struct ModelResponse: Codable {
        public var response: String

        public init(response: String) {
            self.response = response
        }

        public var json: [String: Any]? {
            guard let data = response.data(using: .utf8) else { return nil }
            return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        }
    }
}
