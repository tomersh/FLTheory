//
//  StatisticsViewController.h
//  Theory
//
//  Created by Luda Fux on 3/28/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCPieChart.h"
#import "PCLineChartView.h"

@interface StatisticsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *exersizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfNewQuestions;
@property (weak, nonatomic) IBOutlet UILabel *simulationLabel;
@property (nonatomic, strong) PCLineChartView *lineChartView;
@property (nonatomic, strong) PCPieChart *pieChart;

-(void)updateVCWithCategory:(Thoery_Category) category;

@end
