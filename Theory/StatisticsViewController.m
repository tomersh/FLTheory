//
//  StatisticsViewController.m
//  Theory
//
//  Created by Luda Fux on 3/28/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "StatisticsViewController.h"
#import "ECSlidingViewController.h"
#import "JSONKit.h"
#import "DatabaseManager.h"

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
}


-(void)updateVCWithCategory:(NSNumber*) categoryNSNumber{
 
    Thoery_Category category = [categoryNSNumber integerValue];
    self.titleLabel.text = [NSString stringWithFormat:@"איך אני ב%@",[Shared nameOfCategory:category]];
    self.numberOfNewQuestions.text = [NSString stringWithFormat:@"עדיין לא ראית %d שאלות",[[DatabaseManager shared]getNumOfNewQuestions:category]];
    self.numberOfNewQuestions.textColor = [UIColor grayColor];
    
    //pie chart
    
    if (self.pieChart) {
        [self.pieChart removeFromSuperview];
        self.pieChart = nil;

    }
    
    CGFloat screenWidth = self.view.bounds.size.width - self.peekLeftAmount;
    CGFloat pieChartHeight = self.numberOfNewQuestions.top - self.exersizeLabel.bottom;
    CGFloat pieChartWidth = screenWidth;

    self.pieChart = [[PCPieChart alloc] initWithFrame:CGRectMake((screenWidth-pieChartWidth)/2,self.exersizeLabel.bottom,pieChartWidth,pieChartHeight)];
    self.pieChart.right = self.exersizeLabel.right;
    [self.pieChart setDiameter:pieChartWidth/2];

    [self.pieChart setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin];

    [self.pieChart setSameColorLabel:YES];
    [self.pieChart setShowArrow:NO];
    
    [self.view addSubview:self.pieChart];
    
    
    NSMutableArray *components = [NSMutableArray array];
    
    int correctOutOfAllForCategory = [[DatabaseManager shared]getNumOfQuestions:category isCorrect:YES];
    int incorrectOutOfAllForCategory = [[DatabaseManager shared]getNumOfQuestions:category isCorrect:NO];
    
    if (correctOutOfAllForCategory + incorrectOutOfAllForCategory == 0) {
        
        PCPieComponent *correctComponent = [PCPieComponent pieComponentWithTitle:@"לא ענית עוד על כלום" value:1];
        [correctComponent setColour:PCColorDefault];
        [components addObject:correctComponent];
   
    }else{
        
        PCPieComponent *correctComponent = [PCPieComponent pieComponentWithTitle:@"תשובות נכונות" value:correctOutOfAllForCategory];
        [correctComponent setColour:PCColorGreen];//[Shared colorForCategory:category]];
        [components addObject:correctComponent];
        
        PCPieComponent *incorrectComponent = [PCPieComponent pieComponentWithTitle:@"תשובות לא נכונות" value:incorrectOutOfAllForCategory];
        [incorrectComponent setColour:PCColorRed];
        [components addObject:incorrectComponent];
    }
    
    [self.pieChart setComponents:components];

    
    //line chart
    
    if (self.lineChartView) {
        [self.lineChartView removeFromSuperview];
        self.lineChartView = nil;
        
    }

    CGFloat lineChartHeight = self.numberOfNewQuestions.top - self.exersizeLabel.bottom;
    CGFloat lineChartWidth = screenWidth;
    
    self.lineChartView = [[PCLineChartView alloc] initWithFrame:CGRectMake((screenWidth-lineChartWidth)/2 + 35,self.simulationLabel.bottom + 10,lineChartWidth,lineChartHeight)];
    [self.lineChartView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    self.lineChartView.minValue = 0;
    self.lineChartView.maxValue = 100;
    self.lineChartView.x_axis_Label = @"סימולציה";
    self.lineChartView.y_axis_Label = @"אחוז תשובות נכונות";
    [self.view addSubview:_lineChartView];
    
    //line chart
    NSMutableDictionary *simulationsDataForCategory = [[DatabaseManager shared]simulationsDataForCategory:category];

    NSArray * data = [simulationsDataForCategory objectForKey:@"data"];
    NSMutableArray * x_labels = [simulationsDataForCategory objectForKey:@"axis"];

    NSMutableArray *components2 = [NSMutableArray array];
    
    PCLineChartViewComponent *component2 = [[PCLineChartViewComponent alloc] init];
    [component2 setPoints:data];
    [component2 setShouldLabelValues:NO];
    [component2 setColour:PCColorBlue];
    [components2 addObject:component2];
    
    [self.lineChartView setComponents:components2];
    [self.lineChartView setXLabels:x_labels];
}


@end
