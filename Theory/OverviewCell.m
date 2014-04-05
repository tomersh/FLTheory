//
//  OverviewCell.m
//  Theory
//
//  Created by Luda Fux on 3/22/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "OverviewCell.h"
#import "ExamManager.h"

@implementation OverviewCell

static CGFloat togleEdgeSize = 35;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 15)];
        self.questionLabel.textColor = [UIColor whiteColor];
        self.questionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        self.questionLabel.textAlignment = NSTextAlignmentCenter;
        
        self.answerToggle = [[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - togleEdgeSize)/2, 18, togleEdgeSize, togleEdgeSize)];
        
        [self.contentView addSubview:self.questionLabel];
        [self.contentView addSubview:self.answerToggle];
    }
    return self;
}

-(void)setupCell:(QuestionObject*)question
             row:(NSInteger)row{

    self.question = question;
    
    self.questionLabel.text = [NSString stringWithFormat:@"%ld",(long)row + 1];
    
    self.answerToggle.image = [self toggleImageForQuestion];
    
}


-(UIImage*)toggleImageForQuestion{
    UIImage* imageToReturn = nil;
    
    if (![ExamManager sharedManager].exam.isFinished) {
    
        if (self.question.chosenAnswerID) {
            
            //if any answer was chosen, look what sign there should be presented
            if ([ExamManager sharedManager].exam.category == MIXED_CATEGORY) {
                
                //if the exam is in simulation state then only select it
                imageToReturn = [UIImage imageNamed:@"Check_White_V_46x46px.png"];
                
            }else{
                
                //if the exam is in simalation stage, check if it correct
                if ([self.question.correctAnswerID isEqualToString:self.question.chosenAnswerID]) {
                    
                    //if answer is correct
                    imageToReturn = [UIImage imageNamed:@"Check_Green_V_46x46px.png"];
                    
                }else{
                    
                    //if the answer is wrong
                    imageToReturn = [UIImage imageNamed:@"Check_Red_X_46x46px.png"];
                }
                
                
            }
        }else{
            
            //if the answer is not chosen, use unselected icon
            imageToReturn = [UIImage imageNamed:@"Check_Empty_46x46px.png"];
            
        }
    }else{
        imageToReturn = [self correctOrNot];
    }
    return imageToReturn;
}

-(void)finishExam{
    self.answerToggle.image = [self correctOrNot];
    [self culcWrongAnswers];
}


-(void)culcWrongAnswers{
    if (![self.question.correctAnswerID isEqualToString:self.question.chosenAnswerID]) {
        [ExamManager sharedManager].exam.numOfWrongAswers ++;
    }

}

-(UIImage*)correctOrNot{
    UIImage* imageToReturn = nil;
    
    if ([self.question.correctAnswerID isEqualToString:self.question.chosenAnswerID]) {
        
        //if answer is correct
        imageToReturn = [UIImage imageNamed:@"Check_Green_V_46x46px.png"];
        
    }else{
        
        //if the answer is wrong
        imageToReturn = [UIImage imageNamed:@"Check_Red_X_46x46px.png"];

    }
    return imageToReturn;
}
@end
