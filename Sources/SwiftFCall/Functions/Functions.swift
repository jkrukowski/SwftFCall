import Foundation

public struct MortgagePayment: FunctionCallable {
    public struct Input: Codable {
        public let loanAmount: Int
        public let interestRate: Float
        public let loanTerm: Int
    }

    public init() {}

    public let id = "calculate_mortgage_payment"
    public let jsonSchema = """
    {
        "id": "calculate_mortgage_payment",
        "description": "Get the monthly mortgage payment given an interest rate percentage.",
        "parameters": {
            "type": "object",
            "properties": {
                "loanAmount": {
                    "type": "int"
                },
                "interestRate": {
                    "type": "float"
                },
                "loanTerm": {
                    "type": "int"
                }
            }
        }
    }
    """

    public func callAsFunction(_ input: [String: Any]) async throws -> [String: Any] {
        guard let loanAmount = input["loanAmount"] as? Int else {
            throw FunctionError.invalidInput
        }
        guard let interestRate = input["interestRate"] as? Float else {
            throw FunctionError.invalidInput
        }
        guard let loanTerm = input["loanTerm"] as? Int else {
            throw FunctionError.invalidInput
        }
        let input = Input(
            loanAmount: loanAmount,
            interestRate: interestRate,
            loanTerm: loanTerm
        )
        return ["result": 0.0]
    }
}
