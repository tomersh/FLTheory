//
//  QuestionObject.h
//  Theory
//
//  Created by Luda Fux on 7/9/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CategoryObject.h"
#import "ExamObject.h"
/*
 question:{
     questionID: NSString
     questionTest: NSString
     category:{
         categoryID = NSString
         categoryName = NSString
     }
     correctAnswerID: NSString
     chosenAnswerID: NSString
     answers:[
         answer:{
             answerID = NSString
             answerText = NSString
             isTrue = BOOL
         }
         answer:{}
     ]
 }
 */
@interface QuestionObject : NSObject{
    NSString* _questionID;
    NSString* _questionText;
    Thoery_Category _questionCategory;
    NSArray* _answers;
    NSString* _correctAnswerID;
    NSString* _chosenAnswerID;
    NSString* _questionLink;
}

@property (strong,nonatomic) NSString* questionID;
@property (strong,nonatomic) NSString* questionText;
@property (strong,nonatomic) NSString* questionLink;
@property (assign,nonatomic) Thoery_Category questionCategory;
@property (strong,nonatomic) NSArray* answers;
@property (strong,nonatomic) NSString* correctAnswerID;
@property (strong,nonatomic) NSString* chosenAnswerID;


@end
