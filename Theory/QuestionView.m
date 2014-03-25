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
#import "ExamManager.h"

@implementation QuestionView

static NSString *CellIdentifier = @"AnswerTableViewCell";
static CGFloat bufferBetweenViews = 25;

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
    self.answersTable.backgroundColor = [UIColor clearColor];
    self.answersTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.answersTable.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.questionLabel];
    [self.scrollView addSubview:self.answersTable];
    [self.scrollView addSubview:self.questionImage];
}

-(void)setUpQuestionViewWithQuestion:(QuestionObject*)question{

    __block CGFloat availbleHeightForAnswersTable = [[UIScreen mainScreen] bounds].size.height - self.frame.origin.y;
    __block float yOffset = 0;
    self.question = question;

    CGSize labelSize = [question.questionText sizeWithFont:self.questionLabel.font constrainedToSize:CGSizeMake(self.questionLabel.frame.size.width, 100000) lineBreakMode:self.questionLabel.lineBreakMode];
    
    self.questionLabel.frame = CGRectMake(self.questionLabel.frame.origin.x, self.questionLabel.frame.origin.y, self.questionLabel.frame.size.width, labelSize.height);
    self.questionLabel.text = question.questionText;
    
    yOffset += self.questionLabel.frame.size.height + bufferBetweenViews;
    availbleHeightForAnswersTable -= self.questionLabel.frame.size.height + self.questionLabel.frame.origin.y + bufferBetweenViews*2;
    
    if (![question.questionLink isEqualToString:@""]) {
        
        UIImage* defaultImage = [UIImage imageNamed:@"coming-soon.png"];
        [self adjastViewAccordingToImage:defaultImage availbleHeightForAnswersTable:availbleHeightForAnswersTable yOffset:yOffset maxHeight:100];
        
        NSURL* aURL = [NSURL URLWithString:question.questionLink];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
        dispatch_async(queue, ^{
            NSData *data = [NSData dataWithContentsOfURL:aURL];
            UIImage *image = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if(image){
                    [self adjastViewAccordingToImage:image availbleHeightForAnswersTable:availbleHeightForAnswersTable yOffset:yOffset maxHeight:200];
                }
            });
        });
           
    }else{
        [self reudjastTable:availbleHeightForAnswersTable yOffset:yOffset];
    }
    [self.answersTable flashScrollIndicators];
}

-(void)adjastViewAccordingToImage:(UIImage*)image
    availbleHeightForAnswersTable:(CGFloat)availbleHeightForAnswersTable
                          yOffset:(CGFloat)yOffset
                        maxHeight:(CGFloat)maxHeight{
    self.questionImage.image = image;
    self.questionImage.contentMode = UIViewContentModeScaleAspectFit;
    
    float widthRatio = 200 / self.questionImage.image.size.width;
    float heightRatio = maxHeight / self.questionImage.image.size.height;
    float scale = MIN(widthRatio, heightRatio);
    float imageHeight = scale * self.questionImage.image.size.height;
    
    self.questionImage.frame = CGRectMake(self.frame.size.width / 2 - 100, yOffset, 200, imageHeight);
    
    yOffset += self.questionImage.frame.size.height + bufferBetweenViews;
    availbleHeightForAnswersTable -= self.questionImage.frame.size.height + bufferBetweenViews;
    
    [self reudjastTable:availbleHeightForAnswersTable yOffset:yOffset];

}

-(void)reudjastTable:(CGFloat)availbleHeightForAnswersTable
             yOffset:(CGFloat)yOffset{
    CGFloat maxHeight = 0.0;
    for (int i = 0; i < [self.answersTable numberOfRowsInSection:0]; i++){
        CGFloat foundHeight = [AnswerTableViewCell answerCellHeight:self.question.answers[i]];
        if (foundHeight > maxHeight) {
            maxHeight = foundHeight;
        }
    }
    
    if ( maxHeight*4 < availbleHeightForAnswersTable) {
        for (int i = 0; i < [self.answersTable numberOfRowsInSection:0]; i++){
            AnswerObject *answerObject = self.question.answers[i];
            answerObject.cellHeight = availbleHeightForAnswersTable / 4;
        }
    }else{
        
        for (int i = 0; i < [self.answersTable numberOfRowsInSection:0]; i++){
            AnswerObject *answerObject = self.question.answers[i];
            answerObject.cellHeight = maxHeight;
        }
    }
    self.answersTable.frame = CGRectMake(20, yOffset, self.scrollView.frame.size.width-40, availbleHeightForAnswersTable);
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
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerObject* answer = self.question.answers[indexPath.row];
    return answer.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerTableViewCell *cell = (AnswerTableViewCell*)[self.answersTable cellForRowAtIndexPath:indexPath];
    self.question.chosenAnswerID = [NSString stringWithFormat:@"%ld", (long)cell.tag];
    
    [self.answersTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];

}

@end
