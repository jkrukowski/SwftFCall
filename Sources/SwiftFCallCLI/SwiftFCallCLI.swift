import ArgumentParser
import Foundation
import Logging
import SwiftFCall

private var logger = Logger(label: "SwiftFCall")

@main
struct SwiftFCallCLI: AsyncParsableCommand {
    func run() async throws {
        logger.logLevel = .debug
        let functionMatcher = FunctionMatcher()
        functionMatcher.register(MortgagePayment())
        let llmClient = LLMClient(
            model: "codellama:7b-instruct",
            functionSchemas: functionMatcher.schemas,
            baseURL: "http://localhost:11434/api"
        )
        logger.debug("Calling LLM...")
        let modelResponse = try await llmClient.generate(
            for: "Determine the monthly mortgage payment for a loan amount of $200,000, an interest rate of 4%, and a loan term of 30 years."
        )
        logger.debug("Matching function...")
        let result = try await functionMatcher.match(modelResponse.json ?? [:])
        logger.debug("Result: \(result)")
    }
}
