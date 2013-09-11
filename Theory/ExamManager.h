//
//  ExamManager.h
//  Theory
//
//  Created by Luda Fux on 8/23/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExamObject.h"
@interface ExamManager : NSObject{
        ExamObject * _exam;
}
@property (nonatomic, retain) ExamObject *exam;
+ (ExamManager*)sharedManager;
- (void)saveExamToUserDefaults;
-(ExamObject*)reloadExamWithNewCategory:(Thoery_Category)category
                   andNumberOfQuestions:(int)numberOfQuestions;
@end
