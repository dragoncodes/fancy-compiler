//
// Created by dragoncodes on 6.04.18.

//func leftHandler(error: Compiler.CompilerError) {
//    print(error)
//}
//
//func rightHandler(nodes: [FancyLanguageNode]?) -> String {
//    var strRes = ""
//    nodes?.forEach { node in
//        strRes += node.name
//
//        if node.hasChildren {
//            strRes += "\n   ";
//
//            strRes += rightHandler(nodes: node.children)
//        }
//    }
//
//    return strRes
//}

func run() {


    let ruleParser = RuleParser(rulesFilePath: "testData/rules.txt")
    let compiler = Compiler(inputFilePaths: ["testData/in.json"])

    guard ruleParser.parseRules() else {
        return print("Error parsing rules")
    }

//    let compilerResult = compiler.compile().foldRight { nodes -> Either<Compiler.CompilerError, String> in
//        return compiler.run(input: nodes, rules: rules)
//    }

    compiler.compile()
            .foldLeft { error in
                print("Compiler error \(error)")
            }
            .foldRight { nodes in
                let linker = Linker(input: nodes, rules: ruleParser.rules)

                linker.link()
            }
}

run()

//if let parsedRules = compiler.parseRules().right {
//
//    let compileResult = compiler.compile().foldRight { nodes -> () in
//        return compiler.run(input: nodes, rules: parsedRules)
//    }
//}

