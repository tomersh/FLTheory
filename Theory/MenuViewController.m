//
//  MenuViewController.m
//  Theory
//
//  Created by Luda Fux on 8/30/13.
//  Copyright (c) 2013 Luda Fux. All rights reserved.
//

#import "MenuViewController.h"
#import "TestScreenViewController.h"
#import "Shared.h"
#import "ExamManager.h"
@interface MenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController
@synthesize menuItems;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuItems = [NSArray arrayWithObjects: [Shared nameOfCategory:RODE_RULS_CATEGORY],
                                                [Shared nameOfCategory:SIGHNS_CATEGORY],
                                                [Shared nameOfCategory:CAR_STRUCTURE_CATEGORY],
                                                [Shared nameOfCategory:SECURITY_CATEGORY],
                                                [Shared nameOfCategory:MIXED_CATEGORY],nil];
    [self.slidingViewController setAnchorRightRevealAmount:150.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TestScreenViewController *updatedTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TestScreen"];
    updatedTopViewController.timerLabel.hidden = YES;
    
    NSString* categoryString = [self.menuItems objectAtIndex:indexPath.row];
    Thoery_Category category = [Shared categoryForName:categoryString];
    [updatedTopViewController reloadCarouselWithNewCategory:category];
    

    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = updatedTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
        if ([ExamManager sharedManager].exam.examType == SIMULATION_EXAM_TYPE) {
            [updatedTopViewController startRepeatingTimer];
            //timer label will be unhidden when setting of the timer will be done
        }else{
            updatedTopViewController.timerLabel.text = categoryString;
            updatedTopViewController.timerLabel.hidden = NO;
        }

    }];
}

@end
