//
//  PageViewController.m
//  W3D5AVStorybook
//
//  Created by Karlo Pagtakhan on 03/26/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

#import "PageViewController.h"
#import "StoryPartViewController.h"
#import "SinglePageData.h"


@interface PageViewController()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (nonatomic, strong) NSMutableArray<SinglePageData *> *dataArray;
@property (nonatomic, assign) NSInteger currentIndex;
@end
@implementation PageViewController

-(void)viewDidLoad{
  self.delegate = self;
  self.dataSource = self;
  
  [self createData];
}
//MARK: Preparation
-(void) createData{
  self.dataArray = [[NSMutableArray alloc] init];
  
  //Build data array
  [self addDataObjectToArray];
  [self addDataObjectToArray];
  [self addDataObjectToArray];
  [self addDataObjectToArray];
  [self addDataObjectToArray];
  
  //Create view controller
  StoryPartViewController *initialVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPartViewController"];
  //initialVC.index = 1;
  initialVC.dataObject = self.dataArray[0];
  self.currentIndex = 0;
  
  //Add view controller to the page view controller
  [self setViewControllers:@[initialVC] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}

//MARK: Page View Controller delegates and dataSource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(StoryPartViewController *)viewController{
  StoryPartViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPartViewController"];
  
  SinglePageData *dataObject = [self getPreviousDataObjectFromIndex];
  if (dataObject){
    vc.dataObject = dataObject;
    return vc;
  }
  
  return nil;
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(StoryPartViewController *)viewController
{
  
  StoryPartViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"StoryPartViewController"];
  
  SinglePageData *dataObject = [self getNextDataObjectFromIndex];
  if (dataObject){
    vc.dataObject = dataObject;
    return vc;
  }
  
  return nil;
}
-(SinglePageData *)getPreviousDataObjectFromIndex{
  if (self.currentIndex >= 1){
    self.currentIndex--;
    return self.dataArray[self.currentIndex];
  }
  return nil;
}

-(SinglePageData *)getNextDataObjectFromIndex{
  if (self.currentIndex < self.dataArray.count - 1){
    self.currentIndex++;
    return self.dataArray[self.currentIndex];
  }
  return nil;
}

//MARK: Helper methods
-(void)addDataObjectToArray{
//  SinglePageData *dataObject = [[SinglePageData alloc] initWithImageName:[@(self.dataArray.count + 1) stringValue]];
  SinglePageData *dataObject = [[SinglePageData alloc] initWithImageName:@"noImage"];
  dataObject.pageTitle = [NSString stringWithFormat:@"Page %lu", self.dataArray.count + 1];
  [self.dataArray addObject:dataObject];
}
@end
