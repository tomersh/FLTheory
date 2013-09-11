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


@end
