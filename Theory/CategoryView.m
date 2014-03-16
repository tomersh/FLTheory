//
//  CategoryView.m
//  Theory
//
//  Created by Luda Fux on 3/16/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView()
@property (strong, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *categoryImage;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;

@end
@implementation CategoryView


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if ((self)){
        self.frame = CGRectMake(0, 0, 75, 75);
        self.categoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 10)];
        self.categoryNameLabel.textColor = [UIColor whiteColor];
        self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
        self.categoryNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:11];
        
        self.categoryImage = [[UIImageView alloc]initWithFrame:CGRectMake(17.5, 15, 40, 40)];
//        self.categoryButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        
        [self addSubview:self.categoryNameLabel];
        [self addSubview:self.categoryImage];
        [self addSubview:self.categoryButton];
    }
    return self;
}
-(void)setupCategoryView:(Thoery_Category)category{
    NSString* title = nil;
    NSString* imageName = nil;
    switch (category) {
        case RODE_RULS_CATEGORY:
            title = @"חוקי הדרך";
            imageName = @"Menu_01_90x90px.png";
            break;
        case SIGHNS_CATEGORY:
            title = @"תמרורים";
            imageName = @"Menu_04_90x90px.png";
            break;
        case CAR_STRUCTURE_CATEGORY:
            title = @"מבנה הרכב";
            imageName = @"Menu_03_90x90px.png";
            break;
        case SECURITY_CATEGORY:
            title = @"אבטחה";
            imageName = @"Menu_02_90x90px.png";
            break;
        case MIXED_CATEGORY:
            title = @"סימולציה";
            imageName = @"Menu_05_90x90px.png";
            break;
        case UNKNOWEN_CATEGORY:
            title = @"לא ידוע";
            imageName = @"Menu_01_90x90px.png";
            break;
        default:
            break;
    }
    self.categoryNameLabel.text = title;
    self.categoryImage.image = [UIImage imageNamed:imageName];
}


@end
