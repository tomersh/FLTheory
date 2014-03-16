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
#import "ExamManager.h"
#import "QuestionView.h"
#import "QuestionObject.h"
#import "Shared.h"
#import "CategoryViewCollectionCell.h"
#import "CategoryViewChosen.h"

@interface TestScreenViewController ()
@property (nonatomic, strong) NSMutableArray *menuItems;
@end

@implementation TestScreenViewController

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
    
    [self startRepeatingTimer];
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[OverviewViewController class]]) {
        OverviewViewController* overview = [self.storyboard instantiateViewControllerWithIdentifier:@"Overview"];
        self.slidingViewController.underRightViewController = overview;
        overview.overviewDelegate = self;
    }
    
	_carousel.type = iCarouselTypeLinear;
    [_carousel scrollToItemAtIndex:[ExamManager sharedManager].exam.userLocationPlaceInQuestionsArray animated:NO];
    self.carousel.clipsToBounds = YES;
    
    isCategoryViewDown = NO;
    
    Thoery_Category category = [self.menuItems[[self.menuItems count]-1] intValue];
    [self.chosenCategoryView setupCategoryView:category];
    self.chosenCategoryView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)nextQuestionButton:(id)sender {
    [_carousel scrollToItemAtIndex:_carousel.currentItemIndex+1 animated:YES];
}

- (IBAction)previuesQuestionButton:(id)sender {
     [_carousel scrollToItemAtIndex:_carousel.currentItemIndex-1 animated:YES];
}
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [[ExamManager sharedManager].exam.questions count];
}

- (QuestionView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(QuestionView *)view
{
//    if (!view)
//    {
        view = (QuestionView*)[[[NSBundle mainBundle] loadNibNamed:@"QuestionView" owner:self options:nil] lastObject];
//    }
    //create question and coresponding view
    QuestionObject* question = (QuestionObject*)[[ExamManager sharedManager].exam.questions objectAtIndex:index];
    
    
    //set the question view
    view.questionLabel.text= question.questionText;
    
    //set the answers. travers on answer views: find them by tag
    int yOffset = view.questionTextView.frame.size.height;
    for (int i = 0; i< [question.answers count]; i++){
        
        AnswerObject* answer = question.answers[i];
        //create and set answer view
        AnswerView* answerView = (AnswerView*)[[[NSBundle mainBundle] loadNibNamed:@"AnswerView" owner:self options:nil] lastObject];
        answerView.answerLabel.text = answer.answerText;

        
        //add function
        [answerView.answerToggle addTarget:self
                                    action:@selector(flip:)
                          forControlEvents:UIControlEventTouchDown];
        
        CGRect answerFrame = CGRectMake(0, yOffset, answerView.frame.size.width, answerView.frame.size.height);
        answerView.frame = answerFrame;
        yOffset += answerView.frame.size.height;
        answerView.answerToggle.tag = [answer.answerID intValue];
        //add answer view to the question view
        
        if (i == 0) {
            answerView.backgroundImage.image = [UIImage imageNamed:@"List_Top_Item_Not_Selected_612x113px.png"];
        }
        else if (i == ([question.answers count] - 1)){
            answerView.backgroundImage.image = [UIImage imageNamed:@"List_Bottom_Item_Not_Selected_612x113px.png"];
        }
        else{
            answerView.backgroundImage.image = [UIImage imageNamed:@"List_Item_Not_Selected_612x113px.png"];
        }
        [view addSubview:answerView];
        
        
    }
    
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
    [ExamManager sharedManager].exam.userLocationPlaceInQuestionsArray = carousel.currentItemIndex;
}

#pragma mark toggle answer
- (IBAction)flip:(UIButton*)sender{
    QuestionObject* curentQuestion = [[ExamManager sharedManager].exam.questions objectAtIndex:_carousel.currentItemIndex];
    int minIndex = [curentQuestion.correctAnswerID intValue];
    if (sender.tag > 0) {
        if ([ExamManager sharedManager].exam.examType == LEARNING_EXAM_TYPE) {
            //if the exam is in simalation stage, check if it correct
            if ([curentQuestion.correctAnswerID isEqualToString:[NSString stringWithFormat:@"%d",sender.tag]]) {
                //if answer is correct
                [sender setBackgroundImage:[UIImage imageNamed:@"Check_Green_V_46x46px.png"] forState:UIControlStateNormal];
                
            }else{
                [sender setBackgroundImage:[UIImage imageNamed:@"Check_Red_X_46x46px.png"] forState:UIControlStateNormal];
            }
        }else{
            for (int i = minIndex; i <= minIndex+4; i++) {
                UIButton *oneOfTheAnswerButtons = (UIButton*)[self.view viewWithTag:i];
                //if so, check the state of the exam
                //check if the button tag that is being enumarated is equest to the sender tag
                if (oneOfTheAnswerButtons.tag == sender.tag) {
                    
                    //if it is a learning stage, check if the answer is correct and change the image accordingly
                    [sender setBackgroundImage:[UIImage imageNamed:@"Check_White_V_46x46px.png"] forState:UIControlStateNormal];
                    curentQuestion.chosenAnswerID = [NSString stringWithFormat:@"%d", sender.tag];
                }else{
                    //esle unseelct the answer
                    [oneOfTheAnswerButtons setBackgroundImage:[UIImage imageNamed:@"Check_Empty_46x46px.png"] forState:UIControlStateNormal];
                }
            }
        }
        //save the chosen answer
        curentQuestion.chosenAnswerID = [NSString stringWithFormat:@"%d", sender.tag];
    }
}

-(void)changeSelectedToVanX{
    for (QuestionObject* question in [ExamManager sharedManager].exam.questions) {
        if(question.chosenAnswerID){
            UIButton *chosenAnswerButton = (UIButton*)[self.view viewWithTag:[question.chosenAnswerID intValue]];
            if (question.correctAnswerID == question.chosenAnswerID) {
                [chosenAnswerButton setBackgroundImage:[UIImage imageNamed:@"Check_Green_V_46x46px.png"] forState:UIControlStateNormal];
            }
            else{
                [chosenAnswerButton setBackgroundImage:[UIImage imageNamed:@"Check_Red_X_46x46px.png"] forState:UIControlStateNormal];
            }
        }
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
        [self stopRepeatingTimer];
        [ExamManager sharedManager].exam.examType = LEARNING_EXAM_TYPE;
        [self changeSelectedToVanX];
    }
    self.timerLabel.hidden = NO;
}

- (void)stopRepeatingTimer {
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

-(void)reloadCarouselWithNewCategory:(Thoery_Category)category{
    //load data
    [[ExamManager sharedManager]reloadExamWithNewCategory:category andNumberOfQuestions:30];
    [self.carousel reloadData];
    [self.carousel scrollToItemAtIndex:0 animated:YES];
}

-(void)didChoseQuestion:(int)index{
    [self.slidingViewController resetTopView];
    [self.carousel scrollToItemAtIndex:index animated:YES];
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

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.menuItems count]-1;
}

- (CategoryViewCollectionCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryViewCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryViewCollectionCell" forIndexPath:indexPath];
    Thoery_Category category = [self.menuItems[indexPath.row] intValue];
    [cell setupCategoryView:category];

    return cell;
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Thoery_Category chosenCategory = [self.menuItems[indexPath.row] intValue];
    Thoery_Category oldCategory = self.chosenCategoryView.category;
    
    //handle carousel
    [self reloadCarouselWithNewCategory:chosenCategory];
    
    //handle catogories
    [self.menuItems replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:oldCategory]];
    [self.menuItems replaceObjectAtIndex:([self.menuItems count]-1) withObject:[NSNumber numberWithInt:chosenCategory]];

    [self.chosenCategoryView setupCategoryView:chosenCategory];
    
    //animations
    self.chosenCategoryView.hidden = YES;
    
    CategoryView *datasetCell =(CategoryView*)[collectionView cellForItemAtIndexPath:indexPath];

//    [UIView animateWithDuration:1
//                          delay:0
//                        options: UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                          self.navigationBar.frame = CGRectMake(0, -90, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
//                     
        [UIView animateWithDuration:0.1
                              delay:0
                            options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionOverrideInheritedDuration
                         animations:^{
                             datasetCell.categoryImage.bounds = CGRectMake(0, 0, 50, 50);
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.3
                                                   delay:0
                                                 options: UIViewAnimationOptionCurveEaseOut
                                              animations:^{
                                                  datasetCell.categoryImage.bounds = CGRectMake(0, 0, 5, 5);
                                                  datasetCell.categoryNameLabel.alpha = 0.0f;
                                              }
                                              completion:^(BOOL finished){
                                                  
                                                  datasetCell.hidden = YES;
                                                  datasetCell.categoryImage.bounds = CGRectMake(0, 0, 45, 45);
                                                  datasetCell.categoryNameLabel.alpha = 1.0f;
                                                  datasetCell.alpha = 0.0f;
                                                  
                                                  self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 5, 5);
                                                  self.chosenCategoryView.categoryNameLabel.alpha = 0.0f;
                                                  self.chosenCategoryView.hidden = NO;
                                                  
                                                  [UIView animateWithDuration:0.3
                                                                        delay:0
                                                                      options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                                                   animations:^{
                                                                       
                                                                       
                                                                       
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
                         }];
//                     }
//                     completion:^(BOOL finished){
//                         
//                     }];
}

#pragma mark chosenCategoryWasPressed
-(void)chosenCategoryWasPressed{
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.navigationBar.frame = CGRectMake(0, 0, self.navigationBar.frame.size.width, self.navigationBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         
                     }];
}


@end
