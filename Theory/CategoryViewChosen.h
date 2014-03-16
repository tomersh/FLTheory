//
//  CategoryViewChosen.h
//  Theory
//
//  Created by Luda Fux on 3/15/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "CategoryView.h"

@protocol CategoryViewChosenDelegate <NSObject>

-(void)chosenCategoryWasPressed;

@end



@interface CategoryViewChosen : CategoryView
@property (nonatomic, weak) id<CategoryViewChosenDelegate> delegate;
@end
