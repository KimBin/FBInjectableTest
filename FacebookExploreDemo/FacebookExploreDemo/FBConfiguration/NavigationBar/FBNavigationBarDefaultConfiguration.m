//
//  FBNavigationBarDefaultConfiguration.m
//  FacebookExploreDemo
//
//  Created by everettjf on 16/8/19.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FBNavigationBarDefaultConfiguration.h"


@implementation FBNavigationBarDefaultConfiguration

+ (void)fb_injectable{
    return;
}

+ (NSUInteger)integrationPriority{
    return 0;
}

+ (BOOL)shouldShowBackButton{
    return YES;
}

@end
