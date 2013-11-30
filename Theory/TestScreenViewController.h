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

@interface TestScreenViewController : UIViewController<iCarouselDataSource, iCarouselDelegate,OverviewViewControllerDelegate>
//- (IBAction)revealMenu:(id)sender;
- (IBAction)revealUnderRight:(id)sender;
- (IBAction)nextQuestionButton:(id)sender;
- (IBAction)previuesQuestionButton:(id)sender;

@property (weak) NSTimer *repeatingTimer;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;    
    
@property (weak, nonatomic) IBOutlet UIView *navigationBar;
@property NSTimeInterval remainingTime;
@property (nonatomic, strong) IBOutlet iCarousel *carousel;
-(void)reloadCarouselWithNewCategory:(Thoery_Category)category;
- (void)startRepeatingTimer;
@end
