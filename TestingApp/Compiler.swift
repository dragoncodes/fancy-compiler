//
//  Compiler.swift
//  FancyCompiler
//
//  Created by dragoncodes on 24.03.18.
//  Copyright © 2018 dragoncodes. All rights reserved.
//

import Foundation

class Compiler {

    private let inputFilePaths: [String]

    private let rulesFilePath: String

    init(inputFilePaths: [String], rulesFilePath: String) {
        self.inputFilePaths = inputFilePaths

        self.rulesFilePath = rulesFilePath
    }

    func parseRules() -> Either<CompilerError, [RuleNode]> {

        var rulesResults: Either<CompilerError, [RuleNode]> = Either(nil, nil)

        readFile(rulesFilePath)
                .foldLeft { error in
                    rulesResults = Either.fromLeft(error)
                }

                .foldRight { fileContents -> () in

                    var parsedRuleNodes = [RuleNode]()

                    if fileContents != nil {
                        fileContents!.split(separator: "\n").forEach { substring in

                            if substring.starts(with: "#") {
                                return
                            }

                            let ruleComponents = substring.components(separatedBy: "=>")

                            parsedRuleNodes.append(RuleNode(name: ruleComponents[0], value: ruleComponents[1]))
                        }

                        rulesResults = Either.fromRight(parsedRuleNodes)
                    }
                }

        return rulesResults
    }

    func compile() -> Either<CompilerError, [FancyLanguageNode]> {
        return self.parseInputFiles()
    }

    private func parseInputFiles() -> Either<CompilerError, [FancyLanguageNode]> {

        var result = [FancyLanguageNode]()

        for inputFile in inputFilePaths {
            let readFileData = readFile(inputFile)

            if let error = readFileData.left {
                print("error", error)
            } else if let fileContents = readFileData.right,
                      let jsonDict = parseJson(from: fileContents).right {

                let parsedResult = jsonDict.compactMap { jsonObj in
                    result.append(toNode(from: jsonObj))
                }

//                result.append(parsedResult)
            }
        }

        return Either.fromRight(result)
    }

    private func toNode(from jsonObj: JsonNode) -> FancyLanguageNode {

        // TODO swiftify this

        var result = FancyLanguageNode(name: jsonObj.key)

        if jsonObj.value is [String: Any] {

            let childObjects = jsonObj.value as! [String: Any]

            childObjects.forEach { childObj in
                result.addChild(child: toNode(from: childObj))
            }
        } else if jsonObj.value is String {

            do {
                let stringValue = try jsonObj.value as! String

                if stringValue.starts(with: "@") {
//                    result.addProperty(name: stringValue);
                }
            }
        }

        return result
    }

    private func parseJson(from: String) -> Either<CompilerError, [String: Any]> {

        guard let json = from.data(using: .utf8) else {
            return Either.fromLeft(CompilerError.fileParsingError(message: "Cannot parse file \(from)"))
        }

        do {
            return Either.fromRight(try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any])
        } catch {
            return Either.fromLeft(CompilerError.fileParsingError(message: error.localizedDescription))
        }
    }

    private func readFile(_ inputFilePath: String) -> Either<CompilerError, String> {

        guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return Either.fromLeft(CompilerError.invalidInputPath)
        }


        let fileURL = dir.appendingPathComponent(inputFilePath)

        do {
            let data = try String(contentsOf: fileURL, encoding: .utf8)

            return Either.fromRight(data)
        } catch {
            return Either.fromLeft(CompilerError.fileParsingError(message: error.localizedDescription))
        }
    }

    public func run() {

    }

    enum CompilerError: Error {
        case invalidInputPath
        case fileParsingError(message: String)
    }

    typealias JsonNode = (key: String, value: Any)
}
