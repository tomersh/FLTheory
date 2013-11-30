//
//  CategoryView.m
//  Theory
//
//  Created by Luda Fux on 11/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib{

}
-(void)updateCategoryViewWithReleventData:(Thoery_Category)category{
    switch (category) {
        case RODE_RULS_CATEGORY:
            self.categoryNameLabel.text = @"חוקי הדרך";
//            self.categoryImage.image = [UIImage alloc] initWithCGImage:<#(CGImageRef)#>
            NSLog (@"%@",[NSString stringWithFormat:@"%@",self.categoryNameLabel.text]);
            break;
        case SIGHNS_CATEGORY:
            self.categoryNameLabel.text = @"תמרורים";
            break;
        case CAR_STRUCTURE_CATEGORY:
            self.categoryNameLabel.text = @"מבנה הרכב";
            break;
        case SECURITY_CATEGORY:
            self.categoryNameLabel.text = @"אבטחה";
            break;
        case MIXED_CATEGORY:
            self.categoryNameLabel.text = @"סימולציה";
            break;
        case UNKNOWEN_CATEGORY:
            self.categoryNameLabel.text = @"לא ידוע";
            break;
        default:
            break;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)categoryWasChosen:(id)sender {
}
@end
