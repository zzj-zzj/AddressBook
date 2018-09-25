//
//  SortingSolution.m
//  AddressBook
//
//  Created by 许小六 on 2018/9/20.
//  Copyright © 2018年 许小六. All rights reserved.
//

#import "SortingSolution.h"

@implementation SortingSolution

+ (NSMutableDictionary *)sortObjectsWith:(NSArray *)objects {
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    for (NSString *object in objects) {
        NSString *first = [self getFirstwordWithObject:object];
        int word = [first characterAtIndex:0];
        if (word >= 65 && word <= 90) {
            // A-Z
            NSMutableArray *mArr = [mDic objectForKey:first];
            if (mArr) {
                [mArr addObject:object];
                
            } else {
                mArr = [NSMutableArray arrayWithObject:object];
                [mDic setObject:mArr forKey:first];
            }
            
        } else {
            // #
            NSMutableArray *mArr = [mDic objectForKey:@"#"];
            if (mArr) {
                [mArr addObject:object];
                
            } else {
                mArr = [NSMutableArray arrayWithObject:object];
                [mDic setObject:mArr forKey:@"#"];
            }
        }
    }
    for (NSMutableArray *obj in mDic.allValues) {
        [obj sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 localizedCompare:obj2];
        }];
    }
    return mDic;
}

+ (NSString *)getFirstwordWithObject:(NSString *)object {
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:object];
    if (CFStringTransform((__bridge CFMutableStringRef)mStr, 0, kCFStringTransformMandarinLatin, NO)) {
        NSLog(@"QuanPingying: %@", mStr);
    }
    if (CFStringTransform((__bridge CFMutableStringRef)mStr, 0, kCFStringTransformStripDiacritics, NO)) {
        NSLog(@"Pingying: %@", mStr);
    }
    if (mStr.length > 0) {
        NSString *res = [[mStr uppercaseString] substringToIndex:1];
        return res;
    }
    
    return @"";
}


@end
