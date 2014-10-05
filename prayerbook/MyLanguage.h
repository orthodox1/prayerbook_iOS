//
//  MyLanguage.h
//  prayerbook
//
//  Created by Alexey Smirnov on 8/4/14.
//  Copyright (c) 2014 Alexey Smirnov. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_LANGUAGE @"en"

@interface MyLanguage : NSObject

+ (void)setLanguage:(NSString *)languageName;
+ (NSString*)language;
+ (NSString *)stringFor:(NSString *)str;
+ (NSArray*)tableViewStrings:(NSString*)code;

+ (id)singleton;

@property (strong, nonatomic) NSString *language;

@end
