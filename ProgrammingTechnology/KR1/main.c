//
//  main.c
//  Sort
//
//  Created by Vlados iOS on 2/2/19.
//  Copyright © 2019 Vladislav Shilov. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

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
    } while(element <= 0);
    return element;
}

/// Fills input array with random numbers
/// Params: array - array which we send via refernce on memory
///         numberOfElements - number of elements on array

void populateArray(int *array, int numberOfElements) {
    for (int i = 0; i < numberOfElements; i++) {
        array[i] = rand() % 100 + 1;
    }
}

/// Prints array on console in a convenient format
/// Params: array - array which we send via refernce on memory
///         numberOfElements - number of elements on array

void printArray(int *array, int numberOfElements) {
    for (int i = 0; i < numberOfElements; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
}

/// Sort array via Shell's method
/// Params: array - array which we send via refernce on memory
///         numberOfElements - number of elements on array

void shellSort(int *array, int numberOfElements) {
    unsigned i, j, step;
    int temp;
    for(step = numberOfElements / 2; step > 0; step /= 2)
        for(i = step; i < numberOfElements; i++) {
            temp = array[i];
            for(j = i; j >= step; j -= step) {
                if(temp < array[j - step])
                    array[j] = array[j - step];
                else
                    break;
            }
            array[j] = temp;
        }
}

/// Find needed element in array via linear search
/// Params: element - element to find
///         array - array which we send via refernce on memory
///         numberOfElements - number of elements on array
/// Returns: index of found element or -1 if this element was not found

int linearSearch(int element, int *array, int arrayCount) {
    for (int i = 0; i < arrayCount; i++) {
        if (element == array[i]) {
            return i;
        }
    }
    return -1;
}

/// Prints to the screen result of linear search
/// Params: Result of liners search

void processSearchResult(int searchResult) {
    if (searchResult == -1) {
        printf("There is no this element in array\n");
    }
    else {
        printf("Finded element index: %d\n", searchResult);
    }
}

int main(int argc, const char * argv[]) {
    
    int numberOfElements;
    int elementToFind;
    
    printf("Input number of elements \n");
    numberOfElements = readElementFromKeyboard();
    
    int array[numberOfElements];
    populateArray(array, numberOfElements);
    
    printf("Generated array: \n");
    printArray(array, numberOfElements);
    
    // Shell's sort
    shellSort(array, numberOfElements);
    
    printf("Sorted array: \n");
    printArray(array, numberOfElements);
    
    printf("Input element to find:\n");
    elementToFind = readElementFromKeyboard();
    
    // Linear search
    int foundElementIndex = linearSearch(elementToFind, array, numberOfElements);
    processSearchResult(foundElementIndex);
    
    return 0;
}
