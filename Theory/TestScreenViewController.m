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
#import "CategoryView.h"
#import "DatabaseManager.h"
#import "CategorySimulation.h"
#import "CategoriesContainerViewController.h"

@interface TestScreenViewController ()

@property (nonatomic, strong) CategoriesContainerViewController *categoriesContainer;
@end

@implementation TestScreenViewController

#pragma mark lifesycle

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super initWithCoder:decoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.categoriesContainer = (CategoriesContainerViewController*)self.childViewControllers[0];
    
	_carousel.type = iCarouselTypeLinear;
    [_carousel scrollToItemAtIndex:[ExamManager sharedManager].exam.userLocationPlaceInQuestionsArray animated:NO];
    self.carousel.clipsToBounds = YES;
    
    self.isCategoryViewDown = NO;
    
    [self instantiateSlidingVcWithCategory:[ExamManager sharedManager].exam.category];
    
    [self adjustQuestionNumberLabels];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark statistics

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
            [statisticsVC performSelectorInBackground:@selector(updateVCWithCategory:) withObject:[NSNumber numberWithInt:category]];
            //        overview.overviewDelegate = self;
        }
    }
}


-(void)updateStatistics{
    if ([self.slidingViewController.underRightViewController isKindOfClass:[StatisticsViewController class]]) {
        StatisticsViewController *statisticsVC = (StatisticsViewController*)self.slidingViewController.underRightViewController;
        [statisticsVC performSelectorInBackground:@selector(updateVCWithCategory:) withObject:[NSNumber numberWithInt:[ExamManager sharedManager].exam.category]];
    }
}

-(void)saveSimulationData{
    NSMutableDictionary* simulationData = [NSMutableDictionary dictionary];
    for (QuestionObject* question in [ExamManager sharedManager].exam.questions) {
        
        CategorySimulation* partialSimulationData = [simulationData objectForKey:[NSString stringWithFormat: @"%d",question.questionCategory ]];
        if (!partialSimulationData) {
            partialSimulationData = [[CategorySimulation alloc]init];
        }
        
        partialSimulationData.totalNumQuestions ++;
        
        if ([question.correctAnswerID isEqualToString:question.chosenAnswerID]) {
            partialSimulationData.correctNumQuestions ++;
        }
        
        [simulationData setObject:partialSimulationData forKey:[NSString stringWithFormat: @"%d",question.questionCategory ]];
    }
    
    for (CategorySimulation* partialSimulationData in [simulationData allValues]) {
        partialSimulationData.correctPercent = (float) partialSimulationData.correctNumQuestions / (float) partialSimulationData.totalNumQuestions * 100;
    }
    
    [[DatabaseManager shared] saveSimulationData:simulationData];
}

//- (IBAction)revealMenu:(id)sender
//{
//    self.view.layer.shadowOpacity = 0.75f;
//    self.view.layer.shadowRadius = 10.0f;
//    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
//
//    [self.slidingViewController anchorTopViewTo:ECRight];
//}

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
    if (!view)
    {
        view = [[QuestionView alloc]initWithFrame:self.carousel.frame];
        view.delegate = self;
    }
    else{
        view.top = self.carousel.top;
    }

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

    [ExamManager sharedManager].exam.userLocationPlaceInQuestionsArray = self.carousel.currentItemIndex;
    self.questionNumberLabel.text = [NSString stringWithFormat:@"%ld",self.carousel.currentItemIndex + 1];
    [self adjustQuestionNumberLabels];
}

-(void)didChoseQuestion:(int)index{
    [self.slidingViewController resetTopView];
    [self.carousel scrollToItemAtIndex:index animated:YES];
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
        
        
        CGRect labelSize = [self.questionNumberLabel.text boundingRectWithSize:CGSizeMake(100, 100)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:@{NSFontAttributeName:self.questionNumberLabel.font}
                                            context:nil];
        
        self.questionNumberLabel.frame = CGRectMake(self.questionNumberLabel.frame.origin.x, self.questionNumberLabel.frame.origin.y, labelSize.size.width, self.questionNumberLabel.frame.size.height);
        self.outOfQuestionsSumLabel.frame = CGRectMake(self.questionNumberLabel.frame.origin.x + labelSize.size.width + 2, self.outOfQuestionsSumLabel.frame.origin.y, self.outOfQuestionsSumLabel.frame.size.width, self.outOfQuestionsSumLabel.frame.size.height);

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
    self.remainingTime = 30*60+1; //30 minutes
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
        
        [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:3];
        [self stopRepeatingTimer];
    }
}

- (void)stopRepeatingTimer {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}


#pragma mark finish exam

-(void)dismissAlertView:(UIAlertView *)alertView{
    [self finishExam];
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
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
    
    [self performSelectorInBackground:@selector(saveSimulationData) withObject:nil];
}


#pragma mark categoriesContainer functions

-(void)categoryWasUpdated:(Thoery_Category)chosenCategory{
    //handle carousel
    [self updateCarousel:[NSNumber numberWithInt: chosenCategory]];
    [self instantiateSlidingVcWithCategory:chosenCategory];
}


-(void)updateCarousel:(NSNumber*)categoryNumber{

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        Thoery_Category category = [categoryNumber intValue];
        [[ExamManager sharedManager]reloadExamWithNewCategory:category];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.carousel reloadData];
            [self.carousel scrollToItemAtIndex:0 animated:YES];
            [self updateStatistics];
            [self adjustQuestionNumberLabels];
            if ( [ExamManager sharedManager].exam.category == MIXED_CATEGORY) {
                [self startRepeatingTimer];
            }
        });
        
    });
}

-(void)didPressAlreadyChosenCategory:(id)sender {
    [self.categoriesContainer didPressChosenCategory:self.isCategoryViewDown];
}

-(void)setCategoryViewDown:(BOOL)categoryViewDown{
    self.isCategoryViewDown = categoryViewDown;
}
@end
