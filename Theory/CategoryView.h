//
//  CategoryView.h
//  Theory
//
//  Created by Luda Fux on 3/16/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewDelegate <NSObject>

-(void)chosenCategoryWasPressed;

@end

@interface CategoryView : UICollectionViewCell

@property (nonatomic) Thoery_Category category;
@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (nonatomic, weak) id<CategoryViewDelegate> delegate;

-(void)initializationFunc;
-(void)setupCategoryView:(Thoery_Category)category
        isChosenCategory:(BOOL)isChosen;

@end
