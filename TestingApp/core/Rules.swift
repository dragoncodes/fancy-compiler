//
// Created by dragoncodes on 25.04.18.

import Foundation

class RuleParser {

    private let rulesFilePath: String

    var rules = [RuleNode]()

    init(rulesFilePath: String) {
        self.rulesFilePath = rulesFilePath;
    }

    func parseRules() -> Bool {

        var result = true

        readFile(rulesFilePath)

                .foldLeft { _ in
                    result = false
                }

                .foldRight { fileContents -> () in

                    var parsedRuleNodes = [RuleNode]()

                    print("Rules \n")

                    fileContents.split(separator: "\n").forEach { substring in

                        if substring.starts(with: "#") {
                            return
                        }

                        let ruleComponents = substring.components(separatedBy: "=>")

                        let ruleNode = RuleNode(name: ruleComponents[0], value: ruleComponents[1])

                        // TODO rules
                        if ruleNode.name.contains(".") {
                            print(ruleNode)
                        } else {
                            parsedRuleNodes.append(ruleNode)
                        }

                        print("\(ruleNode.name) \(ruleNode.value)")

                    }

                    rules = parsedRuleNodes
                }

        return result
    }
}