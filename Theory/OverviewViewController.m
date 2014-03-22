//
//  OverviewViewController.m
//  Theory
//
//  Created by Luda Fux on 8/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "OverviewViewController.h"
#import "ECSlidingViewController.h"
#import "ExamManager.h"
#import "QuestionObject.h"
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
}

-(void)viewDidAppear:(BOOL)animated{
    [self.questionsOverviewCollection reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[ExamManager sharedManager].exam.questions count];
}

- (OverviewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OverviewCell *cell = (OverviewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    [cell setupCell:[[ExamManager sharedManager].exam.questions objectAtIndex:indexPath.row] row:indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.overviewDelegate didChoseQuestion:indexPath.row];
}

@end
