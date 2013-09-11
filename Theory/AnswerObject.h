//
//  AnswerObject.h
//  Theory
//
//  Created by Luda Fux on 7/9/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 answer:{
     answerID = NSString
     answerText = NSString
     isTrue = BOOL
 }
 */
@interface AnswerObject : NSObject{
    NSString* _answerID;
    NSString* _answerText;
    BOOL _isTrue;
    
}
@property (strong,nonatomic) NSString* answerID;
@property (strong,nonatomic) NSString* answerText;
@property (assign,nonatomic) BOOL isTrue;
@end
