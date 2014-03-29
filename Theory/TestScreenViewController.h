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
#import "CategoryViewChosen.h"
#import "QuestionView.h"

@interface TestScreenViewController : UIViewController<iCarouselDataSource, iCarouselDelegate,OverviewViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,CategoryViewChosenDelegate,QuestionViewDelegate>{
    BOOL isCategoryViewDown;
}

- (IBAction)revealUnderRight:(id)sender;
- (IBAction)nextQuestionButton:(id)sender;
- (IBAction)previuesQuestionButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *outOfQuestionsSumLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;
@property (weak, nonatomic) IBOutlet CategoryViewChosen *chosenCategoryView;
@property (weak) NSTimer *repeatingTimer;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;    
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *dismissCategoriesButton;
- (IBAction)didPressDismissCategoriesButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoButton;

@property (weak, nonatomic) IBOutlet UIButton *leftArrow;
@property (weak, nonatomic) IBOutlet UIButton *rightArrow;

@property (weak, nonatomic) IBOutlet UIView *navigationBar;
- (IBAction)didPressChosenCategory:(id)sender;



@property NSTimeInterval remainingTime;
- (void)startRepeatingTimer;


@property (nonatomic, strong) IBOutlet iCarousel *carousel;
-(void)reloadCarouselWithNewCategory:(Thoery_Category)category;
@end
