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

    float yOffset = 0;
    self.question = question;

    CGSize labelSize = [question.questionText sizeWithFont:self.questionLabel.font constrainedToSize:CGSizeMake(self.questionLabel.frame.size.width, 100000) lineBreakMode:self.questionLabel.lineBreakMode];
    
    self.questionLabel.frame = CGRectMake(self.questionLabel.frame.origin.x, self.questionLabel.frame.origin.y, self.questionLabel.frame.size.width, labelSize.height);
    self.questionLabel.text = question.questionText;
    
    yOffset += labelSize.height+ 20;
    
    if (![question.questionLink isEqualToString:@""]) {
        

        NSURL* aURL = [NSURL URLWithString:question.questionLink];
        NSData* data = [[NSData alloc] initWithContentsOfURL:aURL];
        self.questionImage.image = [UIImage imageWithData:data];
        self.questionImage.contentMode = UIViewContentModeScaleAspectFit;
        
        self.questionImage.frame = CGRectMake(self.frame.size.width / 2 - 100, yOffset, 200, 200);
        
        float widthRatio = self.questionImage.bounds.size.width / self.questionImage.image.size.width;
        float heightRatio = self.questionImage.bounds.size.height / self.questionImage.image.size.height;
        float scale = MIN(widthRatio, heightRatio);
        float imageHeight = scale * self.questionImage.image.size.height;
        
        self.questionImage.frame = CGRectMake(self.frame.size.width / 2 - 100, yOffset, 200, imageHeight);
        
        yOffset += self.questionImage.frame.size.height + 22;
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
        cell = [[AnswerTableViewCell alloc] init];//]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    AnswerObject* answer = self.question.answers[indexPath.row];

    [cell setupAnswerTableViewCell:self.question answer:answer row:indexPath.row];
        
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnswerObject* answer = self.question.answers[indexPath.row];
    CGFloat height = [AnswerTableViewCell answerCellHeight:answer];
    if(height < 40){
        height=40;
    }
    NSLog(@"height - %f",height);
    return height;
}
@end
