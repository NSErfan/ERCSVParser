//
//  main.m
//  ERCSVParser
//
//  Created by Erfan Seyyedi on 27/5/15.
//  Copyright (c) 2015 Erfan Seyyedi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ERCSVParser.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool
    {
        NSString *path = @"/Users/Erfan/Desktop/us-500.csv";
        ERCSVParser *parser = [ERCSVParser new];
        NSArray *arrayOfArray = [parser parseIntoArraysOfArray:path];
        NSArray *arraysOfDictionary = [parser parseIntoArraysOfDictionary:path];
    }
    return 0;
}
