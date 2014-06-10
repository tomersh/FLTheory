//
//  OverviewViewController.m
//  Theory
//
//  Created by Luda Fux on 8/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "OverviewViewController.h"
#import "ECSlidingViewController.h"
#import "OverviewCell.h"

@interface OverviewViewController ()
@property (nonatomic, assign) CGFloat peekLeftAmount;
@end

@implementation OverviewViewController
@synthesize peekLeftAmount;

static NSString *identifier = @"OverviewCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.peekLeftAmount = 75.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
    self.questionsOverviewCollection.clipsToBounds = YES;
    self.questionsOverviewCollection.backgroundColor = [UIColor clearColor];
    [self.questionsOverviewCollection registerClass:[OverviewCell class] forCellWithReuseIdentifier:identifier];
    self.finishExamButton.titleLabel.textColor = [Shared colorForCategory:MIXED_CATEGORY];
    self.finishExamButton.hidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.questionsOverviewCollection reloadData];
    
    CGFloat yOffset = ([Shared is4inch]?40.0:0.0);
    self.titleLabel.top = self.titleLabel.frame.origin.y + yOffset;
    self.questionsOverviewCollection.top = self.questionsOverviewCollection.frame.origin.y + yOffset;
    self.didYouPassLabel.top = self.questionsOverviewCollection.bottom + 2;
    self.numberOfWrongAnswersLabel.top = self.questionsOverviewCollection.bottom;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[ExamManager sharedManager].exam.questions count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OverviewCell *cell = (OverviewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell setupCell:[[ExamManager sharedManager].exam.questions objectAtIndex:indexPath.row] row:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.overviewDelegate didChoseQuestion:indexPath.row];
}

-(void)finishExam{
    
    for (int i = 0; i < [self.questionsOverviewCollection numberOfItemsInSection:0]; i++) {
        OverviewCell *cell = (OverviewCell*)[self.questionsOverviewCollection cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            [cell finishExam];
    }
    
    NSString* numberOfWrongAnswersText = [NSString stringWithFormat:@"%d תשובות לא נכונות - ",[ExamManager sharedManager].exam.numOfWrongAswers];

    
    CGRect labelSize = [numberOfWrongAnswersText boundingRectWithSize:CGSizeMake(self.numberOfWrongAnswersLabel.frame.size.width, self.numberOfWrongAnswersLabel.frame.size.height)
                           options:NSStringDrawingUsesLineFragmentOrigin
                        attributes:@{NSFontAttributeName:self.numberOfWrongAnswersLabel.font}
                           context:nil];

    CGFloat oldRight = self.numberOfWrongAnswersLabel.right;
    
    [self.numberOfWrongAnswersLabel setWidth:labelSize.size.width];
    self.numberOfWrongAnswersLabel.right = oldRight;

    self.numberOfWrongAnswersLabel.text = numberOfWrongAnswersText;
    BOOL didPass = [ExamManager sharedManager].exam.numOfWrongAswers < 4;
    if (didPass) {
        self.didYouPassLabel.textColor = [UIColor greenColor];
        self.didYouPassLabel.text = @"עברת";
    }
    else{
        self.didYouPassLabel.textColor = [UIColor redColor];
        self.didYouPassLabel.text = @"לא עברת";
    }
    
    self.didYouPassLabel.right = self.numberOfWrongAnswersLabel.left;
    
    self.didYouPassLabel.hidden = NO;
    self.numberOfWrongAnswersLabel.hidden = NO;
}

- (IBAction)finishExamButtonPressed:(id)sender {
    self.finishExamButton.hidden = YES;
    [self.overviewDelegate presentFinishExamConfirmation];
    
}
@end
