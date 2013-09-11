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
    [encoder encodeObject:[NSNumber numberWithInt: (int)self.examType] forKey:@"examType"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.questions = [decoder decodeObjectForKey:@"questions"];
        self.category = (Thoery_Category)[[decoder decodeObjectForKey:@"category"]intValue];
        self.examType = (EXAM_TYPE)[[decoder decodeObjectForKey:@"examType"]intValue];
        self.userLocationPlaceInQuestionsArray = [[decoder decodeObjectForKey:@"userLocationPlaceInQuestionsArray"]intValue];
        self.numOfWrongAswers = [[decoder decodeObjectForKey:@"numOfWrongAswers"]intValue];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"Exam: category - %u, examType - %u, questions - %@, userLocationPlaceInQuestionsArray - %d, numOfWrongAswers - %d",self.category, self.examType, self.questions, self.userLocationPlaceInQuestionsArray, self.numOfWrongAswers];
}

-(id)init{
    if ((self = [super init]))
    {
        self.examType = LEARNING_EXAM_TYPE;
        self.userLocationPlaceInQuestionsArray = 0;
        self.numOfWrongAswers = 0;
        self.questions = [[NSMutableArray alloc]init];
        self.category = RODE_RULS_CATEGORY;
    }
    return self;
}

-(id)initWithCategory:(Thoery_Category)category{
    if ((self = [super init]))
    {
        EXAM_TYPE examType = LEARNING_EXAM_TYPE;
        if (category == MIXED_CATEGORY) {
            examType = SIMULATION_EXAM_TYPE;
        }
        self.examType = examType;
        self.userLocationPlaceInQuestionsArray = 0;
        self.numOfWrongAswers = 0;
        self.questions = [[NSMutableArray alloc]init];
        self.category = category;
    }
    return self;
}




@end
