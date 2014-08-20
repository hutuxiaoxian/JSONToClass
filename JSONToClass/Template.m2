//
//  Template.m
//  JSONToClass
//
//  Created by 糊涂 on 14-8-18.
//  Copyright (c) 2014年 hutu. All rights reserved.
//

#import "Template.h"
@implementation Template

//~%sfield%~
- (id)initWithJSON:(id)json{
    self = [super init];
    if (self){
//~%field%~
    }
    
    return self;
}

@end
