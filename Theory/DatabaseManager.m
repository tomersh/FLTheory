//
//  DatabaseManager.m
//  Whopix
//
//  Created by blocky on 3/12/13.
//  Copyright (c) 2013 undecidedyet. All rights reserved.
//

#import "DatabaseManager.h"
#import "QuestionObject.h"
#import "AnswerObject.h"
@implementation DatabaseManager

@synthesize dbopen = _dbopen;

static DatabaseManager* shraedInstance;

NSString *const DATABASE_FILENAME = @"Theory.sqlite";
NSString *const TABLE_QUESTIONS = @"Theory_questions";
NSString *const TABLE_ANSWERS = @"Theory_answers";

+ (DatabaseManager*) shared {
    return shraedInstance;
}

+ (void) initialize {
    static BOOL init = NO;
    if (!init) {
        init = YES;
        shraedInstance = [[DatabaseManager alloc] init];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _dbopen = NO;
        [self openOrCreateDatabase];
    }
    return self;
}

- (void) openOrCreateDatabase {
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Theory"
                                                         ofType:@"sqlite"];
    const char *dbfullpath = [filePath UTF8String];
    int open = sqlite3_open_v2(dbfullpath, &db, SQLITE_OPEN_READWRITE, NULL);
    
    if (open == SQLITE_ERROR) {
        //the database doesn't exist.
        NSLog(@"Database open error");
    } else if (open == SQLITE_OK) {
        _dbopen = YES;
        //all ok
    }
    
}


- (NSString*) stringFromBytes:(const unsigned char*)bytes withLength:(int)length {
    return [[NSString alloc] initWithBytes:bytes length:length encoding:NSUTF8StringEncoding];
} /// function to read said bytes into a utf8 string



- (ExamObject*) getExamOfCategory:(Thoery_Category)categoryID
            withNumberOfQuestions:(int)numberOfQuestions{
    
    ExamObject *exam = [[ExamObject alloc] initWithCategory:categoryID];
    
    NSMutableArray *questionsArrey = [[NSMutableArray alloc]init];
    [exam setQuestions:questionsArrey];
    [exam setCategory:categoryID];
    
    NSString *selectQuestion = nil;
    if (categoryID == MIXED_CATEGORY) {
        selectQuestion = [NSString stringWithFormat:@"SELECT questionID, questionText, questionLink FROM %@ ORDER BY random() LIMIT %d",TABLE_QUESTIONS,numberOfQuestions];
    }else{
        selectQuestion = [NSString stringWithFormat:@"SELECT questionID, questionText, questionLink FROM %@ WHERE categoryID = %d ORDER BY random() LIMIT %d",TABLE_QUESTIONS, (int)categoryID,numberOfQuestions];
    }
    sqlite3_stmt *compiledstatmentQuestion;
    
    int resultQuestion = sqlite3_prepare_v2(db, [selectQuestion UTF8String], -1, &compiledstatmentQuestion, NULL);
    if (resultQuestion == SQLITE_OK) {
        resultQuestion = sqlite3_step(compiledstatmentQuestion);
    }
    
    while (resultQuestion == SQLITE_ROW) {
        
        QuestionObject *question = [[QuestionObject alloc]init];
        [questionsArrey addObject:question];
        int questionID = sqlite3_column_int(compiledstatmentQuestion, 0);
        const unsigned char* questionText = sqlite3_column_text(compiledstatmentQuestion, 1);
        int questionTextL = sqlite3_column_bytes(compiledstatmentQuestion, 1);
        const unsigned char* questionLink = sqlite3_column_text(compiledstatmentQuestion, 2);
        int questionLinkL = sqlite3_column_bytes(compiledstatmentQuestion, 2);
        NSMutableArray *answerArrey = [[NSMutableArray alloc]init];
        
        [question setQuestionID:[NSString stringWithFormat:@"%d",questionID]];
        [question setQuestionText:[self stringFromBytes:questionText withLength:questionTextL]];
        [question setQuestionCategory:categoryID];
        [question setQuestionLink:[self stringFromBytes:questionLink withLength:questionLinkL]];
        [question setAnswers:answerArrey];
                
        NSString *selectAnswer = [NSString stringWithFormat:@"SELECT answerID, answerText,isTrue FROM %@ WHERE questionID = %d ORDER BY random()",TABLE_ANSWERS,questionID];
        
        sqlite3_stmt *compiledstatmentAnswer;
        
        int resultAnswer = sqlite3_prepare_v2(db, [selectAnswer UTF8String], -1, &compiledstatmentAnswer, NULL);
        if (resultAnswer == SQLITE_OK) {
            resultAnswer = sqlite3_step(compiledstatmentAnswer);
        }
        
        while (resultAnswer == SQLITE_ROW) {
            
            AnswerObject* answer = [[AnswerObject alloc]init];
            
            int answerID = sqlite3_column_int(compiledstatmentAnswer, 0);
            const unsigned char* answerText = sqlite3_column_text(compiledstatmentAnswer, 1);
            int answerTextL = sqlite3_column_bytes(compiledstatmentAnswer, 1);
            int isTrue = sqlite3_column_int(compiledstatmentAnswer, 2);
            NSString *trimmedString = [[self stringFromBytes:answerText withLength:answerTextL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            [answer setAnswerID:[NSString stringWithFormat:@"%d",answerID]];
            [answer setAnswerText:trimmedString];
            [answer setIsTrue:isTrue];
            if (answer.isTrue) {
                [question setCorrectAnswerID:answer.answerID];
            }
            [answerArrey addObject:answer];

            resultAnswer = sqlite3_step(compiledstatmentAnswer);
        }

        sqlite3_reset(compiledstatmentAnswer);
        
        
        resultQuestion = sqlite3_step(compiledstatmentQuestion);
    }
    
    sqlite3_reset(compiledstatmentQuestion);
    return exam;
}



- (int) execRawStatment: (NSString*)statment {
    int result = SQLITE_NULL;
    
    sqlite3_stmt *compiledStatment;
    
    result = sqlite3_prepare_v2(db, [statment UTF8String], -1, &compiledStatment, NULL);
    
    if (result == SQLITE_OK) {
        result = sqlite3_step(compiledStatment);
    }
    
    if (result == SQLITE_DONE) {
        sqlite3_reset(compiledStatment);
    }
    
    return result;
}


- (NSString *)sqliteLocation
{
    
    NSString *dir = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    
    NSError *err;
    
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:dir] )
        [[NSFileManager defaultManager] createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&err];
    
    if (err) {
        NSLog(@"applicationSupprtDirectory err %@",[err description]);
    }
    
    //[[NSFileManager defaultManager] createDirectoryAtPath:dir attributes:nil];
    
    return dir;
}


@end
