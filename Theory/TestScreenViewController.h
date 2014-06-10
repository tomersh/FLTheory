//
//  TestScreenViewController.h
//  Theory
//
//  Created by Luda Fux on 8/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "OverviewViewController.h"
#import "CategoryView.h"
#import "QuestionView.h"

@interface TestScreenViewController : UIViewController<iCarouselDataSource, iCarouselDelegate,OverviewViewControllerDelegate,QuestionViewDelegate,UIAlertViewDelegate>{
    BOOL isCategoryViewDown;
}


@property (weak, nonatomic) IBOutlet UILabel *outOfQuestionsSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (weak) NSTimer *repeatingTimer;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissCategoriesButton;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoButton;
@property (weak, nonatomic) IBOutlet UIButton *leftArrow;
@property (weak, nonatomic) IBOutlet UIButton *rightArrow;
@property (nonatomic) BOOL isCategoryViewDown;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
@property (nonatomic) NSTimeInterval remainingTime;

- (IBAction)didPressDismissCategoriesButton:(id)sender;
- (void)instantiateSlidingVcWithCategory:(Thoery_Category)category;
- (void)adjustQuestionNumberLabels;
- (IBAction)revealUnderRight:(id)sender;
- (IBAction)nextQuestionButton:(id)sender;
- (IBAction)previuesQuestionButton:(id)sender;
- (void)startRepeatingTimer;
- (void)reloadCarouselWithNewCategory:(NSNumber*)categoryNumber;
- (void)categoryWasUpdated:(Thoery_Category)chosenCategory;
- (void)openCloseMenu;
@end
