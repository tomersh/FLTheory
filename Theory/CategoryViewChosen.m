//
//  CategoryViewChosen.m
//  Theory
//
//  Created by Luda Fux on 3/15/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "CategoryViewChosen.h"

@implementation CategoryViewChosen


-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if ((self)){
        self.categoryButton = [[UIButton alloc]initWithFrame:self.frame];
        [self.categoryButton addTarget:self
                                action:@selector(chosenCategoryWasPressed:)
                      forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.categoryButton];
    }
    return self;
}

- (IBAction)chosenCategoryWasPressed:(id)sender{
    [self.delegate chosenCategoryWasPressed];
}

@end
