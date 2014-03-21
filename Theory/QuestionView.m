//
//  QuestionView.m
//  Theory
//
//  Created by Luda Fux on 5/24/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "QuestionView.h"
#import "AnswerTableViewCell.h"
#import "AnswerObject.h"

@implementation QuestionView

static NSString *CellIdentifier = @"AnswerTableViewCell";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializationFunc];
    }
    return self;
}

-(void)viewDidLoad{
    [self.answersTable registerClass:[AnswerTableViewCell class] forCellReuseIdentifier:CellIdentifier];

}
-(void)initializationFunc{
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    
    self.questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, self.scrollView.frame.size.width - 40, 50)];
    self.questionLabel.textAlignment = NSTextAlignmentRight;
    self.questionLabel.numberOfLines = 20;
    self.questionLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    self.questionLabel.textColor = [UIColor whiteColor];
    self.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.questionImage = [[UIImageView alloc]init];
    
    self.answersTable = [[UITableView alloc]init];
    self.answersTable.dataSource = self;
    self.answersTable.delegate = self;
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.questionLabel];
    [self.scrollView addSubview:self.answersTable];
    [self.scrollView addSubview:self.questionImage];
}

-(void)setUpQuestionViewWithQuestion:(QuestionObject*)question{

    __block float yOffset = 0;
    self.question = question;

    CGSize labelSize = [question.questionText sizeWithFont:self.questionLabel.font constrainedToSize:CGSizeMake(self.questionLabel.frame.size.width, 100000) lineBreakMode:self.questionLabel.lineBreakMode];
    
    self.questionLabel.frame = CGRectMake(self.questionLabel.frame.origin.x, self.questionLabel.frame.origin.y, self.questionLabel.frame.size.width, labelSize.height);
    self.questionLabel.text = question.questionText;
    
    yOffset += labelSize.height+ 20;
    
    if (![question.questionLink isEqualToString:@""]) {
        

        NSURL* aURL = [NSURL URLWithString:question.questionLink];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:aURL];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image){
                    self.questionImage.image = image;
                    self.questionImage.contentMode = UIViewContentModeScaleAspectFit;
                    
                    float widthRatio = 200 / self.questionImage.image.size.width;
                    float heightRatio = 200 / self.questionImage.image.size.height;
                    float scale = MIN(widthRatio, heightRatio);
                    float imageHeight = scale * self.questionImage.image.size.height;
                    
                    self.questionImage.frame = CGRectMake(self.frame.size.width / 2 - 100, yOffset, 200, imageHeight);
                    
                    yOffset += self.questionImage.frame.size.height + 22;
                    
                    self.answersTable.frame = CGRectMake(20, yOffset, self.scrollView.frame.size.width-40, 500);
                }
            });
        });
        
        
        
        
    }
    self.answersTable.frame = CGRectMake(20, yOffset, self.scrollView.frame.size.width-40, 500);
    self.answersTable.backgroundColor = [UIColor clearColor];
    self.answersTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.answersTable reloadData];


}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.question.answers count];
}

-(AnswerTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AnswerTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.answersTable.frame.size.width, [self tableView:nil heightForRowAtIndexPath:indexPath])];
    }
    
    AnswerObject* answer = self.question.answers[indexPath.row];

    CGFloat height = [self tableView:nil heightForRowAtIndexPath:indexPath];
    [cell setupAnswerTableViewCell:self.question answer:answer row:indexPath.row height:height];
    
//    [cell setupAnswerTableViewCell:self.question answer:answer row:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerObject* answer = self.question.answers[indexPath.row];
    CGFloat height = [AnswerTableViewCell answerCellHeight:answer];
    if(height < 60){
        height=60;
    }
    return height;
}

- (void)answerWasChosen:(AnswerTableViewCell*)answerCell{
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

-(void)changeSelectedToVanX{
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
}

@end
