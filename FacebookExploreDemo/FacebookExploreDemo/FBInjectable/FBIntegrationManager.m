//
//  FBIntegrationManager.m
//  FacebookExploreDemo
//
//  Created by everettjf on 16/8/19.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import "FBIntegrationManager.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <dlfcn.h>

#define InjectableSectionName "FBInjectable"

static void adjustFBInjectableDataAddressASLR(){
    Dl_info info;
    dladdr(adjustFBInjectableDataAddressASLR, &info);
    
#ifndef __LP64__
    const struct mach_header *mhp = _dyld_get_image_header(0);
    const struct section * sec = getsectbyname("__DATA", InjectableSectionName);
    const char * memory = (const char *)( sec->offset + (uint32_t)mhp);
    unsigned long size = 0;
    getsectiondata(mhp, "__DATA", InjectableSectionName, & size);
    
//    NSData *d = [NSData dataWithBytes:(const void *)memory length:72];
//    NSString *text = [NSString stringWithFormat:@"%@", d];
//    NSLog(@"memory text = %@", text);
    
    uint32_t *memory32 = (uint32_t*)memory;
    for(int idx = 0; idx < size/sizeof(void*); ++idx){
        memory32[idx] += (uint32_t)mhp;
    }
    
//    d = [NSData dataWithBytes:(const void *)memory length:72];
//    text = [NSString stringWithFormat:@"%@", d];
//    NSLog(@"memory text modified = %@", text);
    
#else /* defined(__LP64__) */
    
    const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
    const struct section_64 * sec = getsectbyname("__DATA", InjectableSectionName);
    const char * memory = (const char *)( sec->offset + (uint64_t)mhp);
    unsigned long size = 0;
    getsectiondata(mhp, "__DATA", InjectableSectionName, & size);
    
    NSData *d;
    NSString *text;
    d = [NSData dataWithBytes:(const void *)memory length:size];
    text = [NSString stringWithFormat:@"%@", d];
    NSLog(@"memory text before = %@", text);
    
    
    uint64_t *memory64 = (uint64_t*)memory;
    for(int idx = 0; idx < size/sizeof(void*); ++idx){
        memory64[idx] += (uint64_t)mhp;
    }
    
    
    d = [NSData dataWithBytes:(const void *)memory length:size];
    text = [NSString stringWithFormat:@"%@", d];
    NSLog(@"memory text modified = %@", text);
    
#endif /* defined(__LP64__) */
    
}

static NSArray<NSString*>* readConfigurationClassNames(){
    static NSArray<NSString*> *classNames;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        adjustFBInjectableDataAddressASLR();
        
        classNames = [NSArray new];
        
        Dl_info info;
        dladdr(adjustFBInjectableDataAddressASLR, &info);
#ifndef __LP64__
        const struct mach_header *mhp = _dyld_get_image_header(0);
        unsigned long size = 0;
        uint8_t *memory = getsectiondata(mhp, "__DATA", InjectableSectionName, & size);
        
#else /* defined(__LP64__) */
        const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
        unsigned long size = 0;
        uint64_t *memory = (uint64_t*)getsectiondata(mhp, "__DATA", InjectableSectionName, & size);
        
        for(int idx = 0; idx < size/sizeof(void*); ++idx){
            uint64_t address = memory[idx];
            char *string = (char*)address;
            NSLog(@"string = %p", string);
        }
#endif /* defined(__LP64__) */
        
    });
    
    return classNames;
}

@implementation FBIntegrationManager

+ (Class)classForProtocol:(Protocol*)protocol{
    NSArray<Class> *classes = [self classesForProtocol_internal:protocol];
    return classes.firstObject;
}

+ (NSArray<Class>*)classesForProtocol:(Protocol*)protocol{
    return [self classesForProtocol_internal:protocol];
}

+ (NSArray<Class>*)classesForProtocol_internal:(id)protocol{
    NSArray<NSString*> *classNames = readConfigurationClassNames();
    
    NSArray<Class> *classes = [NSArray new];
    for (NSString *className in classNames) {
        
    }
    
    return classes;
}
@end
