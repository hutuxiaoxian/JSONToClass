//
//  JSONToClassTests.m
//  JSONToClassTests
//
//  Created by 糊涂 on 14-8-18.
//  Copyright (c) 2014年 hutu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CreateJSONDataFile.h"
@interface JSONToClassTests : XCTestCase

@end

@implementation JSONToClassTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. Thisd method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSURL *furl = [[NSURL alloc] initFileURLWithPath:@"json.txt"];
    NSData *data = [NSData dataWithContentsOfURL:furl];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
//    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    dict = [dict objectForKey:@"data"];
//    data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    [[[CreateJSONDataFile alloc] init] createObectCFileWithFileName:@"test" JSON:json];
    
}

@end
