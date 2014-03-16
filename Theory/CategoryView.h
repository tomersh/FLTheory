//
//  CategoryView.h
//  Theory
//
//  Created by Luda Fux on 3/16/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Shared.h"

@interface CategoryView : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;


-(void)setupCategoryView:(Thoery_Category)category;

@end
