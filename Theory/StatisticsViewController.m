//
//  StatisticsViewController.m
//  Theory
//
//  Created by Luda Fux on 3/28/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "StatisticsViewController.h"
#import "ECSlidingViewController.h"
#import "FrameAccessor.h"
#import "JSONKit.h"
#import "StatisticManager.h"

@interface StatisticsViewController ()
@property (nonatomic, assign) CGFloat peekLeftAmount;
@end

@implementation StatisticsViewController
@synthesize peekLeftAmount;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.peekLeftAmount = 50.0f;
    
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
   
    
    CGFloat screenWidth = [self.view bounds].size.width - self.peekLeftAmount;
    
    //pie chart
    
    CGFloat pieChartHeight = self.numberOfNewQuestions.top - self.exersizeLabel.bottom;
    CGFloat pieChartWidth = screenWidth;
    
    self.pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake((screenWidth-pieChartWidth)/2,self.exersizeLabel.bottom,pieChartWidth,pieChartHeight)];
    [self.pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];
    [self.pieChart setDiameter:pieChartWidth/2];
    [self.pieChart setSameColorLabel:YES];
    [self.pieChart setShowArrow:NO];
    
    [self.view addSubview:self.pieChart];
    
    
    NSMutableArray *components = [NSMutableArray array];
    
    CGFloat correctOutOfAllForCategory = [[StatisticManager sharedManager]correctOutOfAllForCategory:self.category];
    
    
    PCPieComponent *correctComponent = [PCPieComponent pieComponentWithTitle:@"correct" value:correctOutOfAllForCategory];
    [correctComponent setColour:PCColorOrange];
    [components addObject:correctComponent];
    
    PCPieComponent *incorrectComponent = [PCPieComponent pieComponentWithTitle:@"incorrect" value:1-correctOutOfAllForCategory];
    [correctComponent setColour:PCColorOrange];
    [components addObject:incorrectComponent];
    
    [self.pieChart setComponents:components];

    
    //line chart
    
    CGFloat lineChartHeight = self.numberOfNewQuestions.top - self.exersizeLabel.bottom;
    CGFloat lineChartWidth = screenWidth;
    
    self.lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake((screenWidth-lineChartWidth)/2,self.simulationLabel.bottom,lineChartWidth,lineChartHeight)];
    [self.lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    self.lineChartView.minValue = -40;
    self.lineChartView.maxValue = 100;
    
//    [self.view addSubview:_lineChartView];
    
    
    NSString *sampleFile2 = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"sample_linechart_data.json"];
    
    NSString *jsonString = [NSString stringWithContentsOfFile:sampleFile2 encoding:NSUTF8StringEncoding error:nil];
    
    NSDictionary *sampleInfo2 = [jsonString objectFromJSONString];
    
    NSMutableArray *components2 = [NSMutableArray array];
    
    NSDictionary *point = [[sampleInfo2 objectForKey:@"data"] objectAtIndex:2];
    PCLineChartViewComponent *component2 = [[PCLineChartViewComponent alloc] init];
    [component2 setTitle:[point objectForKey:@"title"]];
    [component2 setPoints:[point objectForKey:@"data"]];
    [component2 setShouldLabelValues:NO];
    [component2 setColour:PCColorRed];
    [components2 addObject:component2];
    
    [self.lineChartView setComponents:components2];
    [self.lineChartView setXLabels:[sampleInfo2 objectForKey:@"x_labels"]];
    
}



@end
