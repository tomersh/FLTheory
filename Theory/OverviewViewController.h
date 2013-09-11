//
//  OverviewViewController.h
//  Theory
//
//  Created by Luda Fux on 8/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OverviewViewControllerDelegate;

@interface OverviewViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak) id<OverviewViewControllerDelegate> overviewDelegate;
@property (weak, nonatomic) IBOutlet UICollectionView *questionsOverviewCollection;

@end


// Definition of the delegate's interface
@protocol OverviewViewControllerDelegate <NSObject>

-(void)didChoseQuestion:(int)index;

@end
