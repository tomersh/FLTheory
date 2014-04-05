//
//  AnswerTableViewCell.h
//  Theory
//
//  Created by Luda Fux on 3/20/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionObject.h"
#import "AnswerObject.h"

@class AnswerTableViewCell;

@protocol AnswerTableViewCellDelegate <NSObject>

- (void)answerWasChosen:(AnswerTableViewCell*)answerCell;

@end


@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, weak) id<AnswerTableViewCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) IBOutlet UIImageView *answerToggle;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) QuestionObject *question;
@property (strong, nonatomic) AnswerObject *answer;
@property (nonatomic) NSInteger row;

+(CGFloat)answerCellHeight:(AnswerObject*)answer;

-(void)setupAnswerTableViewCell:(QuestionObject*)question
                         answer:(AnswerObject*)answer
                            row:(NSInteger)row
                         height:(CGFloat)height
                    setSelected:(BOOL)selected;

-(void)finishExam;
@end
