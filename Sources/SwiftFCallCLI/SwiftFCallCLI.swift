import ArgumentParser
import Foundation
import Logging
import SwiftFCall

private var logger = Logger(label: "SwiftFCall")

@main
struct SwiftFCallCLI: AsyncParsableCommand {
    func run() async throws {
        let inputs = [
            "Determine the monthly mortgage payment for a loan amount of $200,000, an interest rate of 4%, and a loan term of 30 years.",
            "What's the weather in London, UK?"
        ]
        logger.logLevel = .debug
        let functionMatcher = FunctionMatcher()
        await functionMatcher.register(MortgagePayment())
        await functionMatcher.register(Weather())
        let llmClient = await LLMClient(
            model: "codellama:7b-instruct",
            functionSchemas: functionMatcher.schemas,
            baseURL: "http://localhost:11434/api"
        )
        for input in inputs {
            logger.debug("Calling LLM...")
            let modelResponse = try await llmClient.generate(for: input)
            logger.debug("Matching function...")
            let result = await functionMatcher.match(modelResponse.json ?? [:])
            logger.debug("Result: \(result)")
        }
    }
}
