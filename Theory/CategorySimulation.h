//
//  CategorySimulation.h
//  Theory
//
//  Created by Luda Fux on 4/11/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategorySimulation : NSObject

@property (assign,nonatomic) Thoery_Category category;
@property (assign,nonatomic) int totalNumQuestions;
@property (assign,nonatomic) int correctNumQuestions;
@property (assign,nonatomic) float correctPercent;

@end
