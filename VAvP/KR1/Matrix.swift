//
//  Matrix.swift
//  
//
//  Created by Vlados iOS on 1/30/19.
//

import Foundation

protocol Resulter {
    func printResult(resultName: String, result: [[Int]])
}

extension Resulter {
    func printResult(resultName: String, result: [[Int]]) {
        print(resultName)
        result.forEach { line in
            print(line)
        }
        print()
    }
}

protocol IPopulator {
    associatedtype TypeToPopulate
    
    func populate(_ type: inout TypeToPopulate)
}

protocol IMatrixPopulator: IPopulator where TypeToPopulate == [[Int]] {
    func populate(_ type: inout TypeToPopulate)
}

final class MatrixPopulator: IMatrixPopulator {
    func populate(_ type: inout TypeToPopulate) {
        type = type.map { line -> [Int] in
            line.map({ element -> Int in
                return Int(arc4random_uniform(10))
            })
        }
    }
}

protocol ITransposition {
    func transposite()
}

protocol IMatrixAddition {
    func add()
    func showResult()
}

protocol IMatrixMultiplication {
    func multiply()
    func showResult()
}

final class Transposition: ITransposition, Resulter {
    private var originalMatrix: [[Int]]
    private var finalMatrix: [[Int]]
    
    init(numberOfLines: Int, numberOfColumn: Int) {
        originalMatrix = Array(repeating: Array(repeating: 0, count: numberOfColumn), count: numberOfLines)
        finalMatrix = Array(repeating: Array(repeating: 0, count: numberOfLines), count: numberOfColumn)
        
        originalMatrix = originalMatrix.map { line -> [Int] in
            line.map({ element -> Int in
                return Int(arc4random_uniform(10))
            })
        }
    }
    
    func transposite() {
        for (lineIndex, line) in originalMatrix.enumerated() {
            for columnIndex in 0..<line.count {
                finalMatrix[columnIndex][lineIndex] = originalMatrix[lineIndex][columnIndex]
            }
        }
        
        printResult(resultName: "Original matrix", result: originalMatrix)
        printResult(resultName: "Tranposited matrix", result: finalMatrix)
    }
}

let transposition: ITransposition = Transposition(numberOfLines: 6, numberOfColumn: 9)
transposition.transposite()



final class MatrixAddition: IMatrixAddition, Resulter {
    // MARK: - Helpers
    private let matrixPopulator = MatrixPopulator()
    
    // MARK: - Properties
    private var firstMatrix: [[Int]]
    private var secondMatrix: [[Int]]
    private var sumMatrix: [[Int]]
    
    init(numberOfLines: Int, numberOfColumn: Int) {
        firstMatrix = Array(repeating: Array(repeating: 0, count: numberOfColumn), count: numberOfLines)
        secondMatrix = Array(repeating: Array(repeating: 0, count: numberOfColumn), count: numberOfLines)
        sumMatrix = Array(repeating: Array(repeating: 0, count: numberOfColumn), count: numberOfLines)
        
        matrixPopulator.populate(&firstMatrix)
        matrixPopulator.populate(&secondMatrix)
        
        printResult(resultName: "first", result: firstMatrix)
        printResult(resultName: "second", result: secondMatrix)
    }
    
    func add() {
        for (lineIndex, line) in firstMatrix.enumerated() {
            for columnIndex in 0..<line.count {
                sumMatrix[lineIndex][columnIndex] = firstMatrix[lineIndex][columnIndex] + secondMatrix[lineIndex][columnIndex]
            }
        }
    }
    
    func showResult() {
        printResult(resultName: "sum", result: sumMatrix)
    }
}

let matrixAddition: IMatrixAddition = MatrixAddition(numberOfLines: 5, numberOfColumn: 5)
matrixAddition.add()
matrixAddition.showResult()


class BaseMatrixMultiplication: IMatrixMultiplication, Resulter {
    // MARK: - Helpers
    private let matrixPopulator = MatrixPopulator()
    
    // MARK: - Properties
    var firstMatrix: [[Int]]
    var secondMatrix: [[Int]]
    var resultMatrix: [[Int]]
    
    let numberOfLines: Int
    let numberOfColumn: Int
    let numberOfFirstMatrixColumn: Int
    
    init(numberOfFirstMatrixLines: Int, numberOfFirstMatrixColumn: Int, numberOfSecondMatrixColumn: Int) {
        firstMatrix = Array(repeating: Array(repeating: 0, count: numberOfFirstMatrixColumn), count: numberOfFirstMatrixLines)
        secondMatrix = Array(repeating: Array(repeating: 0, count: numberOfSecondMatrixColumn), count: numberOfFirstMatrixColumn)
        
        self.numberOfLines = numberOfFirstMatrixLines
        self.numberOfColumn = numberOfSecondMatrixColumn
        self.numberOfFirstMatrixColumn = numberOfFirstMatrixColumn
        resultMatrix = Array(repeating: Array(repeating: 0, count: numberOfColumn), count: numberOfLines)
        
        matrixPopulator.populate(&firstMatrix)
        matrixPopulator.populate(&secondMatrix)
        
        printResult(resultName: "first", result: firstMatrix)
        printResult(resultName: "second", result: secondMatrix)
    }
    
    func multiply() { }
    func showResult() { }
}

final class MatrixMultiplication: BaseMatrixMultiplication {
    override func multiply() {
        for lineIndex in 0..<numberOfLines {
            for columnIndex in 0..<numberOfColumn {
                for index in 0..<numberOfFirstMatrixColumn {
                    resultMatrix[lineIndex][columnIndex] += firstMatrix[lineIndex][index] * secondMatrix[index][columnIndex]
                }
            }
        }
    }
    
    override func showResult() {
        printResult(resultName: "result", result: resultMatrix)
    }
}

let matrixMultiplication: IMatrixMultiplication = MatrixMultiplication(numberOfFirstMatrixLines: 1, numberOfFirstMatrixColumn: 2, numberOfSecondMatrixColumn: 3)
matrixMultiplication.multiply()
matrixMultiplication.showResult()

final class VinogradovMultiplication: BaseMatrixMultiplication {
    var rowFactor: [Int]
    var columnFactor: [Int]
    
    override init(numberOfFirstMatrixLines: Int, numberOfFirstMatrixColumn: Int, numberOfSecondMatrixColumn: Int) {
        rowFactor = [Int].init(repeating: 0, count: numberOfSecondMatrixColumn)
        columnFactor = [Int].init(repeating: 0, count: numberOfSecondMatrixColumn)
        
        super.init(numberOfFirstMatrixLines: numberOfFirstMatrixLines, numberOfFirstMatrixColumn: numberOfFirstMatrixColumn, numberOfSecondMatrixColumn: numberOfSecondMatrixColumn)
    }
    
    override func multiply() {
        let d = numberOfFirstMatrixColumn / 2
        
        // вычисление rowFactors
        for lineIndex in 0..<numberOfLines {
            rowFactor[lineIndex] = firstMatrix[lineIndex][0] * firstMatrix[lineIndex][1]
            for index in 1..<d {
                rowFactor[lineIndex] += firstMatrix[lineIndex][2 * index - 1] * firstMatrix[lineIndex][2 * index]
            }
        }
        
        // вычисление columnFactors
        for columnIndex in 0..<numberOfColumn {
            columnFactor[columnIndex] = secondMatrix[0][columnIndex] * secondMatrix[1][columnIndex]
            for index in 1..<d {
                columnFactor[columnIndex] += secondMatrix[2 * index - 1][columnIndex] * secondMatrix[2 * index][columnIndex]
            }
        }
        
        // вычисление матрицы R
        for lineIndex in 0..<numberOfLines {
            for columnIndex in 0..<numberOfColumn {
                resultMatrix[lineIndex][columnIndex] = -rowFactor[lineIndex] - columnFactor[columnIndex]
                for index in 0..<d {
                    let firstComponent = firstMatrix[lineIndex][2 * index + 1] + secondMatrix[2 * index][columnIndex]
                    let secondComponent = firstMatrix[lineIndex][2 * index] + secondMatrix[2 * index + 1][columnIndex]
                    resultMatrix[lineIndex][columnIndex] += firstComponent * secondComponent
                }
            }
        }
        
        // прибавление членов в случае нечетной общей размерности
        if numberOfFirstMatrixColumn % 2 == 1 {
            for lineIndex in 0..<numberOfLines {
                for columnIndex in 0..<numberOfColumn {
                    resultMatrix[lineIndex][columnIndex] += firstMatrix[lineIndex][numberOfLines - 1] * secondMatrix[numberOfLines - 1][columnIndex]
                }
            }
        }
    }
    
    override func showResult() {
        printResult(resultName: "result", result: resultMatrix)
    }
}

let vinogradovMultiplication: IMatrixMultiplication = VinogradovMultiplication(numberOfFirstMatrixLines: 1, numberOfFirstMatrixColumn: 2, numberOfSecondMatrixColumn: 2)
vinogradovMultiplication.multiply()
vinogradovMultiplication.showResult()


final class ShtrassenMultiplication: BaseMatrixMultiplication {
    override func multiply() {
        firstMatrix = equalize(matrix: firstMatrix)
        secondMatrix = equalize(matrix: secondMatrix)
        
        printResult(resultName: "first equalized", result: firstMatrix)
        printResult(resultName: "second equalized", result: secondMatrix)
        
        asd(firstMatrixCopy: firstMatrix, secondMatrixCopy: secondMatrix)
    }
    
    override func showResult() {
        printResult(resultName: "result", result: resultMatrix)
    }
    
    private func asd(firstMatrixCopy: [[Int]], secondMatrixCopy: [[Int]]) {
        //for index in stride(from: 0, to: firstMatrixCopy.count, by: firstMatrixCopy.count / 2) {
        if firstMatrixCopy.count > 2 {
            let firstDivideResult = divide(matrix: firstMatrixCopy)
            let f1 = firstDivideResult.m1
            let f2 = firstDivideResult.m2
            let f3 = firstDivideResult.m3
            let f4 = firstDivideResult.m4
            
            let secondDivideResult = divide(matrix: secondMatrixCopy)
            let s1 = secondDivideResult.m1
            let s2 = secondDivideResult.m2
            let s3 = secondDivideResult.m3
            let s4 = secondDivideResult.m4
            
            asd(firstMatrixCopy: f1, secondMatrixCopy: s1)
            asd(firstMatrixCopy: f2, secondMatrixCopy: s2)
            asd(firstMatrixCopy: f3, secondMatrixCopy: s3)
            asd(firstMatrixCopy: f4, secondMatrixCopy: s4)
        }
        else {
            let firstMatrixEqulized = equalize(matrix: firstMatrixCopy)
            let secondMatrixEqulized = equalize(matrix: secondMatrixCopy)
            
            shtrassenMultiplication(firstMatrix: firstMatrixEqulized, secondMatrix: secondMatrixEqulized)
        }
        //}
    }
    
    private func equalize(matrix: [[Int]]) -> [[Int]] {
        var matrixCopy = matrix
        if matrixCopy[0].count % 2 != 0 {
            matrixCopy = matrixCopy.map { line -> [Int] in
                var newLine = line
                newLine.append(0)
                return newLine
            }
        }
        if matrixCopy.count % 2 != 0 {
            matrixCopy.append([Int].init(repeating: 0, count: matrixCopy[0].count))
        }
        
        return matrixCopy
    }
    
    private func divide(matrix: [[Int]]) -> (m1: [[Int]], m2: [[Int]], m3: [[Int]], m4: [[Int]]) {
        var matrixCopy = matrix
        matrixCopy = equalize(matrix: matrix)
        
        let divideFactor = (matrix.count + 1) / 2
        var m1 = Array(repeating: Array(repeating: 0, count: divideFactor), count: divideFactor)
        var m2 = Array(repeating: Array(repeating: 0, count: divideFactor), count: divideFactor)
        var m3 = Array(repeating: Array(repeating: 0, count: divideFactor), count: divideFactor)
        var m4 = Array(repeating: Array(repeating: 0, count: divideFactor), count: divideFactor)
        
        for (lineIndex, line) in matrix.enumerated() {
            for (columnIndex, column) in line.enumerated() {
                if lineIndex < divideFactor {
                    if columnIndex < divideFactor {
                        m1[lineIndex][columnIndex] = matrix[lineIndex][columnIndex]
                    }
                    else {
                        m2[lineIndex][columnIndex - divideFactor] = matrix[lineIndex][columnIndex]
                    }
                }
                else {
                    if columnIndex < divideFactor {
                        m3[lineIndex - divideFactor][columnIndex] = matrix[lineIndex][columnIndex]
                    }
                    else {
                        m4[lineIndex - divideFactor][columnIndex - divideFactor] = matrix[lineIndex][columnIndex]
                    }
                }
            }
        }
        
        printResult(resultName: "piece of that", result: matrixCopy)
        printResult(resultName: "is that", result: m1)
        printResult(resultName: "and", result: m2)
        printResult(resultName: "and", result: m3)
        printResult(resultName: "and", result: m4)
        
        return (m1: m1, m2: m2, m3: m3, m4: m4)
    }
    
    
    
    private func shtrassenMultiplication(firstMatrix: [[Int]], secondMatrix: [[Int]]) {
        let x1 = (firstMatrix[0][0] + firstMatrix[1][1]) * (secondMatrix[0][0] + secondMatrix[1][1])
        let x2 = (firstMatrix[1][0] + firstMatrix[1][1]) * secondMatrix[0][0]
        let x3 = firstMatrix[0][0] * (secondMatrix[0][1] - secondMatrix[1][1])
        let x4 = firstMatrix[1][1] * (secondMatrix[1][0] - secondMatrix[0][0])
        let x5 = (firstMatrix[0][0] + firstMatrix[0][1]) * secondMatrix[1][1]
        let x6 = (firstMatrix[1][0] - firstMatrix[0][0]) * (secondMatrix[0][0] + secondMatrix[0][1])
        let x7 = (firstMatrix[0][1] - firstMatrix[1][1]) * (secondMatrix[1][0] + secondMatrix[1][1])
        
        var result = Array(repeating: Array(repeating: 0, count: 2), count: 2)
        
        result[0][0] = x1 + x4 - x5 + x7
        result[0][1] = x3 + x5
        result[1][0] = x2 + x4
        result[1][1] = x1 - x2 + x3 + x6
        
        printResult(resultName: "shtrassen result", result: result)
    }
}

let shtrassenMultiplication: IMatrixMultiplication = ShtrassenMultiplication(numberOfFirstMatrixLines: 4, numberOfFirstMatrixColumn: 4, numberOfSecondMatrixColumn: 4)
shtrassenMultiplication.multiply()
shtrassenMultiplication.showResult()
