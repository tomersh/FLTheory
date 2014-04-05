//
//  OverviewViewController.h
//  Theory
//
//  Created by Luda Fux on 8/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OverviewViewControllerDelegate;

// Definition of the delegate's interface
@protocol OverviewViewControllerDelegate <NSObject>

-(void)didChoseQuestion:(int)index;

@end


@interface OverviewViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) id<OverviewViewControllerDelegate> overviewDelegate;
@property (weak, nonatomic) IBOutlet UICollectionView *questionsOverviewCollection;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *didYouPassLabel;
-(void)finishExam;
@property (weak, nonatomic) IBOutlet UILabel *numberOfWrongAnswersLabel;

@end


