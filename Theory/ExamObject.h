//
//  ExamObject.h
//  Theory
//
//  Created by Luda Fux on 7/9/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryObject.h"
#import "Shared.h"
/*
 
 exam:{
    questions:[
         question:{
             questionID: string
             questionTest: string
             categoryID: string
             correctAnswerID: string
             chosenAnswerID: string
             answers:[
                 answer:{
                     answerID = string
                     answerText = string
                     isTrue = bool
                 }
                 answer:{}
             ]
         }
         question:{}
    ]
    categoryID: string
    userLocationPlaceInQuestionsArray: int
    numOfWrongAswers: int
    examType: enum
 }
 
 */

@interface ExamObject : NSObject{
    NSArray *_questions;
    Thoery_Category _category;
    int _userLocationPlaceInQuestionsArray;
    int _numOfWrongAswers;
    BOOL _isFinished;
}

-(id)initWithCategory:(Thoery_Category)category;
@property (strong,nonatomic) NSArray *questions;
@property (assign,nonatomic) Thoery_Category category;
@property (assign,nonatomic) int userLocationPlaceInQuestionsArray;
@property (assign,nonatomic) int numOfWrongAswers;
@property (assign,nonatomic) BOOL isFinished;
@end
