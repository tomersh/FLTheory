//
//  CategoriesContainerViewController.h
//  Theory
//
//  Created by Luda Fux on 6/9/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryView.h"
@protocol CategoriesContainerViewControllerDelegate;

@interface CategoriesContainerViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,CategoryViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollectionView;
@property (weak, nonatomic) IBOutlet CategoryView *chosenCategoryView;
@property (nonatomic,assign) id <CategoriesContainerViewControllerDelegate> delegate;

@end


@protocol CategoriesContainerViewControllerDelegate



@end
