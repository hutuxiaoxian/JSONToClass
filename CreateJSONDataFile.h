//
//  CreateJSONDataFile.h
//  JSONToClass
//
//  Created by 糊涂 on 14-8-18.
//  Copyright (c) 2014年 hutu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateJSONDataFile : NSObject


-(void)createObectCFileWithFileName:(NSString*)fname JSON:(NSString*)json;
-(void)createJavaFileWithFileName:(NSString*)fname JSON:(NSString*)json;

@end
