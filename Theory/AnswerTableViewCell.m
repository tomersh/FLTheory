//
//  AnswerTableViewCell.m
//  Theory
//
//  Created by Luda Fux on 3/20/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import "ExamManager.h"

@implementation AnswerTableViewCell

static CGFloat togleEdgeSize = 25;
static CGFloat bufferBetweenViews = 10;
static CGFloat answerLabelWidth = 225;


+(CGFloat)answerCellHeight:(AnswerObject*)answer{
    CGSize labelSize = [answer.answerText sizeWithFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16] constrainedToSize:CGSizeMake(answerLabelWidth, 100000) lineBreakMode:NSLineBreakByWordWrapping];
    
    return labelSize.height + bufferBetweenViews*2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.answerLabel = [[UILabel alloc]init];
        self.answerLabel.numberOfLines = 20;
        self.answerLabel.textColor = [UIColor whiteColor];
        self.answerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        self.answerLabel.textAlignment = NSTextAlignmentRight;
        self.answerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.answerToggle = [[UIImageView alloc]init];
        self.answerToggle.image = [UIImage imageNamed:@"Check_Empty_46x46px.png"];
        
        self.backgroundImage = [[UIImageView alloc]init];
        
        [self addSubview:self.backgroundImage];
        [self addSubview:self.answerLabel];
        [self addSubview:self.answerToggle];
    }
    return self;
}

-(void)setupAnswerTableViewCell:(QuestionObject*)question
                         answer:(AnswerObject*)answer
                            row:(NSInteger)row
                         height:(CGFloat)height{
    self.question = question;
    self.answer = answer;
    self.row = row;
    
    self.answerLabel.text = answer.answerText;
    
    self.tag = [answer.answerID intValue];
    
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

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGSize labelSize = [self.answer.answerText sizeWithFont:self.answerLabel.font constrainedToSize:CGSizeMake(answerLabelWidth, 100000) lineBreakMode:NSLineBreakByWordWrapping];

    
    self.answerLabel.frame = CGRectMake(bufferBetweenViews, self.bounds.size.height/2 - labelSize.height/2 - 2, answerLabelWidth,labelSize.height);
    
    self.backgroundImage.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-1);

    self.answerToggle.frame = CGRectMake(self.frame.size.width - togleEdgeSize - bufferBetweenViews, self.bounds.size.height/2 - togleEdgeSize/2, togleEdgeSize, togleEdgeSize);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    NSLog(@"[ExamManager sharedManager].exam.category - %u",[ExamManager sharedManager].exam.category);

    if(selected){
        //toggle
        if (([ExamManager sharedManager].exam.category == MIXED_CATEGORY)) {
            self.answerToggle.image = [UIImage imageNamed:@"Check_White_V_46x46px.png"];
        }else{
            if ([self.question.correctAnswerID isEqualToString:self.question.chosenAnswerID]) {
                self.answerToggle.image = [UIImage imageNamed:@"Check_Green_V_46x46px.png"];
            }else{
                self.answerToggle.image = [UIImage imageNamed:@"Check_Red_X_46x46px.png"];
            }
            
            
            //background
            if (self.row == 0) {
                self.backgroundImage.image = [UIImage imageNamed:@"List_Top_Item_Selected_612x113px.png"];
            }
            else if (self.row == ([self.question.answers count] - 1)){
                self.backgroundImage.image = [UIImage imageNamed:@"List_Bottom_Item_Selected_612x113px.png"];
            }
            else{
                self.backgroundImage.image = [UIImage imageNamed:@"List_Item_Selected_612x113px.png"];
            }
            
            //text
            self.answerLabel.textColor = [UIColor blackColor];
        }
        
        
    }else{
        
        //toggle
        self.answerToggle.image = [UIImage imageNamed:@"Check_Empty_46x46px.png"];
        
        //background
        if (self.row == 0) {
            self.backgroundImage.image = [UIImage imageNamed:@"List_Top_Item_Not_Selected_612x113px.png"];
        }
        else if (self.row == ([self.question.answers count] - 1)){
            self.backgroundImage.image = [UIImage imageNamed:@"List_Bottom_Item_Not_Selected_612x113px.png"];
        }
        else{
            self.backgroundImage.image = [UIImage imageNamed:@"List_Item_Not_Selected_612x113px.png"];
        }
        
        //text
        self.answerLabel.textColor = [UIColor whiteColor];
    }
    
    [super setSelected:selected animated:animated];
}



@end
