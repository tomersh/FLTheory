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
NSString *const TABLE_STATISTICS_Exersize = @"TABLE_STATISTICS_Exersize";
NSString *const TABLE_STATISTICS_Simulation = @"TABLE_STATISTICS_Simulation";

#pragma mark init
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
//        [self createTablesIfNeeded];
    }
    return self;
}


#pragma mark extract functions

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
        selectQuestion = [NSString stringWithFormat:@"SELECT questionID, questionText, questionLink FROM %@ WHERE categoryID = %d ORDER BY random()",TABLE_QUESTIONS, (int)categoryID];//[NSString stringWithFormat:@"SELECT questionID, questionText, questionLink FROM %@ WHERE categoryID = %d ORDER BY random() LIMIT %d",TABLE_QUESTIONS, (int)categoryID,numberOfQuestions];
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

- (int)getNumOfNewQuestions:(Thoery_Category)categoryID{
    
    NSString *selectNumOfOldByCategory = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE categoryID = %d",TABLE_STATISTICS_Exersize,categoryID];
    
    sqlite3_stmt *compiledstatment;
    
    int result = sqlite3_prepare_v2(db, [selectNumOfOldByCategory UTF8String], -1, &compiledstatment, NULL);
    if (result == SQLITE_OK) {
        result = sqlite3_step(compiledstatment);
    }
    
    int oldQuestions = 0;
    
    if(result == SQLITE_ROW) {
        oldQuestions = sqlite3_column_int(compiledstatment, 0);
    }
    
    sqlite3_reset(compiledstatment);
    
    NSString *selectNumOfAllByCategory = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE categoryID = %d",TABLE_QUESTIONS,categoryID];
    
    result = sqlite3_prepare_v2(db, [selectNumOfAllByCategory UTF8String], -1, &compiledstatment, NULL);
    
    if (result == SQLITE_OK) {
        result = sqlite3_step(compiledstatment);
    }
    
    int numOfAllByCategory = 1;
    if (result == SQLITE_ROW) {
        numOfAllByCategory = sqlite3_column_int(compiledstatment, 0);
        result = sqlite3_step(compiledstatment);
    }
    
    sqlite3_reset(compiledstatment);
    
    if (numOfAllByCategory == 0) {
        return -1;
    }
    
    return numOfAllByCategory - oldQuestions;
    
}


- (int)getNumOfQuestions:(Thoery_Category)categoryID
               isCorrect:(BOOL)isCorrect{
    
    NSString *selectNumOfTrueByCategory = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE categoryID = %d AND isCorrect = %d",TABLE_STATISTICS_Exersize,categoryID,isCorrect];
    
    sqlite3_stmt *compiledstatment;
    
    int result = sqlite3_prepare_v2(db, [selectNumOfTrueByCategory UTF8String], -1, &compiledstatment, NULL);
    if (result == SQLITE_OK) {
        result = sqlite3_step(compiledstatment);
    }
    
    int numOfquestionsByCategory = 0;
    
    if(result == SQLITE_ROW) {
        numOfquestionsByCategory = sqlite3_column_int(compiledstatment, 0);
    }
    
    sqlite3_reset(compiledstatment);
    
    return numOfquestionsByCategory;

}
//
//- (NSDictionary*)getSimulationStatistics:(Thoery_Category)categoryID{
//    
//    ExamObject *exam = [[ExamObject alloc] initWithCategory:categoryID];
//    
//    NSMutableArray *questionsArrey = [[NSMutableArray alloc]init];
//    [exam setQuestions:questionsArrey];
//    [exam setCategory:categoryID];
//    
//    NSString *selectQuestion = nil;
//    if (categoryID == MIXED_CATEGORY) {
//        selectQuestion = [NSString stringWithFormat:@"SELECT questionID, questionText, questionLink FROM %@ ORDER BY random() LIMIT %d",TABLE_QUESTIONS,numberOfQuestions];
//    }else{
//        selectQuestion = [NSString stringWithFormat:@"SELECT questionID, questionText, questionLink FROM %@ WHERE categoryID = %d ORDER BY random()",TABLE_QUESTIONS, (int)categoryID];//[NSString stringWithFormat:@"SELECT questionID, questionText, questionLink FROM %@ WHERE categoryID = %d ORDER BY random() LIMIT %d",TABLE_QUESTIONS, (int)categoryID,numberOfQuestions];
//    }
//    sqlite3_stmt *compiledstatmentQuestion;
//    
//    int resultQuestion = sqlite3_prepare_v2(db, [selectQuestion UTF8String], -1, &compiledstatmentQuestion, NULL);
//    if (resultQuestion == SQLITE_OK) {
//        resultQuestion = sqlite3_step(compiledstatmentQuestion);
//    }
//    
//    while (resultQuestion == SQLITE_ROW) {
//        
//        QuestionObject *question = [[QuestionObject alloc]init];
//        [questionsArrey addObject:question];
//        int questionID = sqlite3_column_int(compiledstatmentQuestion, 0);
//        const unsigned char* questionText = sqlite3_column_text(compiledstatmentQuestion, 1);
//        int questionTextL = sqlite3_column_bytes(compiledstatmentQuestion, 1);
//        const unsigned char* questionLink = sqlite3_column_text(compiledstatmentQuestion, 2);
//        int questionLinkL = sqlite3_column_bytes(compiledstatmentQuestion, 2);
//        NSMutableArray *answerArrey = [[NSMutableArray alloc]init];
//        
//        [question setQuestionID:[NSString stringWithFormat:@"%d",questionID]];
//        [question setQuestionText:[self stringFromBytes:questionText withLength:questionTextL]];
//        [question setQuestionCategory:categoryID];
//        [question setQuestionLink:[self stringFromBytes:questionLink withLength:questionLinkL]];
//        [question setAnswers:answerArrey];
//        
//        NSString *selectAnswer = [NSString stringWithFormat:@"SELECT answerID, answerText,isTrue FROM %@ WHERE questionID = %d ORDER BY random()",TABLE_ANSWERS,questionID];
//        
//        sqlite3_stmt *compiledstatmentAnswer;
//        
//        int resultAnswer = sqlite3_prepare_v2(db, [selectAnswer UTF8String], -1, &compiledstatmentAnswer, NULL);
//        if (resultAnswer == SQLITE_OK) {
//            resultAnswer = sqlite3_step(compiledstatmentAnswer);
//        }
//        
//        while (resultAnswer == SQLITE_ROW) {
//            
//            AnswerObject* answer = [[AnswerObject alloc]init];
//            
//            int answerID = sqlite3_column_int(compiledstatmentAnswer, 0);
//            const unsigned char* answerText = sqlite3_column_text(compiledstatmentAnswer, 1);
//            int answerTextL = sqlite3_column_bytes(compiledstatmentAnswer, 1);
//            int isTrue = sqlite3_column_int(compiledstatmentAnswer, 2);
//            NSString *trimmedString = [[self stringFromBytes:answerText withLength:answerTextL] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//            
//            [answer setAnswerID:[NSString stringWithFormat:@"%d",answerID]];
//            [answer setAnswerText:trimmedString];
//            [answer setIsTrue:isTrue];
//            if (answer.isTrue) {
//                [question setCorrectAnswerID:answer.answerID];
//            }
//            [answerArrey addObject:answer];
//            
//            resultAnswer = sqlite3_step(compiledstatmentAnswer);
//        }
//        
//        sqlite3_reset(compiledstatmentAnswer);
//        
//        
//        resultQuestion = sqlite3_step(compiledstatmentQuestion);
//    }
//    
//    sqlite3_reset(compiledstatmentQuestion);
//    return exam;
//}





#pragma mark insert functions

//- (void) createTablesIfNeeded {
//    if (_dbopen) {
//        NSString *createTABLE_STATISTICS_Exersize = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (questionID INTEGER PRIMARY KEY, categoryID INTEGER, isCorrect INTEGER)", TABLE_STATISTICS_Exersize];
//        
//        NSString *createTABLE_STATISTICS_Simulation = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (simulationID INTEGER, categoryID INTEGER, percentOfCorrectAnswers FLOAT)",TABLE_STATISTICS_Simulation];
//        
//        [self execRawStatment:createTABLE_STATISTICS_Exersize];
//        [self execRawStatment:createTABLE_STATISTICS_Simulation];
//    }
//}
//

-(void)addExersizeStatistics:(Thoery_Category)categoryID
                    questionID:(int)questionID
                     isCorrect:(BOOL)isCorrect{
    if (_dbopen) {
        
        int cuId = [self doesQuestionExistInTABLE_STATISTICS_Exersize:questionID];
        
        NSString *rawStatment;
        if (cuId == -1) {
            rawStatment = [NSString stringWithFormat:@"INSERT INTO %@ (questionID, categoryID,isCorrect) VALUES (%d,%d,%d)",TABLE_STATISTICS_Exersize,questionID,categoryID,isCorrect];
        } else {
            rawStatment = [NSString stringWithFormat:@"UPDATE %@ SET isCorrect=%d WHERE questionID=%d",TABLE_STATISTICS_Exersize,isCorrect,questionID];
        }
        
        [self execRawStatment:rawStatment];
        
//        [self getCorrectOutOfAllForCategory:categoryID];
//        [self testContentTABLE_STATISTICS_Exersize];
    }
    
}


-(void)addSimulationStistics:(int)simulationID
                  categoryID:(Thoery_Category)categoryID
     precentOfCorrectAnswers:(CGFloat)precentOfCorrectAnswers{
    if (_dbopen) {
        
        NSString *rawStatment = [NSString stringWithFormat:@"INSERT INTO %@ (simulationID, categoryID,isCorrect) VALUES (\"%d\",\"%d\",\"%f\")",TABLE_STATISTICS_Simulation,simulationID,categoryID,precentOfCorrectAnswers];
        
        [self execRawStatment:rawStatment];
        
    }
    
}


#pragma mark help functions

- (int)testContentTABLE_STATISTICS_Exersize {
    int retVal = -1;
    
    NSString *select = [NSString stringWithFormat:@"SELECT questionID,isCorrect FROM %@ ",TABLE_STATISTICS_Exersize];

    
    sqlite3_stmt *compiledstatment;
    
    int result = sqlite3_prepare_v2(db, [select UTF8String], -1, &compiledstatment, NULL);
    if (result == SQLITE_OK) {
        result = sqlite3_step(compiledstatment);
    }
    
    while (result == SQLITE_ROW) {
        int isCorrect = sqlite3_column_int(compiledstatment, 1);
        int questionID = sqlite3_column_int(compiledstatment, 0);
        result = sqlite3_step(compiledstatment);
    }
    
    sqlite3_reset(compiledstatment);
    
    return retVal;
}

- (int) doesQuestionExistInTABLE_STATISTICS_Exersize:(int)questionID {
    int retVal = -1;
    
    NSString *select = [NSString stringWithFormat:@"SELECT questionID FROM %@ WHERE questionID = %d",TABLE_STATISTICS_Exersize,questionID];
    
    sqlite3_stmt *compiledstatment;
    
    int result = sqlite3_prepare_v2(db, [select UTF8String], -1, &compiledstatment, NULL);
    if (result == SQLITE_OK) {
        result = sqlite3_step(compiledstatment);
    }
    
    if (result == SQLITE_ROW) {
        retVal = sqlite3_column_int(compiledstatment, 0);
    }
    
    sqlite3_reset(compiledstatment);
    
    return retVal;
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

@end
