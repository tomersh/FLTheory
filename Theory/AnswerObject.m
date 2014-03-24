//
//  AnswerObject.m
//  Theory
//
//  Created by Luda Fux on 7/9/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "AnswerObject.h"

@implementation AnswerObject

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.answerID forKey:@"answerID"];
    [encoder encodeObject:self.answerText forKey:@"answerText"];
    [encoder encodeObject:[NSNumber numberWithBool:self.isTrue] forKey:@"isTrue"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.cellHeight] forKey:@"cellHeight"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.answerID = [decoder decodeObjectForKey:@"answerID"];
        self.answerText = [decoder decodeObjectForKey:@"answerText"];
        self.isTrue = [[decoder decodeObjectForKey:@"isTrue"]boolValue];
        self.cellHeight = [[decoder decodeObjectForKey:@"cellHeight"]floatValue];
    }
    return self;
}

-(NSString *)description{
//    return [NSString stringWithFormat:@"answer: answerID - %@, answerText - %@, isTrue - %@",self.answerID, self.answerText,self.isTrue? @"Yes" : @"No"];
    return [NSString stringWithFormat:@"answer: answerID - %@",self.answerID];
}
@end
