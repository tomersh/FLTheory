//
//  ExamObject.m
//  Theory
//
//  Created by Luda Fux on 7/9/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "ExamObject.h"

@implementation ExamObject
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.questions forKey:@"questions"];
    [encoder encodeObject:[NSNumber numberWithInt: (int)self.category] forKey:@"category"];
    [encoder encodeObject:[NSNumber numberWithInt: self.userLocationPlaceInQuestionsArray] forKey:@"userLocationPlaceInQuestionsArray"];
    [encoder encodeObject:[NSNumber numberWithInt: self.numOfWrongAswers] forKey:@"numOfWrongAswers"];
    [encoder encodeObject:[NSNumber numberWithInt: self.isFinished] forKey:@"isFinished"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.questions = [decoder decodeObjectForKey:@"questions"];
        self.category = (Thoery_Category)[[decoder decodeObjectForKey:@"category"]intValue];
        self.userLocationPlaceInQuestionsArray = [[decoder decodeObjectForKey:@"userLocationPlaceInQuestionsArray"]intValue];
        self.numOfWrongAswers = [[decoder decodeObjectForKey:@"numOfWrongAswers"]intValue];
        self.isFinished = [[decoder decodeObjectForKey:@"isFinished"]intValue];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"Exam: category - %u, questions - %@, userLocationPlaceInQuestionsArray - %d, numOfWrongAswers - %d",self.category, self.questions, self.userLocationPlaceInQuestionsArray, self.numOfWrongAswers];
}

-(id)init{
    if ((self = [super init]))
    {
        [self initializationFunction:RODE_RULS_CATEGORY];
    }
    return self;
}

-(id)initWithCategory:(Thoery_Category)category{
    if ((self = [super init]))
    {
        [self initializationFunction:category];
    }
    return self;
}

-(void)initializationFunction:(Thoery_Category)category{
    self.userLocationPlaceInQuestionsArray = 0;
    self.numOfWrongAswers = 0;
    self.questions = [[NSMutableArray alloc]init];
    self.category = category;
    self.isFinished = NO;
}


@end
