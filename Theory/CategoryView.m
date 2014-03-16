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


@end

@implementation CategoryView


-(id)init{
    self = [super init];
    if ((self)){
        [self initializationFunc];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if ((self)){
        [self initializationFunc];
    }
    return self;
}

-(void)initializationFunc{
    self.frame = CGRectMake(0, 0, 75, 62);
    self.categoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 13)];
    self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    
    self.categoryImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 45, 45)];
    
    [self addSubview:self.categoryNameLabel];
    [self addSubview:self.categoryImage];
}

-(void)setupCategoryView:(Thoery_Category)category{
    NSString* title = nil;
    NSString* imageName = nil;
    UIColor* textColor = nil;
    switch (category) {
        case RODE_RULS_CATEGORY:
            title = @"חוקי הדרך";
            imageName = @"Menu_01_90x90px.png";
            textColor = [UIColor colorWithRed:79.0f/255.0f green:201.0f/255.0f blue:179.0f/255.0f alpha:1.0f];
            break;
        case SIGHNS_CATEGORY:
            title = @"תמרורים";
            imageName = @"Menu_04_90x90px.png";
            textColor = [UIColor colorWithRed:94.0f/255.0f green:222.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
            break;
        case CAR_STRUCTURE_CATEGORY:
            title = @"מבנה הרכב";
            imageName = @"Menu_03_90x90px.png";
            textColor = [UIColor colorWithRed:197.0f/255.0f green:50.0f/255.0f blue:172.0f/255.0f alpha:1.0f];
            break;
        case SECURITY_CATEGORY:
            title = @"אבטחה";
            imageName = @"Menu_02_90x90px.png";
            textColor = [UIColor colorWithRed:146.0f/255.0f green:202.0f/255.0f blue:24.0f/255.0f alpha:1.0f];
            break;
        case MIXED_CATEGORY:
            title = @"סימולציה";
            imageName = @"Menu_05_90x90px.png";
            textColor = [UIColor colorWithRed:213.0f/255.0f green:101.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
            break;
        case UNKNOWEN_CATEGORY:
            break;
        default:
            break;
    }
    self.categoryNameLabel.text = title;
    self.categoryImage.image = [UIImage imageNamed:imageName];
    self.categoryNameLabel.textColor = textColor;
    self.category = category;
}


@end
