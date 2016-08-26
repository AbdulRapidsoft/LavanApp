//
//  Utility.h
//  LavanApp
//
//  Created by IPHONE-11 on 27/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject
+ (Utility *)sharedInstance;
@property(nonatomic, assign)BOOL isFriPick;
@property(nonatomic, assign)BOOL isSatPick;
@property(nonatomic, assign)BOOL isSunPick;
@property(nonatomic, assign)BOOL isFriDel;
@property(nonatomic, assign)BOOL isSatDel;
@property(nonatomic, assign)BOOL isSunDel;
@property(nonatomic, assign)BOOL friAfterThreePick;
@property(nonatomic, assign)BOOL nextWeek;
@property(nonatomic, assign)BOOL todayAfterFive;
@property(nonatomic, assign)BOOL todayAfterSix;
@property(nonatomic, assign)BOOL todayAfterSeven;
@property(nonatomic, assign)BOOL todayAfterEight;
@property(nonatomic, assign)BOOL todayAfterNine;


@property(nonatomic,retain)NSDate* pickDateFromString;
@property(nonatomic,retain)NSDate* delDateFromString;

+ (BOOL) isNetworkAvailable;
+ (BOOL) emailValidate:(NSString *)email;


// User Defaults method
+ (void) setObject:(id)obj forKey:(NSString *)key;
+ (void) setBool:(BOOL)boolean forKey:(NSString *)key;
+ (id) objectForKey:(NSString *)key;
+ (BOOL) boolForKey:(NSString *)key;
+(NSString *)base64StringEncodeFromString:(NSString*)string;
+(NSString *)stringDecodeFrombase64String:(NSString*)base64String;
+(NSDictionary *)convertIntoBase64:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary;
+(NSMutableDictionary *)convertIntoUTF8:(NSArray *)valuesArray dictionary : (NSDictionary *) dictionary;

@end
