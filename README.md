# ERCSVParser
A Simple yet reliable CSV Parser for iOS and OS X!


A CSV is a comma separated values file, which allows data to be saved in a table structured format. CSVs look like a garden-variety spreadsheet but with a .csv extension (Traditionally they take the form of a text file containing information separated by commas, hence the name).

####HOW TO USE:
Add ```ERCSVParser.h``` and ```ERCSVParser.m``` to your project.

and import the ERCSVParser class header:
```
#import "ERCSVParser.h"
```

####Example:
        NSString *path = [[NSBundle mainBundle] pathForResource:@"file" ofType:@"csv"];
        ERCSVParser *parser = [ERCSVParser new];
        NSArray *arrayOfArrays = [parser parseIntoArraysOfArrays:path];
        NSArray *arraysOfDictionaries = [parser parseIntoArraysOfDictionaries:path];




