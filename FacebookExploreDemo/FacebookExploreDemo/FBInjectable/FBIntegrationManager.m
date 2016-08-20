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
    const struct mach_header *mhp = (struct mach_header*)info.dli_fbase;
    const struct section * sec = getsectbyname("__DATA", InjectableSectionName);
    const char * memory = (const char *)( sec->offset + (uint32_t)mhp);
    uint32_t aslr = (uint32_t)mhp - (sec->addr - sec->offset);
    
    uint32_t *memory32 = (uint32_t*)memory;
    for(int idx = 0; idx < sec->size/sizeof(void*); ++idx){
        memory32[idx] += aslr;
    }
    
#else /* defined(__LP64__) */
    
    const struct mach_header_64 *mhp = (struct mach_header_64*)info.dli_fbase;
    const struct section_64 * sec = getsectbyname("__DATA", InjectableSectionName);
    const char * memory = (const char *)( sec->offset + (uint64_t)mhp);
    
    uint64_t aslr = (uint64_t)mhp - (sec->addr - sec->offset);
    uint64_t *memory64 = (uint64_t*)memory;
    for(int idx = 0; idx < sec->size/sizeof(void*); ++idx){
        memory64[idx] += aslr;
    }
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
            NSLog(@"string = %p , %s", string, string);
        }
#endif /* defined(__LP64__) */
        
        NSLog(@"finish");
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
