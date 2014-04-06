//
//  OverviewCell.h
//  Theory
//
//  Created by Luda Fux on 3/22/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OverviewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *answerToggle;
@property (strong, nonatomic) QuestionObject *question;

-(void)setupCell:(QuestionObject*)question
             row:(NSInteger)row;
-(void)finishExam;
@end
