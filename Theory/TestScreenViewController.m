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
@interface TestScreenViewController ()

@end

@implementation TestScreenViewController

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
    
//    self.timerLabel.text = [Shared nameOfCategory:[ExamManager sharedManager].exam.category];
    [self startRepeatingTimer];
    
    if (![self.slidingViewController.underRightViewController isKindOfClass:[OverviewViewController class]]) {
        OverviewViewController* overview = [self.storyboard instantiateViewControllerWithIdentifier:@"Overview"];
        self.slidingViewController.underRightViewController = overview;
        overview.overviewDelegate = self;
    }
    
	_carousel.type = iCarouselTypeLinear;
    [_carousel scrollToItemAtIndex:[ExamManager sharedManager].exam.userLocationPlaceInQuestionsArray animated:NO];
    self.carousel.clipsToBounds = YES;
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
    if (!view)
    {
        view = (QuestionView*)[[[NSBundle mainBundle] loadNibNamed:@"QuestionView" owner:self options:nil] lastObject];
    }
    //create question and coresponding view
    QuestionObject* question = (QuestionObject*)[[ExamManager sharedManager].exam.questions objectAtIndex:index];
    
    
    //set the question view
    view.questionLabel.text= question.questionText;
    
    //set the answers. travers on answer views: find them by tag
    int yOffset = view.questionTextView.frame.size.height;
    for (AnswerObject* answer in question.answers) {
        
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
                [sender setBackgroundImage:[UIImage imageNamed:@"v.png"] forState:UIControlStateNormal];
                
            }else{
                [sender setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
            }
        }else{
            for (int i = minIndex; i <= minIndex+4; i++) {
                UIButton *oneOfTheAnswerButtons = (UIButton*)[self.view viewWithTag:i];
                //if so, check the state of the exam
                //check if the button tag that is being enumarated is equest to the sender tag
                if (oneOfTheAnswerButtons.tag == sender.tag) {
                    
                    //if it is a learning stage, check if the answer is correct and change the image accordingly
                    [sender setBackgroundImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
                    curentQuestion.chosenAnswerID = [NSString stringWithFormat:@"%d", sender.tag];
                }else{
                    //esle unseelct the answer
                    [oneOfTheAnswerButtons setBackgroundImage:[UIImage imageNamed:@"uncheked.png"] forState:UIControlStateNormal];
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
                [chosenAnswerButton setBackgroundImage:[UIImage imageNamed:@"v.png"] forState:UIControlStateNormal];
            }
            else{
                [chosenAnswerButton setBackgroundImage:[UIImage imageNamed:@"x.png"] forState:UIControlStateNormal];
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

@end
