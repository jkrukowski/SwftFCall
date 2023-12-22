import Foundation
import Stencil

let environment = Environment(loader: FileSystemLoader(bundle: [Bundle.module]))

public func renderTemplate(input: Prompt.Input) throws -> String {
    try environment.renderTemplate(name: "prompt.stencil", context: ["input": input])
}
