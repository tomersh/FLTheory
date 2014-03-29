//
//  StatisticManager.h
//  Theory
//
//  Created by Luda Fux on 3/29/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Shared.h"

@interface StatisticManager : NSObject

+ (StatisticManager*)sharedManager;


#pragma mark exersize

- (void)addExersizeStatistics:(Thoery_Category)categoryID
                  questionID:(int)questionID
                   isCorrect:(BOOL)isCorrect;

- (int)correctOutOfAllForCategory:(Thoery_Category)categoryID;

- (int)incorrectOutOfAllForCategory:(Thoery_Category)categoryID;

- (int)getNumOfNewQuestions:(Thoery_Category)categoryID;

- (int)getNumOfQuestions:(Thoery_Category)categoryID
               isCorrect:(BOOL)isCorrect;
#pragma mark simulation

-(void)addSimulationStistics:(int)simulationID
                  categoryID:(Thoery_Category)categoryID
     precentOfCorrectAnswers:(CGFloat)precentOfCorrectAnswers;


@end
