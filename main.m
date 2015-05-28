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
        NSString *path = @""; //change it to the path of your file
        ERCSVParser *parser = [ERCSVParser new];
        NSArray *arrayOfArrays = [parser parseIntoArraysOfArrays:path];
        NSArray *arraysOfDictionaries = [parser parseIntoArraysOfDictionaries:path];
        
        for (NSDictionary *record in arraysOfDictionaries)
        {
            NSLog(@"%@", record);
        }
    }
    return 0;
}
