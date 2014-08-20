//
//  CreateJSONDataFile.m
//  JSONToClass
//
//  Created by 糊涂 on 14-8-18.
//  Copyright (c) 2014年 hutu. All rights reserved.
//

#import "CreateJSONDataFile.h"
#define SAVE_PATH        @"JSONObjectData"

@interface CreateJSONDataFile()
@property (nonatomic,strong)NSMutableString*strClass;
@end

@implementation CreateJSONDataFile


-(void)createObectCFileWithFileName:(NSString*)fname JSON:(NSString*)json{
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:SAVE_PATH];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:path]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    self.strClass = [[NSMutableString alloc] init];
    NSString *fp = [path stringByAppendingPathComponent:fname];
//    if (![fm fileExistsAtPath:fp]) {
//    }
    
    [self loadObjectCTemplateWithName:fname filePath:fp json:json];
}

-(void)createJavaFileWithFileName:(NSString*)fname JSON:(NSString*)json{
    
}


-(void)loadObjectCTemplateWithName:(NSString*)fname filePath:(NSString*)fp json:(NSString*)json {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Template" ofType:@"h"];
    
    NSFileHandle *handle = [NSFileHandle fileHandleForUpdatingAtPath:path];
    NSString *str = [[NSString alloc ] initWithData:[handle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    [handle closeFile];
    
    str = [str stringByReplacingOccurrencesOfString:@"Template" withString:fname];
    
    
    str = [str stringByReplacingOccurrencesOfString:@"//~%field%~" withString:[self appendCObjectWithJSON:json]];
    
    str = [str stringByReplacingOccurrencesOfString:@"//~%import~%" withString:self.strClass];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:[fp stringByAppendingString:@".h"] atomically:YES];
    
    
    //生成.m文件
    NSString *mpath = [[NSBundle mainBundle] pathForResource:@"Template" ofType:@"m2"];
    handle = [NSFileHandle fileHandleForUpdatingAtPath:mpath];
    str = [[NSString alloc ] initWithData:[handle readDataToEndOfFile] encoding:NSUTF8StringEncoding];
    [handle closeFile];
    
    str = [str stringByReplacingOccurrencesOfString:@"Template" withString:fname];
    str = [str stringByReplacingOccurrencesOfString:@"//~%field%~" withString:[self appendMObjectWithJSON:json]];
    str = [str stringByReplacingOccurrencesOfString:@"//~%sfield%~" withString:[self appendMSObjectWithJSON:json]];
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:[fp stringByAppendingString:@".m"] atomically:YES];
    
    
}

// 生成.h文件中的类成员
-(NSString*) appendCObjectWithJSON:(NSString*)json{
    NSMutableString *mdata = [[NSMutableString alloc] init];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    for (NSString *key in [dict allKeys]) {
        NSString *str = [NSString stringWithFormat:@"@property (nonatomic ,%@ %@;\n", [self getCObjectTypeString:[dict objectForKey:key] key:key], key];
        [mdata appendString:str];
    }
    return [[NSString alloc] initWithString:mdata] ;
}

// 生成.m文件中的数据初始化
- (NSString*) appendMObjectWithJSON:(NSString*)json{
    NSMutableString *mdata = [[NSMutableString alloc] init];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    for (NSString *key in [dict allKeys]) {
        NSString *str = [self getCObjectMTypeString:[dict objectForKey:key] key:key];
        
        [mdata appendString:str];
    }
    
    
    return [[NSString alloc] initWithString:mdata] ;
}

// 生成.h文件中的类成员实际类型
- (NSString*) getCObjectTypeString:(id)value key:(NSString*)key{
    NSString *str ;
    
    if ([value isKindOfClass:[NSString class]]) {
        str = [NSString stringWithFormat:@"%@) %@", @"strong", @"NSString*"];
    }else if ([value isKindOfClass:[NSNumber class]]){
        str = [NSString stringWithFormat:@"%@) %@", @"strong", @"NSNumber*"];
    }else if ([value isKindOfClass:[NSDictionary class]]){
        str = [NSString stringWithFormat:@"%@) %@Data*", @"strong", [key capitalizedString]];
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:nil];
        NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ];
        
        [self.strClass appendString:[NSString stringWithFormat:@"#import \"%@Data.h\"\n", [key capitalizedString]]];
        
        [[[CreateJSONDataFile alloc] init] createObectCFileWithFileName:[[key capitalizedString] stringByAppendingString:@"Data"] JSON:json];
        
    }else if ([value isKindOfClass:[NSArray class]]){
        str = [NSString stringWithFormat:@"%@) %@", @"strong", @"NSMutableArray*"];
        if ([(NSArray*)value count] > 0) {
            
            [self.strClass appendString:[NSString stringWithFormat:@"#import \"%@ItemData.h\"\n", [key capitalizedString]]];
            NSData *data = [NSJSONSerialization dataWithJSONObject:[value objectAtIndex:0] options:NSJSONWritingPrettyPrinted error:nil];
            NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding ];
            [[[CreateJSONDataFile alloc] init] createObectCFileWithFileName:[[key capitalizedString] stringByAppendingString:@"ItemData"] JSON:json];
        }
        
    }
    
    return str;
}

// 生成.m文件中的类成员实际类型
- (NSString*) getCObjectMTypeString:(id)value key:(NSString*)key{
    NSString *str = @"";
    if ([value isKindOfClass:[NSDictionary class]]){
        
        str = [NSString stringWithFormat:@"        %@ = [[%@Data alloc] initWithJSON:json];\n", key,[key capitalizedString]];
        
    }else if ([value isKindOfClass:[NSArray class]]){
        
        if ([(NSArray*)value count] > 0) {
            
            str = [NSString stringWithFormat:@"\n        NSArray *arr = [json objectForKey:@\"%@\"];\n", key];
            str = [NSString stringWithFormat:@"%@\n        %@ = [[NSMutableArray alloc] initWithCapacity:[arr count]];\n", str, key];
            str = [NSString stringWithFormat:@"%@        for(NSDictionary *item in arr) {\n            [%@ addObject:[[%@ItemData alloc] initWithJSON:item]];\n        }\n", str, key, [key capitalizedString]];
        }
        
    }else{
        str = [NSString stringWithFormat:@"        %@ = [json objectForKey:@\"%@\"];\n", key, key];
    }
    return str;
}

// 生成.m文件中实现的geter,seter
- (NSString*)appendMSObjectWithJSON:(NSString*)json{
    NSMutableString *mdata = [[NSMutableString alloc] init];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
    for (NSString *key in [dict allKeys]) {
        NSString *str = [NSString stringWithFormat:@"@synthesize %@;\n", key];
        [mdata appendString:str];
    }
    
    return [[NSString alloc] initWithString:mdata] ;
}

@end
