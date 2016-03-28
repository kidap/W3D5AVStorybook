//
//  SingePageData.h
//  W3D5AVStorybook
//
//  Created by Karlo Pagtakhan on 03/26/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePageData : NSObject
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSURL *audioURL;

-(instancetype)initWithImageName:(NSString *)name;
@end
