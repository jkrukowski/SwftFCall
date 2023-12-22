import Foundation

public struct MortgagePayment: FunctionCallable {
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

    public init() {}

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
        _ = Input(
            loanAmount: loanAmount,
            interestRate: interestRate,
            loanTerm: loanTerm
        )
        return ["result": Float.random(in: 0 ..< 1_000)]
    }
}

extension MortgagePayment {
    struct Input: Codable {
        let loanAmount: Int
        let interestRate: Float
        let loanTerm: Int
    }
}
