//
// Created by dragoncodes on 6.04.18.

func leftHandler(error: Compiler.CompilerError) {
    print(error)
}

func rightHandler(nodes: [FancyLanguageNode]?) -> String {
    var strRes = ""
    nodes?.forEach { node in
        strRes += node.name

        if node.hasChildren {
            strRes += "\n   ";

            strRes += rightHandler(nodes: node.children)
        }
    }

    return strRes
}

let compiler = Compiler(inputFilePaths: ["testData/in.json"], rulesFilePath: "testData/rules.txt")

compiler.parseRules()
        .foldLeft { error in
            print(error)
        }
        .foldRight { parsedRulesResult in
            guard let nodes = parsedRulesResult else {

                print("error parsing rules")

                return
            }


            nodes.forEach { node in
                print(node.description)
            }
        }

//let compileResult = compiler.compile()
//
//compileResult.fold(leftHandler(error:), { nodes in
//    let parsedRes = rightHandler(nodes: nodes)
//
//    print(parsedRes)
//
//    return parsedRes
//})
