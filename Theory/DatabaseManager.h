//
//  DatabaseManager.h
//  Whopix
//
//  Created by blocky on 3/12/13.
//  Copyright (c) 2013 undecidedyet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ExamObject.h"

@interface DatabaseManager : NSObject {
    sqlite3 *db;
    BOOL dbopen;
}
@property (nonatomic) BOOL dbopen;


FOUNDATION_EXPORT NSString *const DATABASE_FILENAME;
FOUNDATION_EXPORT NSString *const TABLE_FRIENDS;
FOUNDATION_EXPORT NSString *const TABLE_FRIENDS_SCORES;
FOUNDATION_EXPORT NSString *const TABLE_FRIENDS_INVITEDSTATE;

+ (DatabaseManager*) shared;

- (ExamObject*) getExamOfCategory:(Thoery_Category)categoryID;

- (void)addExersizeStatistics:(Thoery_Category)categoryID
                  questionID:(int)questionID
                   isCorrect:(BOOL)isCorrect;

- (void)addSimulationStistics:(int)simulationID
                  categoryID:(Thoery_Category)categoryID
     precentOfCorrectAnswers:(CGFloat)precentOfCorrectAnswers;

- (int)getNumOfQuestions:(Thoery_Category)categoryID
               isCorrect:(BOOL)isCorrect;

- (int)getNumOfNewQuestions:(Thoery_Category)categoryID;

- (void)saveSimulationData:(NSMutableDictionary*)simulationData;

-(NSMutableDictionary*)simulationsDataForCategory:(Thoery_Category)category;
@end