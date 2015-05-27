//  Created by Erfan Seyyedi on 13/5/15.
//  Copyright (c) 2015 Erfan Seyyedi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ERCSVParser : NSObject

-(NSArray *) parseIntoArraysOfArrays:(NSString *) path;
-(NSArray *) parseIntoArraysOfDictionaries:(NSString *) path;
@end
