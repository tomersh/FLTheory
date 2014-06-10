//
//  ExamManager.m
//  Theory
//
//  Created by Luda Fux on 8/23/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "ExamManager.h"
#import "DatabaseManager.h"
@implementation ExamManager
@synthesize exam = _exam;
#define EXAM_KEY @"ExamKey"

+ (ExamManager*)sharedManager{
    static ExamManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
         self.exam = [self loadExamFromUserDefaults];
        if (!self.exam) {
            self.exam = [[DatabaseManager shared]getExamOfCategory:RODE_RULS_CATEGORY];
        }
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

- (void)saveExamToUserDefaults{
    NSData *myEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:self.exam];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:myEncodedObject forKey:EXAM_KEY];
    [defaults synchronize];
    
}

- (ExamObject *)loadExamFromUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *myEncodedObject = [defaults objectForKey:EXAM_KEY];
    ExamObject *examUD = (ExamObject *)[NSKeyedUnarchiver unarchiveObjectWithData: myEncodedObject];
    return examUD;
}

-(ExamObject*)reloadExamWithNewCategory:(Thoery_Category)category{
    self.exam = [[DatabaseManager shared]getExamOfCategory:category];
    return self.exam;
}
@end
