#!/bin/bash

# Universal Kotlin Test Runner
# Usage: ./run_tests_kt.sh <test_file.json> <solution_file.kt>

if [ $# -ne 2 ]; then
    echo "Usage: $0 <test_file.json> <solution_file.kt>"
    exit 1
fi

TEST_FILE=$1
SOLUTION_FILE=$2

echo "🧪 Testing Kotlin solution: $SOLUTION_FILE"
echo "📋 Using test file: $TEST_FILE"

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Copy files to temp directory
cp "$SOLUTION_FILE" "$TEMP_DIR/Solution.kt"
cp "$TEST_FILE" "$TEMP_DIR/test.json"

cd "$TEMP_DIR"

# Create a universal test runner with simpler JSON parsing
cat > TestRunner.kt << 'EOF'
import java.io.File
import kotlin.reflect.full.primaryConstructor
import kotlin.reflect.full.memberFunctions
import kotlin.reflect.KParameter

fun main(args: Array<String>) {
    val testFile = args[0]
    val testCases = parseJsonFile(testFile)
    val solutionClass = Class.forName("Solution").kotlin
    val solution = solutionClass.primaryConstructor?.call() ?: solutionClass.objectInstance

    // Dynamically detect the method to call
    val method = findTestMethod(solutionClass, testCases.firstOrNull())
        ?: throw Exception("No suitable method found in Solution class")

    var passedTests = 0
    val totalTests = testCases.size
    
    for ((i, testCase) in testCases.withIndex()) {
        val input = testCase["input"] as? Map<String, Any?> 
            ?: throw Exception("Invalid test case format: missing or invalid input")
        val expected = testCase["expected"]
        
        try {
            val methodArgs = prepareMethodArguments(method, input)
            val actual = method.call(solution, *methodArgs.toTypedArray())
            
            if (compareResults(actual, expected)) {
                passedTests++
            } else {
                println("❌ Test case "+(i+1)+" failed")
                println("   Input: $input")
                println("   Expected: $expected, Got: $actual")
                System.exit(1)
            }
        } catch (e: Exception) {
            println("❌ Test case "+(i+1)+" failed with error: ${e.message}")
            println("   Input: $input")
            System.exit(1)
        }
    }
    println("✅ Passed $passedTests/$totalTests test cases")
}

fun findTestMethod(solutionClass: kotlin.reflect.KClass<*>, firstTestCase: Map<String, Any?>?): kotlin.reflect.KFunction<*>? {
    val inputKeys = (firstTestCase?.get("input") as? Map<*, *>)?.keys?.map { it.toString() } ?: emptyList()
    
    // Try to find method by parameter names first
    solutionClass.memberFunctions.forEach { fn ->
        val params = fn.parameters.filter { it.kind == KParameter.Kind.VALUE }
        if (params.size == inputKeys.size && params.map { it.name } == inputKeys) {
            return fn
        }
    }
    
    // Fallback: find by parameter count
    return solutionClass.memberFunctions.firstOrNull { fn ->
        fn.parameters.count { it.kind == KParameter.Kind.VALUE } == inputKeys.size
    }
}

fun prepareMethodArguments(method: kotlin.reflect.KFunction<*>, input: Map<String, Any?>): List<Any?> {
    return method.parameters.filter { it.kind == KParameter.Kind.VALUE }.map { param ->
        val value = input[param.name]
        convertValue(value, param.type.toString())
    }
}

fun convertValue(value: Any?, targetType: String): Any? {
    return when {
        value is List<*> && targetType.contains("IntArray") -> {
            val numberList = value.filterIsInstance<Number>()
            numberList.map { it.toInt() }.toIntArray()
        }
        value is List<*> && targetType.contains("Array") -> {
            value.toTypedArray()
        }
        value is Number && targetType.contains("Int") -> {
            value.toInt()
        }
        value is Number && targetType.contains("Long") -> {
            value.toLong()
        }
        value is Number && targetType.contains("Double") -> {
            value.toDouble()
        }
        else -> value
    }
}

fun compareResults(actual: Any?, expected: Any?): Boolean {
    return when {
        actual is IntArray && expected is List<*> -> {
            val expectedNumbers = expected.filterIsInstance<Number>()
            actual.contentEquals(expectedNumbers.map { it.toInt() }.toIntArray())
        }
        actual is Array<*> && expected is List<*> -> {
            actual.contentEquals(expected.toTypedArray())
        }
        else -> actual == expected
    }
}

fun parseJsonFile(filename: String): List<Map<String, Any?>> {
    val content = File(filename).readText()
    return parseJson(content)
}

fun parseJson(json: String): List<Map<String, Any?>> {
    // Simple JSON parser for basic structures
    val trimmed = json.trim()
    if (!trimmed.startsWith("[") || !trimmed.endsWith("]")) {
        throw Exception("Expected JSON array")
    }
    
    val content = trimmed.substring(1, trimmed.length - 1).trim()
    if (content.isEmpty()) return emptyList()
    
    val result = mutableListOf<Map<String, Any?>>()
    var i = 0
    var depth = 0
    var start = -1
    
    while (i < content.length) {
        val char = content[i]
        when (char) {
            '{' -> {
                if (depth == 0) start = i
                depth++
            }
            '}' -> {
                depth--
                if (depth == 0 && start != -1) {
                    val objStr = content.substring(start, i + 1)
                    result.add(parseObject(objStr))
                    start = -1
                }
            }
        }
        i++
    }
    
    return result
}

fun parseObject(objStr: String): Map<String, Any?> {
    val result = mutableMapOf<String, Any?>()
    val content = objStr.substring(1, objStr.length - 1).trim()
    
    var i = 0
    while (i < content.length) {
        // Skip whitespace
        while (i < content.length && content[i].isWhitespace()) i++
        if (i >= content.length) break
        
        // Find key
        if (content[i] != '"') break
        i++
        val keyStart = i
        while (i < content.length && content[i] != '"') i++
        if (i >= content.length) break
        val key = content.substring(keyStart, i)
        i++
        
        // Skip whitespace and colon
        while (i < content.length && (content[i].isWhitespace() || content[i] == ':')) i++
        if (i >= content.length) break
        
        // Parse value
        val value: Any? = when (content[i]) {
            '"' -> {
                i++
                val valueStart = i
                while (i < content.length && content[i] != '"') i++
                if (i >= content.length) break
                val str = content.substring(valueStart, i)
                i++
                str
            }
            '[' -> {
                val arrayStart = i
                var depth = 0
                do {
                    when (content[i]) {
                        '[' -> depth++
                        ']' -> depth--
                    }
                    i++
                } while (depth > 0 && i < content.length)
                parseArray(content.substring(arrayStart, i))
            }
            '{' -> {
                val objStart = i
                var depth = 0
                do {
                    when (content[i]) {
                        '{' -> depth++
                        '}' -> depth--
                    }
                    i++
                } while (depth > 0 && i < content.length)
                parseObject(content.substring(objStart, i))
            }
            't' -> {
                if (content.substring(i).startsWith("true")) {
                    i += 4
                    true
                } else break
            }
            'f' -> {
                if (content.substring(i).startsWith("false")) {
                    i += 5
                    false
                } else break
            }
            'n' -> {
                if (content.substring(i).startsWith("null")) {
                    i += 4
                    null
                } else break
            }
            else -> {
                // Number
                val numStart = i
                while (i < content.length && (content[i].isDigit() || content[i] == '-' || content[i] == '.')) i++
                val numStr = content.substring(numStart, i)
                if (numStr.contains(".")) numStr.toDouble() else numStr.toInt()
            }
        }
        
        result[key] = value
        
        // Skip comma and whitespace
        while (i < content.length && (content[i].isWhitespace() || content[i] == ',')) i++
    }
    
    return result
}

fun parseArray(arrayStr: String): List<Any?> {
    val result = mutableListOf<Any?>()
    val content = arrayStr.substring(1, arrayStr.length - 1).trim()
    
    if (content.isEmpty()) return result
    
    var i = 0
    while (i < content.length) {
        // Skip whitespace
        while (i < content.length && content[i].isWhitespace()) i++
        if (i >= content.length) break
        
        // Parse value
        val value: Any? = when (content[i]) {
            '"' -> {
                i++
                val valueStart = i
                while (i < content.length && content[i] != '"') i++
                if (i >= content.length) break
                val str = content.substring(valueStart, i)
                i++
                str
            }
            '[' -> {
                val arrayStart = i
                var depth = 0
                do {
                    when (content[i]) {
                        '[' -> depth++
                        ']' -> depth--
                    }
                    i++
                } while (depth > 0 && i < content.length)
                parseArray(content.substring(arrayStart, i))
            }
            '{' -> {
                val objStart = i
                var depth = 0
                do {
                    when (content[i]) {
                        '{' -> depth++
                        '}' -> depth--
                    }
                    i++
                } while (depth > 0 && i < content.length)
                parseObject(content.substring(objStart, i))
            }
            't' -> {
                if (content.substring(i).startsWith("true")) {
                    i += 4
                    true
                } else break
            }
            'f' -> {
                if (content.substring(i).startsWith("false")) {
                    i += 5
                    false
                } else break
            }
            'n' -> {
                if (content.substring(i).startsWith("null")) {
                    i += 4
                    null
                } else break
            }
            else -> {
                // Number
                val numStart = i
                while (i < content.length && (content[i].isDigit() || content[i] == '-' || content[i] == '.')) i++
                val numStr = content.substring(numStart, i)
                if (numStr.contains(".")) numStr.toDouble() else numStr.toInt()
            }
        }
        
        result.add(value)
        
        // Skip comma and whitespace
        while (i < content.length && (content[i].isWhitespace() || content[i] == ',')) i++
    }
    
    return result
}
EOF

# Compile the solution
echo "🔨 Compiling Kotlin files..."
kotlinc Solution.kt TestRunner.kt -include-runtime -d test-runner.jar

if [ $? -ne 0 ]; then
    echo "❌ Compilation failed"
    exit 1
fi

# Run the test
echo "🚀 Running tests..."
java -cp test-runner.jar TestRunnerKt test.json

if [ $? -eq 0 ]; then
    echo "✅ Kotlin tests completed successfully"
else
    echo "❌ Kotlin tests failed"
    exit 1
fi 