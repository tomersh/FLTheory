//
//  AnswerTableViewCell.m
//  Theory
//
//  Created by Luda Fux on 3/20/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "AnswerTableViewCell.h"


@implementation AnswerTableViewCell

static CGFloat togleEdgeSize = 25;
static CGFloat heightBufferBetweenViews = 10;
static CGFloat widthBufferBetweenViews = 10;
static CGFloat answerLabelWidth = 225;


+(CGFloat)answerCellHeight:(AnswerObject*)answer{
    CGRect labelSize = [answer.answerText boundingRectWithSize:CGSizeMake(answerLabelWidth, 100000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:answerLabelFont}
                                                        context:nil];
        
    CGFloat cellHeight = labelSize.size.height + heightBufferBetweenViews*2;
    
    answer.cellHeight = cellHeight;
    return cellHeight;
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
        self.answerLabel.font = answerLabelFont;
        self.answerLabel.textAlignment = NSTextAlignmentRight;
        self.answerLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        self.answerToggle = [[UIImageView alloc]init];
        self.answerToggle.image = [UIImage imageNamed:@"Check_Empty_46x46px.png"];
        
        self.backgroundImage = [[UIImageView alloc]init];
        
        heightBufferBetweenViews = [Shared is4inch]?10.0:5.0;
        
        [self addSubview:self.backgroundImage];
        [self addSubview:self.answerLabel];
        [self addSubview:self.answerToggle];
    }
    return self;
}

-(void)setupAnswerTableViewCell:(QuestionObject*)question
                         answer:(AnswerObject*)answer
                            row:(NSInteger)row
                         height:(CGFloat)height
                    setSelected:(BOOL)selected{
    
    self.question = question;
    self.answer = answer;
    self.row = row;

    self.answerLabel.text = answer.answerText;
    
    self.tag = [answer.answerID intValue];
    
    [self setSelected:selected animated:NO];

}

- (void) layoutSubviews
{
    [super layoutSubviews];
    
    CGRect labelSize = [self.answer.answerText boundingRectWithSize:CGSizeMake(answerLabelWidth, 100000)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:answerLabelFont}
                                                       context:nil];
    
    self.answerLabel.frame = CGRectMake(widthBufferBetweenViews, self.bounds.size.height/2 - labelSize.size.height/2 - 2, answerLabelWidth,labelSize.size.height);
    
    self.backgroundImage.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height-1);

    self.answerToggle.frame = CGRectMake(self.frame.size.width - togleEdgeSize - widthBufferBetweenViews, self.bounds.size.height/2 - togleEdgeSize/2, togleEdgeSize, togleEdgeSize);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
//    selected = self.tag == [self.question.chosenAnswerID intValue];
    
    if(selected){
        if (([ExamManager sharedManager].exam.category == MIXED_CATEGORY) && ![ExamManager sharedManager].exam.isFinished) {
            self.answerToggle.image = [UIImage imageNamed:@"Check_White_V_46x46px.png"];
        }else{

            //toggle
           [self correctOrNot];
            
            //background
            [self selectBackground];
        }
        
        
    }else{
        
        //toggle
        self.answerToggle.image = [UIImage imageNamed:@"Check_Empty_46x46px.png"];
        
        
        //background
        [self unselectBackground];
    }
    
    [super setSelected:selected animated:animated];
}

-(void)finishExam{
    
    [self correctOrNot];
    [self selectBackground];
    
}

-(void)correctOrNot{
    if ([self.question.correctAnswerID isEqualToString:self.question.chosenAnswerID]) {
        self.answerToggle.image = [UIImage imageNamed:@"Check_Green_V_46x46px.png"];
    }else{
        self.answerToggle.image = [UIImage imageNamed:@"Check_Red_X_46x46px.png"];
    }
}

-(void)selectBackground{
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

-(void)unselectBackground{
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
@end
