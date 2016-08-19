//
//  FBIntegrationManager.m
//  FacebookExploreDemo
//
//  Created by everettjf on 16/8/19.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FBIntegrationManager.h"

static void adjustFBInjectableDataAddressASLR(){
    
}

static NSArray<NSString*>* readConfigurationClassNames(){
    static NSArray<NSString*> *classNames;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adjustFBInjectableDataAddressASLR();
        
        classNames = [NSArray new];
        
        
        
    });
    
    return classNames;
}

@implementation FBIntegrationManager

+ (Class)classForProtocol:(id)protocol{
    
    return nil;
}

+ (NSArray<Class>*)classesForProtocol:(id)protocol{
    return [self classesForProtocol_internal:protocol];
}

+ (NSArray<Class>*)classesForProtocol_internal:(id)protocol{
    NSArray<Class> *classes = [NSArray new];
    
    return classes;
}
@end
