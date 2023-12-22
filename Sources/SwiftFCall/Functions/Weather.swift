import Foundation

public struct Weather: FunctionCallable {
    public let id = "get_weather"
    public let jsonSchema = """
    {
        "id": "get_weather",
        "description": "Get the current weather given a location.",
        "parameters": {
            "type": "object",
            "properties": {
                "location": {
                    "type": "str"
                }
            }
        }
    }
    """

    public init() {}

    public func callAsFunction(_ input: [String: Any]) async throws -> [String: Any] {
        guard let location = input["location"] as? String else {
            throw FunctionError.invalidInput
        }
        return ["result": "It's sunny in \(location) today!"]
    }
}
