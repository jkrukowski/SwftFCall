import Foundation
import Logging

private let logger = Logger(label: "SwiftFCall")

public final class FunctionMatcher {
    private var functions: [String: any FunctionCallable]

    public init() {
        functions = [:]
    }

    public func register(_ function: any FunctionCallable) {
        functions[function.id] = function
    }

    public var schemas: [String] {
        functions.map(\.value.jsonSchema)
    }

    public func match(_ response: [String: Any]) async throws -> [String: Any] {
        guard let tools = response["tools"] as? [[String: Any]] else {
            logger.warning("No tools found in response: \(response)")
            return [:]
        }
        var results = [String: Any]()
        for tool in tools {
            guard let id = tool["id"] as? String else {
                logger.warning("No id found in tool: \(tool)")
                continue
            }
            guard let input = tool["input"] as? [String: Any] else {
                logger.warning("No input found in tool: \(tool)")
                continue
            }
            guard let function = functions[id] else {
                logger.warning("No function found for id: \(id)")
                continue
            }
            logger.debug("Found function: \(id)")
            do {
                results[id] = try await function(input)
            } catch {
                logger.error("Error calling function: \(error) \(input)")
            }
        }
        return results
    }
}
