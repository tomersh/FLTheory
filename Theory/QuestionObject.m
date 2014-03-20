//
//  QuestionObject.m
//  Theory
//
//  Created by Luda Fux on 7/9/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "QuestionObject.h"

@implementation QuestionObject
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.questionID forKey:@"questionID"];
    [encoder encodeObject:self.questionText forKey:@"questionTest"];
    [encoder encodeObject:[NSNumber numberWithInt: (int)self.questionCategory] forKey:@"category"];
    [encoder encodeObject:self.answers forKey:@"answers"];
    [encoder encodeObject:self.correctAnswerID forKey:@"correctAnswerID"];
    [encoder encodeObject:self.chosenAnswerID forKey:@"chosenAnswerID"];
    [encoder encodeObject:self.questionLink forKey:@"questionLink"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.questionID = [decoder decodeObjectForKey:@"questionID"];
        self.questionText = [decoder decodeObjectForKey:@"questionTest"];
        self.questionCategory = (Thoery_Category)[[decoder decodeObjectForKey:@"category"]intValue];
        self.answers = [decoder decodeObjectForKey:@"answers"];
        self.correctAnswerID = [decoder decodeObjectForKey:@"correctAnswerID"];
        self.chosenAnswerID = [decoder decodeObjectForKey:@"chosenAnswerID"];
        self.questionLink = [decoder decodeObjectForKey:@"questionLink"];
    }
    return self;
}

-(NSString *)description{
    return [NSString stringWithFormat:@"question: questionID - %@, correctanswer - %@, link - %@", self.questionID, self.correctAnswerID,self.questionLink];
    //    return [NSString stringWithFormat:@"question: questionID - %@, questionText - %@, questionCategory - %u, questionLink - %@ , correctAnswerID - %@ , chosenAnswerID - %@, answers - %@",self.questionID, self.questionText, self.questionCategory,self.questionLink,self.correctAnswerID,self.chosenAnswerID, self.answers];
}
@end
