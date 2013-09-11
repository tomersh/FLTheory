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

@interface OverviewViewController ()
@property (nonatomic, assign) CGFloat peekLeftAmount;
@end

@implementation OverviewViewController
@synthesize peekLeftAmount;
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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"OverviewCell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    UIImage *imageForCell = [self imageWithImage:[self imageForSelectedOfQuestion:[[ExamManager sharedManager].exam.questions objectAtIndex:indexPath.row]]scaledToSize:cell.frame.size];
    UIImageView *answerImage = [[UIImageView alloc]initWithImage:imageForCell];
    [cell addSubview:answerImage];
    
    return cell;
}


-(UIImage*)imageForSelectedOfQuestion:(QuestionObject*)question{
    UIImage* imageToReturn = nil;
    if (question.chosenAnswerID) {
        
        //if any answer was chosen, look what sign there should be presented
        if ([ExamManager sharedManager].exam.examType == LEARNING_EXAM_TYPE) {
            
            //if the exam is in simalation stage, check if it correct
            if ([question.correctAnswerID isEqualToString:question.chosenAnswerID]) {
                
                //if answer is correct
                imageToReturn = [UIImage imageNamed:@"v.png"];
                
            }else{
                
                //if the answer is wrong
                imageToReturn = [UIImage imageNamed:@"x.png"];
            }
            
        }else{
            
            //if the exam is in simulation state then only select it
            imageToReturn = [UIImage imageNamed:@"checked.png"];
        }
    }else{
        
        //if the answer is not chosen, use unselected icon
        imageToReturn = [UIImage imageNamed:@"uncheked.png"];
        
    }
    return imageToReturn;
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.overviewDelegate didChoseQuestion:indexPath.row];
}

@end
