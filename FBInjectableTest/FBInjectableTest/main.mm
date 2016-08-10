//
//  main.m
//  FBInjectableTest
//
//  Created by everettjf on 16/8/11.
//  Copyright © 2016年 everettjf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <dlfcn.h>

int main(int argc, char * argv[]) {
    Dl_info dlinfo;
    dladdr((const void *)main, &dlinfo);
#ifndef __LP64__
    const struct mach_header *mhp = (const struct mach_header*)dlinfo.dli_fbase;
#else
    const struct mach_header_64 *mhp = (const struct mach_header_64*)dlinfo.dli_fbase;
#endif
    
    unsigned long size = 0;
    uint8_t *data = getsectiondata(mhp, "__DATA", "FBInjectable", & size);
    
    @autoreleasepool {
        // memory read -c72 data
        NSLog(@"test");
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
