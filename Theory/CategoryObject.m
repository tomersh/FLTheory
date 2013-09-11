//
//  CategoryObject.m
//  Theory
//
//  Created by Luda Fux on 7/10/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "CategoryObject.h"

@implementation CategoryObject
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:[NSNumber numberWithInt:self.categoryID] forKey:@"categoryID"];
    [encoder encodeObject:self.categoryName forKey:@"categoryName"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.categoryID = [[decoder decodeObjectForKey:@"categoryID"]intValue];
        self.categoryName = [decoder decodeObjectForKey:@"categoryName"];
    }
    return self;
}


@end
