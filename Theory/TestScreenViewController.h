//
//  TestScreenViewController.h
//  Theory
//
//  Created by Luda Fux on 8/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "Shared.h"
#import "OverviewViewController.h"
#import "CategoryView.h"
@interface TestScreenViewController : UIViewController<iCarouselDataSource, iCarouselDelegate,OverviewViewControllerDelegate>{
    BOOL isCategoryViewDown;
}

- (IBAction)revealUnderRight:(id)sender;
- (IBAction)nextQuestionButton:(id)sender;
- (IBAction)previuesQuestionButton:(id)sender;



@property (weak) NSTimer *repeatingTimer;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;    



@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property (weak, nonatomic) IBOutlet CategoryView *RODE_RULS_CategoryView;
@property (weak, nonatomic) IBOutlet CategoryView *CAR_STRUCTURE_CategoryView;
@property (weak, nonatomic) IBOutlet CategoryView *SIGHNS_CATEGORY_CategoryView;
@property (weak, nonatomic) IBOutlet CategoryView *SECURITY_CATEGORY_CategoryView;
@property (weak, nonatomic) IBOutlet CategoryView *MIXED_CATEGORY_CategoryView;
- (IBAction)didPressChosenCategory:(id)sender;



@property NSTimeInterval remainingTime;
- (void)startRepeatingTimer;


@property (nonatomic, strong) IBOutlet iCarousel *carousel;
-(void)reloadCarouselWithNewCategory:(Thoery_Category)category;
@end
