//
//  CSVParser.m
//  TweetsAnalyzer
//
//  Created by Erfan Seyyedi on 13/5/15.
//  Copyright (c) 2015 Erfan Seyyedi. All rights reserved.
//

#import "ERCSVParser.h"
@interface ERCSVParser()

@property (nonatomic) NSString *csvContent;
@property (nonatomic) NSArray *attributeNames;
@property (nonatomic) NSMutableArray *records;
@property (nonatomic) BOOL parseToDictionary;
@property (nonatomic) NSString *path;
@property (nonatomic) NSInteger header;
@end

@implementation ERCSVParser

-(NSArray *)parseIntoArraysOfArrays:(NSString *)path
{
    self.path = path;
    self.parseToDictionary = NO;
    return [self parse];
}

-(NSArray *)parseIntoArraysOfDictionaries:(NSString *)path
{
    self.path = path;
    self.parseToDictionary = YES;
    return [self parse];
}

-(NSArray *) parse
{
    self.records = [NSMutableArray new];
    self.attributeNames = nil;
    self.header = -1;
    self.csvContent = [NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:nil];
    
    NSString *record;
    BOOL firstRow = YES;
    do {
        record = [self nextRecord];
        NSArray *recordsArray = [self valuesOfARecord:record];
        if (recordsArray)
        {
            if (firstRow && self.parseToDictionary)
            {
                self.attributeNames = recordsArray;
            }else if (self.parseToDictionary)
            {
                [self.records addObject: [NSDictionary dictionaryWithObjects:recordsArray forKeys:self.attributeNames]];
                
            }else
            {
                [self.records addObject: recordsArray];
            }
            firstRow = NO;
        }

    } while (record);
    return [self.records copy];
}

-(NSArray *) valuesOfARecord:(NSString *) record
{
    if (!record) {
        return nil;
    }
    NSMutableArray *values = [NSMutableArray new];
    
    NSInteger header = -1;
    while(YES)
    {
        NSInteger beginningIndex = header + 1;
        if (beginningIndex > record.length)
        {
            break;
        }
        
        BOOL isItQuoted = NO;
        do {
            header++;
            NSRange rangeOfFirstNewLine = [record rangeOfString:@","
                                                                 options:NSCaseInsensitiveSearch
                                                                   range:NSMakeRange(header, record.length- header)];
            if (rangeOfFirstNewLine.location == NSNotFound)
            {
                header = NSNotFound;
                break;
            }
            
            isItQuoted = [self isItQuoted:rangeOfFirstNewLine.location string:record];
            if (!isItQuoted)
            {
                header = rangeOfFirstNewLine.location;
            }
        } while (isItQuoted);
        
        NSString *value;
        if (header == NSNotFound)
        {
            value = [record substringWithRange:NSMakeRange(beginningIndex, record.length - beginningIndex)];
        }else
        {
            value = [record substringWithRange:NSMakeRange(beginningIndex, header - beginningIndex)];
        }
        
        [values addObject:[self removeSurroundingQuotationMarks:value]];
    }
    return [values copy];
}

-(NSString *) removeSurroundingQuotationMarks:(NSString *) str
{
    NSString *firstLetter = [str substringWithRange:NSMakeRange(0, 1)];
    NSString *lastLetter = [str substringWithRange:NSMakeRange(str.length-1, 1)];
    NSMutableString *mutStr = [NSMutableString stringWithString:str];
    [mutStr replaceOccurrencesOfString:@"\"\"" withString:@"\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];

    if ([firstLetter isEqualToString:@"\""] && [lastLetter isEqualToString:@"\""])
    {
        return [[mutStr substringWithRange:NSMakeRange(1, mutStr.length - 2)] copy];
    }
    return mutStr;
}

-(BOOL) isItQuoted:(NSInteger) index string:(NSString *) record
{
    //backward
    NSString *backQuote = @",\"";
    NSInteger endOfSearchScope = index;
    NSInteger beginning = 0;
    BOOL foundBackQuote;
    do
    {
        NSRange rangeOfBackQuote = [record rangeOfString:backQuote
                                                    options:NSBackwardsSearch
                                                      range:NSMakeRange(0, endOfSearchScope)];
        if (rangeOfBackQuote.location == NSNotFound)
        {
            return NO;
        }
        if ([[self.csvContent substringWithRange:NSMakeRange(rangeOfBackQuote.location, 3)] isEqualToString:@",\"\""])
        {
            foundBackQuote = NO;
            endOfSearchScope = rangeOfBackQuote.location;
        }else
        {
            foundBackQuote = YES;
            beginning = rangeOfBackQuote.location + 2;
        }
    } while (!foundBackQuote);
    
    //forward
    NSString *frontQuote = @"\",";
    NSInteger startOfSearchScope = index + 1;
    NSInteger end = record.length;
    BOOL foundFrontQuote;
    do
    {
        NSRange rangeOfFrontQuote = [record rangeOfString:frontQuote
                                                          options:NSCaseInsensitiveSearch
                                                            range:NSMakeRange(startOfSearchScope, record.length - startOfSearchScope)];
        if (rangeOfFrontQuote.location == NSNotFound)
        {
            return NO;
        }
        if ([[self.csvContent substringWithRange:NSMakeRange(rangeOfFrontQuote.location, 3)] isEqualToString:@"\"\","])
        {
            foundFrontQuote = NO;
            startOfSearchScope = rangeOfFrontQuote.location + 2;
        }else
        {
            foundBackQuote = YES;
            end = rangeOfFrontQuote.location -1;
        }
    } while (!foundBackQuote);
    
    NSString *inQuotationStr = [record substringWithRange:NSMakeRange(beginning, end - beginning)];
    BOOL theresQuotationInsideTheStr = NO;
    for (int i = 0; i < inQuotationStr.length; i++)
    {
        if ([[inQuotationStr substringWithRange:NSMakeRange(i, 1)] isEqualToString:@"\""])
        {
            if(![[inQuotationStr substringWithRange:NSMakeRange(i, 2)] isEqualToString:@"\"\""])
            {
                theresQuotationInsideTheStr = YES;
                break;
            }else
            {
                i++;
            }
        }
    }
    return !theresQuotationInsideTheStr;
}

-(NSString *) nextRecord
{
    NSInteger beginningIndex = self.header + 1;
    if (beginningIndex > self.csvContent.length)
    {
        return nil;
    }
    
    BOOL isItQuoted = NO;
    do {
        self.header++;
        NSRange rangeOfFirstNewLine = [self.csvContent rangeOfCharacterFromSet:
                                       [NSCharacterSet characterSetWithCharactersInString:@"\n\r"]
                                                                       options:NSCaseInsensitiveSearch
                                                                         range:
                                       NSMakeRange(self.header, self.csvContent.length- self.header)];
        if (rangeOfFirstNewLine.location == NSNotFound)
        {
            return nil;
        }
        isItQuoted = [self isItQuoted:rangeOfFirstNewLine.location string:self.csvContent];
        if (!isItQuoted)
        {
            self.header = rangeOfFirstNewLine.location;
        }
        self.header = rangeOfFirstNewLine.location;
    }while (isItQuoted);
    
    NSString *recordStr = [self.csvContent substringWithRange:NSMakeRange(beginningIndex, self.header - beginningIndex)];
    return recordStr;
}

@end
