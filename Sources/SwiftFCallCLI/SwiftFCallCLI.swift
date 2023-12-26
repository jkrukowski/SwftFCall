import ArgumentParser
import Foundation
import Logging
import SwiftFCall

private var logger = Logger(label: "SwiftFCall")

@main
struct SwiftFCallCLI: AsyncParsableCommand {
    @Option(help: "Ollama model to use.")
    var model: String = "codellama:7b-instruct"
    @Option(help: "Ollama API base URL.")
    var baseURL: String = "http://localhost:11434/api"

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
            model: model,
            functionSchemas: functionMatcher.schemas,
            baseURL: baseURL
        )
        let result = try await withThrowingTaskGroup(of: [String: Any].self) { group in
            var result = [String: Any]()
            for input in inputs {
                group.addTask {
                    logger.debug("Calling LLM...")
                    let modelResponse = try await llmClient.generate(for: input)
                    logger.debug("Matching function...")
                    return await functionMatcher.match(modelResponse.json ?? [:])
                }
            }
            for try await functionResult in group {
                result.merge(functionResult) { _, new in new }
            }
            return result
        }
        logger.debug("Result: \(result)")
    }
}
