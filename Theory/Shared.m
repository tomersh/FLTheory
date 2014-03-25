//
//  Shared.m
//  Theory
//
//  Created by Luda Fux on 7/10/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "Shared.h"

@implementation Shared


+(NSString*)nameOfCategory:(Thoery_Category)category{
    switch (category) {
        case RODE_RULS_CATEGORY:
            return @"חוקי הדרך";
            break;
        case SIGHNS_CATEGORY:
            return @"תמרורים";
            break;
        case CAR_STRUCTURE_CATEGORY:
            return @"מבנה הרכב";
            break;
        case SECURITY_CATEGORY:
            return @"אבטחה";
            break;
        case MIXED_CATEGORY:
            return @"סימולציה";
            break;
        case UNKNOWEN_CATEGORY:
            return @"לא ידוע";
            break;
        default:
            break;
    }
}

+(Thoery_Category)categoryForName:(NSString*)categoryName{
    if ([categoryName isEqualToString:@"חוקי הדרך"]) {
        return RODE_RULS_CATEGORY;
    }else if ([categoryName isEqualToString:@"תמרורים"]) {
        return SIGHNS_CATEGORY;
    }else if ([categoryName isEqualToString:@"מבנה הרכב"]) {
        return CAR_STRUCTURE_CATEGORY;
    }else if ([categoryName isEqualToString:@"אבטחה"]) {
        return SECURITY_CATEGORY;
    }else if ([categoryName isEqualToString:@"סימולציה"]) {
        return MIXED_CATEGORY;
    }else {
        return UNKNOWEN_CATEGORY;
    }
}

+(UIColor*)colorForCategory:(Thoery_Category)category{
    UIColor* color = nil;
    switch (category) {
        case RODE_RULS_CATEGORY:
            color = [UIColor colorWithRed:79.0f/255.0f green:201.0f/255.0f blue:179.0f/255.0f alpha:1.0f];
            break;
        case SIGHNS_CATEGORY:
            color = [UIColor colorWithRed:94.0f/255.0f green:222.0f/255.0f blue:86.0f/255.0f alpha:1.0f];
            break;
        case CAR_STRUCTURE_CATEGORY:
            color = [UIColor colorWithRed:197.0f/255.0f green:50.0f/255.0f blue:172.0f/255.0f alpha:1.0f];
            break;
        case SECURITY_CATEGORY:
            color = [UIColor colorWithRed:146.0f/255.0f green:202.0f/255.0f blue:24.0f/255.0f alpha:1.0f];
            break;
        case MIXED_CATEGORY:
            color = [UIColor colorWithRed:213.0f/255.0f green:101.0f/255.0f blue:34.0f/255.0f alpha:1.0f];
            break;
        case UNKNOWEN_CATEGORY:
            break;
        default:
            break;
    }
    
    return color;
}

+(UIImage*)leftArrowForCategory:(Thoery_Category)category{
    UIImage* leftImage = nil;
    switch (category) {
        case RODE_RULS_CATEGORY:
            leftImage = [UIImage imageNamed:@"Left_arrow_67x67px1.png"];
            break;
        case SIGHNS_CATEGORY:
            leftImage = [UIImage imageNamed:@"Left_arrow_67x67px2.png"];
            break;
        case CAR_STRUCTURE_CATEGORY:
            leftImage = [UIImage imageNamed:@"Left_arrow_67x67px3.png"];
            break;
        case SECURITY_CATEGORY:
            leftImage = [UIImage imageNamed:@"Left_arrow_67x67px4.png"];
            break;
        case MIXED_CATEGORY:
            leftImage = [UIImage imageNamed:@"Left_arrow_67x67px5.png"];
            break;
        case UNKNOWEN_CATEGORY:
            leftImage = [UIImage imageNamed:@"Left_arrow_67x67px1.png"];
            break;
        default:
            break;
    }
    
    return leftImage;
}

+(UIImage*)rightArrowForCategory:(Thoery_Category)category{
    UIImage* rightImage = nil;
    switch (category) {
        case RODE_RULS_CATEGORY:
            rightImage = [UIImage imageNamed:@"Right_arrow_67x67px1.png"];
            break;
        case SIGHNS_CATEGORY:
            rightImage = [UIImage imageNamed:@"Right_arrow_67x67px2.png"];
            break;
        case CAR_STRUCTURE_CATEGORY:
            rightImage = [UIImage imageNamed:@"Right_arrow_67x67px3.png"];
            break;
        case SECURITY_CATEGORY:
            rightImage = [UIImage imageNamed:@"Right_arrow_67x67px4.png"];
            break;
        case MIXED_CATEGORY:
            rightImage = [UIImage imageNamed:@"Right_arrow_67x67px5.png"];
            break;
        case UNKNOWEN_CATEGORY:
            rightImage = [UIImage imageNamed:@"Right_arrow_67x67px1.png"];
            break;
        default:
            break;
    }
    
    return rightImage;
}

-(BOOL)is4inch{
    if ([UIScreen mainScreen].bounds.size.height<568)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

@end
