import Foundation

public enum Prompt {}

extension Prompt {
    public struct Input: Codable {
        public var functionSchemas: [String]
        public var userQuery: String
    }
}
