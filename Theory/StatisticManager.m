//
//  StatisticManager.m
//  Theory
//
//  Created by Luda Fux on 3/29/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "StatisticManager.h"
#import "DatabaseManager.h"

@implementation StatisticManager

+ (StatisticManager*)sharedManager{
    static StatisticManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark exersize
-(void)addExersizeStatistics:(Thoery_Category)categoryID
                  questionID:(int)questionID
                   isCorrect:(int)isCorrect{
    [[DatabaseManager shared]addExersizeStatistics:categoryID questionID:questionID isCorrect:isCorrect];
}


#pragma mark simulation
-(void)addSimulationStistics:(int)simulationID
                  categoryID:(Thoery_Category)categoryID
     precentOfCorrectAnswers:(CGFloat)precentOfCorrectAnswers{
    [[DatabaseManager shared]addSimulationStistics:simulationID categoryID:categoryID precentOfCorrectAnswers:precentOfCorrectAnswers];
}

-(CGFloat)correctOutOfAllForCategory:(Thoery_Category)categoryID{
    CGFloat correctOutOfAllForCategory = [[DatabaseManager shared]getCorrectOutOfAllForCategory:categoryID];
    return correctOutOfAllForCategory;
}

@end
