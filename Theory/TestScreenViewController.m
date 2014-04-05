//
//  TestScreenViewController.m
//  Theory
//
//  Created by Luda Fux on 8/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "TestScreenViewController.h"
#import "ECSlidingViewController.h"
#import "OverviewViewController.h"
#import "StatisticsViewController.h"
#import "ExamManager.h"
#import "QuestionObject.h"
#import "Shared.h"
#import "CategoryViewCollectionCell.h"
#import "CategoryViewChosen.h"

@interface TestScreenViewController ()
@property (nonatomic, strong) NSMutableArray *menuItems;
@end

@implementation TestScreenViewController

#pragma mark lifesycle

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        self.menuItems = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:SECURITY_CATEGORY],[NSNumber numberWithInt:SIGHNS_CATEGORY],[NSNumber numberWithInt:CAR_STRUCTURE_CATEGORY],[NSNumber numberWithInt:MIXED_CATEGORY],[NSNumber numberWithInt:RODE_RULS_CATEGORY],nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
	_carousel.type = iCarouselTypeLinear;
    [_carousel scrollToItemAtIndex:[ExamManager sharedManager].exam.userLocationPlaceInQuestionsArray animated:NO];
    self.carousel.clipsToBounds = YES;
    
    isCategoryViewDown = NO;
    
    Thoery_Category category = [self.menuItems[[self.menuItems count]-1] intValue];
    [self.chosenCategoryView setupCategoryView:category];
    self.chosenCategoryView.delegate = self;
    self.chosenCategoryView.categoryNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    
    [self instantiateSlidingVcWithCategory:category];
    
    [self adjustQuestionNumberLabels];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark overview
-(void)updateStatistics{
    if ([self.slidingViewController.underRightViewController isKindOfClass:[StatisticsViewController class]]) {
        StatisticsViewController *statisticsVC = (StatisticsViewController*)self.slidingViewController.underRightViewController;
        [statisticsVC updateVCWithCategory:[ExamManager sharedManager].exam.category];
    }
}

- (IBAction)revealMenu:(id)sender
{
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;

    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)revealUnderRight:(id)sender
{
    self.view.layer.shadowOpacity = 0.0f;
    self.view.layer.shadowRadius = 0.0f;

    [self.slidingViewController anchorTopViewTo:ECLeft];
}

#pragma mark iCarousel methods

- (IBAction)nextQuestionButton:(id)sender {
    if (self.carousel.currentItemIndex+1 == [[ExamManager sharedManager].exam.questions count]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"בדיקת מבחן"
                                                        message: @"בטוח רוצה לסיים?"
                                                       delegate: self
                                              cancelButtonTitle:@"לא"
                                              otherButtonTitles:@"כן",nil];
        [alert show];
    }else{
        [_carousel scrollToItemAtIndex:_carousel.currentItemIndex+1 animated:YES];
    }
}

- (IBAction)previuesQuestionButton:(id)sender {
    [_carousel scrollToItemAtIndex:_carousel.currentItemIndex-1 animated:YES];
}

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[ExamManager sharedManager].exam.questions count];
}

- (QuestionView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(QuestionView *)view
{
//    if (!view)
//    {
        view = [[QuestionView alloc]initWithFrame:self.carousel.frame];
    view.delegate = self;
//    }
    
    //create question and coresponding view
    QuestionObject* question = (QuestionObject*)[[ExamManager sharedManager].exam.questions objectAtIndex:index];

    [view setUpQuestionViewWithQuestion:question];
    return view;
    
}


- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            return value * 1.13;
        }
        default:
        {
            return value;
        }
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    if ([ExamManager sharedManager].exam.category == MIXED_CATEGORY && carousel.currentItemIndex == [[ExamManager sharedManager].exam.questions count] -1 ) {
        [self.rightArrow setBackgroundImage:[UIImage imageNamed:@"testExam.png"] forState:UIControlStateNormal];
        
    }else{
        [self.rightArrow setBackgroundImage:[Shared rightArrowForCategory:[ExamManager sharedManager].exam.category] forState:UIControlStateNormal];
    }
    [ExamManager sharedManager].exam.userLocationPlaceInQuestionsArray = carousel.currentItemIndex;
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%d",self.carousel.currentItemIndex + 1];
    [self adjustQuestionNumberLabels];
}

-(void)adjustQuestionNumberLabels{
    if ([ExamManager sharedManager].exam.category == MIXED_CATEGORY) {
        
        [self.moreInfoButton setBackgroundImage:[UIImage imageNamed:@"Resoults_without_percentage_circle_67x67px.png"] forState:UIControlStateNormal];
        
        self.questionNumberLabel.hidden = NO;
        self.outOfQuestionsSumLabel.hidden = NO;
        self.timerLabel.hidden = NO;
        
        self.outOfQuestionsSumLabel.text = [NSString stringWithFormat:@"/%lu",(unsigned long)[[ExamManager sharedManager].exam.questions count]];
        self.questionNumberLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.carousel.currentItemIndex+1];
        self.outOfQuestionsSumLabel.textColor = [Shared colorForCategory:[ExamManager sharedManager].exam.category];
        
        CGSize labelSize = [self.questionNumberLabel.text sizeWithFont:self.questionNumberLabel.font constrainedToSize:CGSizeMake(100, 100) lineBreakMode:NSLineBreakByWordWrapping];
        
        self.questionNumberLabel.frame = CGRectMake(self.questionNumberLabel.frame.origin.x, self.questionNumberLabel.frame.origin.y, labelSize.width, self.questionNumberLabel.frame.size.height);
        self.outOfQuestionsSumLabel.frame = CGRectMake(self.questionNumberLabel.frame.origin.x + labelSize.width + 2, self.outOfQuestionsSumLabel.frame.origin.y, self.outOfQuestionsSumLabel.frame.size.width, self.outOfQuestionsSumLabel.frame.size.height);

    }else{
        [self stopRepeatingTimer];
        [self.moreInfoButton setBackgroundImage:[UIImage imageNamed:@"Statistics.png"] forState:UIControlStateNormal];
        self.timerLabel.hidden = YES;
        self.questionNumberLabel.hidden = YES;
        self.outOfQuestionsSumLabel.hidden = YES;
    }
    
    if (self.carousel.currentItemIndex == 0) {
        self.leftArrow.hidden = YES;
    }else{
        self.leftArrow.hidden = NO;
    }
    
}

#pragma mark timer

- (void)startRepeatingTimer{
    
    // Cancel a preexisting timer.
    [self.repeatingTimer invalidate];
    self.remainingTime = 6;//30*60+1; //30 minutes
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(tickOneSecondOnSimulationTimer:)
                                                    userInfo:nil
                                                     repeats:YES];
    self.repeatingTimer = timer;
    
    [[NSRunLoop mainRunLoop] addTimer: self.repeatingTimer
                              forMode: UITrackingRunLoopMode];
}


- (void)tickOneSecondOnSimulationTimer:(NSTimer*)theTimer {
    self.remainingTime -= 1;
    int minutes = (int)self.remainingTime / 60;
    int seconds = (int)self.remainingTime % 60;
    
    NSString* timerLabelText = nil;
    if (seconds<10) {
        timerLabelText=[NSString stringWithFormat:@"%d:0%d",minutes,seconds];
    }else{
        timerLabelText=[NSString stringWithFormat:@"%d:%d",minutes,seconds];
    }
    self.timerLabel.text = timerLabelText;
    
    //if time is up
    if (minutes==0 && seconds==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"נגמר הזמן"
                                                        message: nil
                                                       delegate: self
                                              cancelButtonTitle: nil
                                              otherButtonTitles: nil];
        [alert show];
        
        [self dismissAlertViewAfterDelay:alert];
        [self stopRepeatingTimer];
    }
}
-(void)dismissAlertViewAfterDelay:(UIAlertView*)alertView{
    [self performSelector:@selector(dismissAlertView:) withObject:alertView afterDelay:3];
}

-(void)dismissAlertView:(UIAlertView *)alertView{
    [self finishExam];
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
- (void)stopRepeatingTimer {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

-(void)reloadCarouselWithNewCategory:(Thoery_Category)category{
    [[ExamManager sharedManager]reloadExamWithNewCategory:category andNumberOfQuestions:30];
    [self.carousel reloadData];
    [self.carousel scrollToItemAtIndex:0 animated:YES];
}

-(void)didChoseQuestion:(int)index{
    [self.slidingViewController resetTopView];
    [self.carousel scrollToItemAtIndex:index animated:YES];
    [self adjustQuestionNumberLabels];
}

#pragma mark categories

-(void)chosenCategoryWasPressed{
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.navigationBar.frame = CGRectMake(0, 0, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    self.dismissCategoriesButton.hidden = NO;
    
}

- (IBAction)didPressDismissCategoriesButton:(id)sender {
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.navigationBar.frame = CGRectMake(0, -90, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
    self.dismissCategoriesButton.hidden = YES;
}

- (IBAction)didPressChosenCategory:(id)sender {
    CGRect frameForNavigationBar = self.navigationBar.frame;
    
    if (isCategoryViewDown) {
        
        frameForNavigationBar.origin.y -= 90;
        
    }else{
        
        frameForNavigationBar.origin.y += 90;
        
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.navigationBar.frame = frameForNavigationBar;
                     }];
    
    isCategoryViewDown = !isCategoryViewDown;
}



- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.menuItems count]-1;
}

- (CategoryViewCollectionCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryViewCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryViewCollectionCell" forIndexPath:indexPath];
    Thoery_Category category = [self.menuItems[indexPath.row] intValue];
    [cell setupCategoryView:category];

    return cell;
}

-(void)instantiateSlidingVcWithCategory:(Thoery_Category)category{
    if (category == MIXED_CATEGORY) {
        if (![self.slidingViewController.underRightViewController isKindOfClass:[OverviewViewController class]]) {
            OverviewViewController* overview = [self.storyboard instantiateViewControllerWithIdentifier:@"Overview"];
            self.slidingViewController.underRightViewController = overview;
            overview.overviewDelegate = self;
        }
    }else{
        if (![self.slidingViewController.underRightViewController isKindOfClass:[StatisticsViewController class]]) {
            StatisticsViewController* statisticsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Statistics"];
            self.slidingViewController.underRightViewController = statisticsVC;
            [statisticsVC updateVCWithCategory:category];
            //        overview.overviewDelegate = self;
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Thoery_Category chosenCategory = [self.menuItems[indexPath.row] intValue];
    
    
    [ExamManager sharedManager].exam.category = chosenCategory;
    
    if ( [ExamManager sharedManager].exam.category == MIXED_CATEGORY) {
        [self startRepeatingTimer];
    }
    
    [self.leftArrow setBackgroundImage:[Shared leftArrowForCategory:chosenCategory] forState:UIControlStateNormal];
    [self.rightArrow setBackgroundImage:[Shared rightArrowForCategory:chosenCategory] forState:UIControlStateNormal];
    
    Thoery_Category oldCategory = self.chosenCategoryView.category;
    
    //handle carousel
    [self reloadCarouselWithNewCategory:chosenCategory];
    
    //handle catogories
    [self.menuItems replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:oldCategory]];
    [self.menuItems replaceObjectAtIndex:([self.menuItems count]-1) withObject:[NSNumber numberWithInt:chosenCategory]];

    [self.chosenCategoryView setupCategoryView:chosenCategory];
    [self instantiateSlidingVcWithCategory:chosenCategory];
    [self adjustQuestionNumberLabels];
    [self performSelectorInBackground:@selector(updateStatistics) withObject:nil];
   
    //animations
    self.chosenCategoryView.hidden = YES;
    
    CategoryView *datasetCell =(CategoryView*)[collectionView cellForItemAtIndexPath:indexPath];

    [UIView animateWithDuration:0.6
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                          self.navigationBar.frame = CGRectMake(0, -90, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
                     
        [UIView animateWithDuration:0.1
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionOverrideInheritedDuration
                         animations:^{
                             datasetCell.categoryImage.bounds = CGRectMake(0, 0, 50, 50);
                         }
                         completion:^(BOOL finished){
                             self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 15, 15);
                             self.chosenCategoryView.categoryNameLabel.alpha = 0.0f;
                             self.chosenCategoryView.hidden = NO;
                             
                             [UIView animateWithDuration:0.5
                                                   delay:0
                                                 options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                              animations:^{
                                                  [UIView animateWithDuration:0.3
                                                                        delay:0
                                                                      options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                                                   animations:^{
                                                                       datasetCell.categoryImage.bounds = CGRectMake(0, 0, 5, 5);
                                                                       datasetCell.categoryNameLabel.alpha = 0.0f;
                                                                   }
                                                                   completion:^(BOOL finished){
                                                                       datasetCell.hidden = YES;
                                                                       datasetCell.categoryImage.bounds = CGRectMake(0, 0, 45, 45);
                                                                       datasetCell.categoryNameLabel.alpha = 1.0f;
                                                                       datasetCell.alpha = 0.0f;
                                                                       
                                                                   }];
                                                  
                                                  self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 50, 50);
                                                  self.chosenCategoryView.categoryNameLabel.alpha = 1.0f;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  
                                                
                                                  [UIView animateWithDuration:0.3
                                                                         delay:0
                                                                       options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                                                    animations:^{
                                                                        self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 45, 45);
                                                                    }
                                                                    completion:^(BOOL finished){
                                                                        
                                                                        datasetCell.hidden = NO;
                                                                        
                                                                        [self.categoriesCollectionView reloadData];
                                                                        
                                                                        [UIView animateWithDuration:1
                                                                                              delay:0
                                                                                            options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                                                                         animations:^{
                                                                                             self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 45, 45);
                                                                                         }
                                                                                         completion:^(BOOL finished){
                                                                                             
                                                                                             [self.categoriesCollectionView reloadData];
                                                                                             datasetCell.alpha = 1.0f;
                                                                                         }];

                                                                    }];
                                              
                                              }];
                         }];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self finishExam];
    }
}

-(void)updateoverview{
    //show correct incorrect in overview
    OverviewViewController* overview = (OverviewViewController*)self.slidingViewController.underRightViewController;
    [overview finishExam];
}

-(void)finishExam{

    [ExamManager sharedManager].exam.isFinished = YES;
    
    //show overview
    [self revealUnderRight:nil];

    [self performSelector:@selector(updateoverview) withObject:nil afterDelay:0.5]; //with delay becouse http://stackoverflow.com/questions/22861804/uicollectionview-cellforitematindexpath-is-nil
    
    //show correct incorrect in carousel
    for(int i = 0; i < [self.carousel numberOfItems]; i++){
        QuestionView* questionView = (QuestionView*)[self.carousel itemViewAtIndex:i];
        [questionView finishExam];
    }
}
@end
