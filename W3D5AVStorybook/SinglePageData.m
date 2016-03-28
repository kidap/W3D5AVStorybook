//
//  SingePageData.m
//  W3D5AVStorybook
//
//  Created by Karlo Pagtakhan on 03/26/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

#import "SinglePageData.h"

@implementation SinglePageData

-(instancetype)initWithImageName:(NSString *)name{
  if(self = [super init]){
    _image = [UIImage imageNamed:name];
    _audioURL = [[NSURL alloc] init];
    _pageTitle = @"";
  }
  
  return self;
}

-(instancetype)init{
  return [self initWithImageName:@"1"];
}
@end
