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


if let parsedRules = compiler.parseRules().right {

    let compileResult = compiler.compile().foldRight { nodes -> () in
        return compiler.run(input: nodes, rules: parsedRules)
    }

}

