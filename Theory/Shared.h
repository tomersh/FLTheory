//
//  Shared.h
//  Theory
//
//  Created by Luda Fux on 7/10/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Shared : NSObject

typedef enum{
    kPractice,
    kSimulation,
    kMarathon
}ExamType;

//typedef enum{
//    kSigns,
//    kTrafficLaws,
//    kVehicleStructure,
//    kSafety
//}CategoryType;

typedef enum
{
    RODE_RULS_CATEGORY = 0,
    SIGHNS_CATEGORY,
    CAR_STRUCTURE_CATEGORY,
    SECURITY_CATEGORY,
    MIXED_CATEGORY,
    UNKNOWEN_CATEGORY
} Thoery_Category;

typedef enum
{
    SIMULATION_EXAM_TYPE = 0,
    LEARNING_EXAM_TYPE
} EXAM_TYPE;

+(NSString*)nameOfCategory:(Thoery_Category)category;
+(Thoery_Category)categoryForName:(NSString*)categoryName;
@end
