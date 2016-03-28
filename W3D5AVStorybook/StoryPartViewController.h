//
//  StoryPartViewController.h
//  W3D5AVStorybook
//
//  Created by Karlo Pagtakhan on 03/26/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SinglePageData;

@interface StoryPartViewController : UIViewController
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) SinglePageData *dataObject;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationItem;

@end
