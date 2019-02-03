//
//  main.c
//  AdditionalTask
//
//  Created by Vlados iOS on 2/3/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

/* TASK:
 Organizing the input of a two-dimensional integer array,
 followed by sorting its columns in ascending order of sums of two middle elements
*/

/// Reads only integer numbers from keyboard stream
/// Returns: read integer number from keboard

int readElementFromKeyboard() {
    char inputElement[100];
    int element = -1;
    bool shouldShowMessage = false;
    do {
        if(shouldShowMessage == true) {
            printf("Try to input positive integer number:\n");
        }
        scanf("%s",inputElement);
        element = (int)atol(inputElement);
        shouldShowMessage = true;
    } while(element < 0);
    return element;
}

/// Allocates memory for an array
/// Params: rowSize - amount of lines in array
///         columnSize - amount of columns in array
/// Returns: New dynamic array

int **dynamicArrayAlloc(size_t rowSize, size_t columnSize)
{
    int **A = (int **)malloc(rowSize * sizeof(int *));
    for(int i = 0; i < rowSize; i++) {
        A[i] = (int *)malloc(columnSize * sizeof(int));
    }
    return A;
}

/// Fills input array with random numbers
/// Params: array - array which we send via refernce on memory
///         rowSize - amount of lines in array
///         columnSize - amount of columns in array

void populateArray(int **array, int numberOfRows, int numberOfColumns) {
    for (int i = 0; i < numberOfRows; i++) {
        for (int j = 0; j < numberOfColumns; j++) {
            printf("Input [%d][%d] element\n", i, j);
            array[i][j] = readElementFromKeyboard();
        }
    }
}

/// Prints array on console in a convenient format
/// Params: array - array which we send via refernce on memory
///         rowSize - amount of lines in array
///         columnSize - amount of columns in array

void printArray(int *array[], int numberOfRows, int numberOfColumns) {
    for (int i = 0; i < numberOfRows; i++) {
        for (int j = 0; j < numberOfColumns; j++) {
            printf("%d ", array[i][j]);
        }
        printf("\n");
    }
}

/// Swaps two values
/// Params: a - first value
///         b - second value

void swap(int a, int b) {
    int t = a;
    a = b;
    b = t;
}

/// Swaps two arrays columns
/// Params: col1 - number of first column to swap
///         col2 - number of second column to swap
void columnSwap(int **array, int col1, int col2, int numberOfRows, int numberOfColumns) {
    for(int i = 0; i < numberOfRows; i++) {
        for (int j = 0; j < numberOfColumns; j++) {
            if(j == col1) {
                int t = array[i][j];
                array[i][j] = array[i][col2];
                array[i][col2] = t;
            }
        }
    }
}

/// Sorts array by the sum of middle elements in every column
/// Params: middleElementsAmount - amount of elements in the middle of array
///         you want to add to compare them
void sortArrayByMiddleElementsSum(int *array[], int numberOfRows, int numberOfColumns, int middleElementsAmount) {
    int k = numberOfRows - middleElementsAmount;
    if(k == 0) { k = 1; }
    const int startIndexForSum = (numberOfRows / 2)/(k);
    const int endIndexForSum = startIndexForSum + middleElementsAmount - 1;
    
    int *sums = (int*)malloc(numberOfColumns * sizeof(int));
    
    // because of some issues with memory allocation
    for (int i = 0; i < numberOfColumns; i++) {
        sums[i] = 0;
    }
    
    // calculate sums of middle elenets
    for (int i = 0; i < numberOfRows; i++) {
        for (int j = 0; j < numberOfColumns; j++) {
            if(i >= startIndexForSum && i <= endIndexForSum) {
                sums[j] += array[i][j];
            }
        }
    }
    
    printf("\nsum of middle: \n");
    for (int i = 0; i < numberOfColumns; i++) {
        printf("%d ", sums[i]);
    }
    printf("\n\n");
    
    // swap columns if needed
    for (int i = 0; i < numberOfColumns; i++) {
        for (int j = 0; j < numberOfColumns; j++) {
            if(i < j && sums[i] > sums[j]) {
                swap(sums[i], sums[j]);
                columnSwap(array, i, j, numberOfRows, numberOfColumns);
            }
        }
    }
    
    free(sums);
}

int main(int argc, const char * argv[]) {
    
    const int middleElementsAmount = 3;
    int numberOfRows, numberOfColumns;
    int **array;
    
    printf("Input the number of rows and columns for the new array:\n");
    numberOfRows = readElementFromKeyboard();
    numberOfColumns = readElementFromKeyboard();
    
    printf("Input an array:\n");
    array = dynamicArrayAlloc(numberOfRows, numberOfColumns);
    
    populateArray(array, numberOfRows, numberOfColumns);
    printf("\nYour array:\n");
    printArray(array, numberOfRows, numberOfColumns);
    
    sortArrayByMiddleElementsSum(array, numberOfRows, numberOfColumns, middleElementsAmount);
    printArray(array, numberOfRows, numberOfColumns);
    
    return 0;
}
