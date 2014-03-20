//
//  AnswerTableViewCell.m
//  Theory
//
//  Created by Luda Fux on 3/20/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "AnswerTableViewCell.h"

@implementation AnswerTableViewCell


- (id)init
{
    self = [super init];
    if (self) {
    
//        self.frame = CGRectMake(0, 0, 280, 77);
    
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.answerLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, self.frame.size.width-20, self.frame.size.height)];
        self.answerLabel.numberOfLines = 20;
        self.answerLabel.textColor = [UIColor whiteColor];
        self.answerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        self.answerLabel.textAlignment = NSTextAlignmentRight;
        self.answerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.answerToggle = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-50, 23, 30, 30)];
        
        self.backgroundImage = [[UIImageView alloc]init];
        self.backgroundImage.frame = self.bounds;
        
        [self addSubview:self.answerLabel];
        [self addSubview:self.answerToggle];
        [self addSubview:self.backgroundImage];
    }
    return self;
}


-(void)setupAnswerTableViewCell:(QuestionObject*)question
                         answer:(AnswerObject*)answer
                            row:(NSInteger)row{
    self.question = question;
    self.answer = answer;
    self.row = row;
    
    CGSize labelSize = [answer.answerText sizeWithFont:self.answerLabel.font constrainedToSize:CGSizeMake(self.answerLabel.frame.size.width, 100000) lineBreakMode:self.answerLabel.lineBreakMode];
    
//    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, labelSize.height + 20);
    
    self.answerLabel.frame = CGRectMake(self.answerLabel.frame.origin.x, self.answerLabel.frame.origin.y, self.answerLabel.frame.size.width, labelSize.height);
    
    self.answerLabel.text = answer.answerText;
    
    [self.answerToggle addTarget:self
                          action:@selector(flip:)
                forControlEvents:UIControlEventTouchDown];
    
    
    self.answerToggle.tag = [answer.answerID intValue];
    
    if (self.row == 0) {
        self.backgroundImage.image = [UIImage imageNamed:@"List_Top_Item_Not_Selected_612x113px.png"];
    }
    else if (self.row == ([self.question.answers count] - 1)){
        self.backgroundImage.image = [UIImage imageNamed:@"List_Bottom_Item_Not_Selected_612x113px.png"];
    }
    else{
        self.backgroundImage.image = [UIImage imageNamed:@"List_Item_Not_Selected_612x113px.png"];
    }

}

+(CGFloat)answerCellHeight:(AnswerObject*)answer{
    CGSize labelSize = [answer.answerText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16] constrainedToSize:CGSizeMake(280, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + 20;
}

- (IBAction)flip:(id)sender {
    //    int minIndex = [curentQuestion.correctAnswerID intValue];
    //    if (sender.tag > 0) {
    //        if ([ExamManager sharedManager].exam.examType == LEARNING_EXAM_TYPE) {
    //            //if the exam is in simalation stage, check if it correct
    //            if ([curentQuestion.correctAnswerID isEqualToString:[NSString stringWithFormat:@"%d",sender.tag]]) {
    //                //if answer is correct
    //                [sender setBackgroundImage:[UIImage imageNamed:@"Check_Green_V_46x46px.png"] forState:UIControlStateNormal];
    //
    //            }else{
    //                [sender setBackgroundImage:[UIImage imageNamed:@"Check_Red_X_46x46px.png"] forState:UIControlStateNormal];
    //            }
    //        }else{
    //            for (int i = minIndex; i <= minIndex+4; i++) {
    //                UIButton *oneOfTheAnswerButtons = (UIButton*)[self.view viewWithTag:i];
    //                //if so, check the state of the exam
    //                //check if the button tag that is being enumarated is equest to the sender tag
    //                if (oneOfTheAnswerButtons.tag == sender.tag) {
    //
    //                    //if it is a learning stage, check if the answer is correct and change the image accordingly
    //                    [sender setBackgroundImage:[UIImage imageNamed:@"Check_White_V_46x46px.png"] forState:UIControlStateNormal];
    //                    curentQuestion.chosenAnswerID = [NSString stringWithFormat:@"%d", sender.tag];
    //                }else{
    //                    //esle unseelct the answer
    //                    [oneOfTheAnswerButtons setBackgroundImage:[UIImage imageNamed:@"Check_Empty_46x46px.png"] forState:UIControlStateNormal];
    //                }
    //            }
    //        }
    //        //save the chosen answer
    //        curentQuestion.chosenAnswerID = [NSString stringWithFormat:@"%d", sender.tag];
    //    }
    
}

//-(void)changeSelectedToVanX{
//    for (QuestionObject* question in [ExamManager sharedManager].exam.questions) {
//        if(question.chosenAnswerID){
//            UIButton *chosenAnswerButton = (UIButton*)[self.view viewWithTag:[question.chosenAnswerID intValue]];
//            if (question.correctAnswerID == question.chosenAnswerID) {
//                [chosenAnswerButton setBackgroundImage:[UIImage imageNamed:@"Check_Green_V_46x46px.png"] forState:UIControlStateNormal];
//            }
//            else{
//                [chosenAnswerButton setBackgroundImage:[UIImage imageNamed:@"Check_Red_X_46x46px.png"] forState:UIControlStateNormal];
//            }
//        }
//    }
//}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
