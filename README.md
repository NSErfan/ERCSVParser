# ERCSVParser
A Simple yet reliable CSV Parser for iOS and OS X!


CSV: comma-separated values (CSV) file file stores tabular data (numbers and text) in plain text.

####HOW TO USE:
Add ERCSVParser.h and ERCSVParser.m in your project.

and import the ERCSVParser class header:
```
#import "ERCSVParser.h"
```

####Example:
        NSString *path = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"txt"];
        ERCSVParser *parser = [ERCSVParser new];
        NSArray *arrayOfArray = [parser parseIntoArraysOfArray:path];
        NSArray *arraysOfDictionary = [parser parseIntoArraysOfDictionary:path];



