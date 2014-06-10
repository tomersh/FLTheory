//
//  CategorySimulation.m
//  Theory
//
//  Created by Luda Fux on 4/11/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "CategorySimulation.h"

@implementation CategorySimulation

- (id)init{
    if((self = [super init])) {
        //decode properties, other class vars
        self.category = UNKNOWEN_CATEGORY;
        self.totalNumQuestions = 0;
        self.correctNumQuestions = 0;
        self.correctPercent = 0.0;
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"category - %u, totalNumQuestions - %d, correctNumQuestions - %d , correctPercent - %d", self.category , self.totalNumQuestions , self.correctNumQuestions, self.correctPercent];
}
@end

