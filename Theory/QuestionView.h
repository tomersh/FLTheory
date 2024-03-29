//
//  QuestionView.h
//  Theory
//
//  Created by Luda Fux on 5/24/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuestionViewDelegate <NSObject>

-(void)updateStatistics;

@end

@interface QuestionView : UIView<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *questionTextView;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *questionImage;
@property (strong, nonatomic) IBOutlet UITableView *answersTable;
@property (strong, nonatomic) QuestionObject* question;

@property (nonatomic, weak) id<QuestionViewDelegate> delegate;

-(void)setUpQuestionViewWithQuestion:(QuestionObject*)question;
-(void)finishExam;

@end
