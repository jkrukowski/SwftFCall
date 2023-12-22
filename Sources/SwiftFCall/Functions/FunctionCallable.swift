import Foundation

public protocol FunctionCallable {
    var id: String { get }
    var jsonSchema: String { get }

    func callAsFunction(_ input: [String: Any]) async throws -> [String: Any]
}
