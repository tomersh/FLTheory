//
//  CategoriesContainerViewController.m
//  Theory
//
//  Created by Luda Fux on 6/9/14.
//  Copyright (c) 2014 Luda Fux. All rights reserved.
//

#import "CategoriesContainerViewController.h"
#import "TestScreenViewController.h"
#import "CategoryView.h"

@interface CategoriesContainerViewController ()

@property (nonatomic, strong) NSMutableArray *menuItems;
@property (nonatomic, strong) TestScreenViewController *parentViewController;

@end

@implementation CategoriesContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.menuItems = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:SECURITY_CATEGORY],[NSNumber numberWithInt:SIGHNS_CATEGORY],[NSNumber numberWithInt:CAR_STRUCTURE_CATEGORY],[NSNumber numberWithInt:MIXED_CATEGORY],[NSNumber numberWithInt:RODE_RULS_CATEGORY],nil];
    
    Thoery_Category category = [self.menuItems[[self.menuItems count]-1] intValue];
    
    [self.chosenCategoryView setupCategoryView:category isChosenCategory:YES];
    self.chosenCategoryView.delegate = self;
    self.chosenCategoryView.categoryNameLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    
    self.parentViewController = ((TestScreenViewController*)self.parentViewController);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)didPressChosenCategory{
    [UIView animateWithDuration:0.5
                          delay:0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.top = 90;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    self.parentViewController.dismissCategoriesButton.hidden = NO;
    
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.menuItems count]-1;
}

- (CategoryView *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CategoryView *cell = [cv dequeueReusableCellWithReuseIdentifier:@"CategoryViewCollectionCell" forIndexPath:indexPath];
    
    Thoery_Category category = [self.menuItems[indexPath.row] intValue];
    [cell setupCategoryView:category isChosenCategory:NO];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Thoery_Category chosenCategory = [self.menuItems[indexPath.row] intValue];
    
    [self.parentViewController categoryWasUpdated];
    
    Thoery_Category oldCategory = self.chosenCategoryView.category;
        
    //handle catogories
    [self.menuItems replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:oldCategory]];
    [self.menuItems replaceObjectAtIndex:([self.menuItems count]-1) withObject:[NSNumber numberWithInt:chosenCategory]];
    
    [self.chosenCategoryView setupCategoryView:chosenCategory isChosenCategory:YES];
    
    //animations
    CategoryView *datasetCell =(CategoryView*)[collectionView cellForItemAtIndexPath:indexPath];
    [self performCategoryIsChosenTransition:datasetCell];
}

-(void)performCategoryIsChosenTransition:(CategoryView *)datasetCell{

    self.chosenCategoryView.hidden = YES;
    
    [UIView animateWithDuration:0.6
                          delay:0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.top = 0;
                         
                         [UIView animateWithDuration:0.1
                                               delay:0
                                             options: UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionOverrideInheritedDuration
                                          animations:^{
                                              datasetCell.categoryImage.bounds = CGRectMake(0, 0, 50, 50);
                                          }
                                          completion:^(BOOL finished){
                                              self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 15, 15);
                                              self.chosenCategoryView.categoryNameLabel.alpha = 0.0f;
                                              self.chosenCategoryView.hidden = NO;
                                              
                                              [UIView animateWithDuration:0.5
                                                                    delay:0
                                                                  options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                                               animations:^{
                                                                   [UIView animateWithDuration:0.3
                                                                                         delay:0
                                                                                       options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                                                                    animations:^{
                                                                                        datasetCell.categoryImage.bounds = CGRectMake(0, 0, 5, 5);
                                                                                        datasetCell.categoryNameLabel.alpha = 0.0f;
                                                                                    }
                                                                                    completion:^(BOOL finished){
                                                                                        datasetCell.hidden = YES;
                                                                                        datasetCell.categoryImage.bounds = CGRectMake(0, 0, 45, 45);
                                                                                        datasetCell.categoryNameLabel.alpha = 1.0f;
                                                                                        datasetCell.alpha = 0.0f;
                                                                                        
                                                                                    }];
                                                                   
                                                                   self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 50, 50);
                                                                   self.chosenCategoryView.categoryNameLabel.alpha = 1.0f;
                                                               }
                                                               completion:^(BOOL finished){
                                                                   
                                                                   
                                                                   
                                                                   [UIView animateWithDuration:0.3
                                                                                         delay:0
                                                                                       options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                                                                    animations:^{
                                                                                        self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 45, 45);
                                                                                    }
                                                                                    completion:^(BOOL finished){
                                                                                        
                                                                                        datasetCell.hidden = NO;
                                                                                        
                                                                                        [UIView animateWithDuration:1
                                                                                                              delay:0
                                                                                                            options: UIViewAnimationOptionCurveEaseOut| UIViewAnimationOptionOverrideInheritedDuration
                                                                                                         animations:^{
                                                                                                             self.chosenCategoryView.categoryImage.bounds = CGRectMake(0, 0, 45, 45);
                                                                                                         }
                                                                                                         completion:^(BOOL finished){
                                                                                                             
                                                                                                             [self.categoriesCollectionView reloadData];
                                                                                                             datasetCell.alpha = 1.0f;
                                                                                                         }];
                                                                                        
                                                                                    }];
                                                                   
                                                               }];
                                          }];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
@end
