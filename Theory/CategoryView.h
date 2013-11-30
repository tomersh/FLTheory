//
//  CategoryView.h
//  Theory
//
//  Created by Luda Fux on 11/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryView : UIView
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;

- (IBAction)categoryWasChosen:(id)sender;

@end
