//
//  Utility.m
//  LavanApp
//
//  Created by IPHONE-11 on 27/05/15.
//  Copyright (c) 2015 Rapidsoft Technologies Pvt. Ltd. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"
static Utility *__utility;

@implementation Utility

+(Utility*)sharedInstance
{
    if(!__utility) {
        __utility = [[[self class] alloc] init];
        
    }
    return __utility;
}

+ (BOOL) isNetworkAvailable
{
    Reachability * reachability	= [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)emailValidate:(NSString *)email
{
    //Based on the string below
    //NSString *strEmailMatchstring=@”\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b”;
    
    //Quick return(NO) if @ Or . not in the string
    if([email rangeOfString:@"@"].location == NSNotFound || [email rangeOfString:@"."].location == NSNotFound)
        return NO;
    
    //Break email address into its components
    NSString * accountName = [email substringToIndex: [email rangeOfString:@"@"].location];
    email = [email substringFromIndex:[email rangeOfString:@"@"].location+1];
    
    //’.’ not present in substring
    if([email rangeOfString:@"."].location == NSNotFound)
        return NO;
    NSString * domainName = [email substringToIndex:[email rangeOfString:@"."].location];
    NSString * subDomain = [email substringFromIndex:[email rangeOfString:@"."].location+1];
    
    //username, domainname and subdomain name should not contain the following charters below
    //filter for user name
    NSString * unWantedInUName = @" ~!@#$^&*()={}[]|;’:\”<>,?/`";
    //filter for domain
    NSString * unWantedInDomain = @" ~!@#$%^&*()={}[]|;’:\”<>,+?/`";
    //filter for subdomain
    NSString * unWantedInSub = @" `~!@#$%^&*()={}[]:\”;’<>,?/1234567890";
    
    //subdomain should not be less that 2 and not greater 6
    if(!(subDomain.length >= 2 && subDomain.length <= 6))
        return NO;
    
    if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location != NSNotFound
       || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location != NSNotFound
       || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location != NSNotFound)
        return NO;
    
    return YES;
}

+ (void)setObject:(id)obj forKey:(NSString *)key;
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:obj forKey:key];
    [userDefault synchronize];
}

+ (id)objectForKey:(NSString *)key;
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:key];
}

+ (void)setBool:(BOOL)boolean forKey:(NSString *)key
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setBool:boolean forKey:key];
    [userDefault synchronize];
}

+ (BOOL)boolForKey:(NSString *)key
{
    NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:key];
}

+ (NSString *)base64StringEncodeFromString:(NSString *)string
{
    NSData * encodeData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSString * base64String = [encodeData base64EncodedStringWithOptions:0];
    return base64String;
}

+ (NSString *)stringDecodeFrombase64String:(NSString *)base64String
{
    NSString * decodedString;
    if (base64String.length)
    {
        NSData * decodedData = [[NSData alloc] initWithBase64EncodedString:base64String options:0];
        decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    }
    else
    {
        decodedString = base64String;
    }
    return [self returnStringAfterValidation:decodedString];
}

+ (NSString *)returnStringAfterValidation:(id)value
{
    if (![value isKindOfClass:[NSString class]])
    {
        return @"";
    }
    return value;
}

+(NSMutableDictionary *)convertIntoBase64:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary {
    
    for (id value in valuesArray) {
        
        // if dictonary contains string values
        if ([value isKindOfClass:[NSString class]]) {
            NSString *base64String = [self base64StringEncodeFromString:value];
            for (NSString *key in [dictionary allKeys]) {
                if ([[dictionary objectForKey:key] isKindOfClass:[NSString class]]) {
                    if ([[dictionary objectForKey:key] isEqualToString:value]) {
                        [dictionary setObject:base64String forKey:key];
                    }
                }
            }
        }
        
        //if dictionary contains an array as value
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray* allKeyArray = [dictionary allKeys];
            NSString* arrayName = @"";
            for (NSString* key in allKeyArray) {
                if ([dictionary valueForKey:key] == value)
                {
                    arrayName = key;
                }
            }
            
            NSMutableArray *valueCopy = [value mutableCopy];
            for (int j = 0; j < valueCopy.count; j++) {
                id key = [valueCopy objectAtIndex:j];
                
                //if array contains dictionary as value
                if ([key isKindOfClass:[NSDictionary class]]) {
                    [self convertIntoBase64:[key allValues] dictionary:key];
                }
                
                //if array contains string values
                else if ([key isKindOfClass:[NSString class]]) {
                    NSString *utf8String = [self base64StringEncodeFromString:key];
                    for (int i = 0; i < valueCopy.count; i++) {
                        if ([[valueCopy objectAtIndex:i] isEqualToString:key]) {
                            [valueCopy replaceObjectAtIndex:i withObject:utf8String];
                        }
                    }
                }
            }
            
            [dictionary setObject:valueCopy forKey:arrayName];
        }
        
        // if dictonary contains dictionary as value
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self convertIntoBase64:[value allValues] dictionary:value];
        }
    }
    
    return dictionary;
}

+(NSMutableDictionary *)convertIntoUTF8:(NSArray *)valuesArray dictionary : (NSMutableDictionary *) dictionary
{
    for (id value in valuesArray)
    {
        // if dictonary contains string values
        if ([value isKindOfClass:[NSString class]])
        {
            NSString * utf8String = [self stringDecodeFrombase64String:value];
            for (NSString * key in [dictionary allKeys])
            {
                if ([[dictionary objectForKey:key] isKindOfClass:[NSString class]])
                {
                    if ([[dictionary objectForKey:key] isEqualToString:value])
                    {
                        [dictionary setObject:utf8String forKey:key];
                    }
                }
            }
        }
        //if dictionary contains an array as value
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSArray * allKeyArray = [dictionary allKeys];
            NSString * arrayName = @"";
            for (NSString * key in allKeyArray)
            {
                if ([dictionary valueForKey:key] == value)
                {
                    arrayName = key;
                }
            }
            
            NSMutableArray * valueCopy = [value mutableCopy];
            for (int j = 0; j < valueCopy.count; j++)
            {
                id key = [valueCopy objectAtIndex:j];
                
                //if array contains dictionary as value
                if ([key isKindOfClass:[NSDictionary class]])
                {
                    [self convertIntoUTF8:[key allValues] dictionary:key];
                }
                
                //if array contains string values
                else if ([key isKindOfClass:[NSString class]])
                {
                    NSString * utf8String = [self stringDecodeFrombase64String:key];
                    for (int i = 0; i < valueCopy.count; i++)
                    {
                        if ([[valueCopy objectAtIndex:i] isEqualToString:key])
                        {
                            [valueCopy replaceObjectAtIndex:i withObject:utf8String];
                        }
                    }
                }
            }
            
            [dictionary setObject:valueCopy forKey:arrayName];
        }
        
        // if dictonary contains dictionary as value
        if ([value isKindOfClass:[NSDictionary class]])
        {
            [self convertIntoUTF8:[value allValues] dictionary:value];
        }
    }
    return dictionary;
}

@end
