//
//  CategoryView.m
//  Theory
//
//  Created by Luda Fux on 3/16/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "CategoryView.h"

@interface CategoryView()

@property (strong, nonatomic) IBOutlet UIButton *categoryButton;

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
    self.frame = CGRectMake(0, 0, 75, 72);
    self.categoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 16)];
    self.categoryNameLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12];
    
    self.categoryImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 45, 45)];
    
    [self addSubview:self.categoryNameLabel];
    [self addSubview:self.categoryImage];
}

-(void)setupCategoryView:(Thoery_Category)category
        isChosenCategory:(BOOL)isChosen{
    NSString* title = nil;
    NSString* imageName = nil;
    UIColor* textColor = [Shared colorForCategory:category];
    
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
            break;
        default:
            break;
    }
    self.categoryNameLabel.text = title;
    self.categoryImage.image = [UIImage imageNamed:imageName];
    self.categoryNameLabel.textColor = textColor;
    self.category = category;
    
    if (isChosen) {
        self.categoryButton = [[UIButton alloc]initWithFrame:self.frame];
        [self.categoryButton addTarget:self
                                action:@selector(didPressChosenCategory:)
                      forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.categoryButton];
    }else if(self.categoryButton){
        [self.categoryButton removeFromSuperview];
    }
}

- (IBAction)didPressChosenCategory:(id)sender{
    [self.delegate didPressChosenCategory];
}

@end
