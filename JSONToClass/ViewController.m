//
//  ViewController.m
//  JSONToClass
//
//  Created by 糊涂 on 14-8-18.
//  Copyright (c) 2014年 hutu. All rights reserved.
//

#import "ViewController.h"
#import "CreateJSONDataFile.h"

@interface ViewController ()

@property (weak) IBOutlet NSTextField *txtImportPath;
@property (strong) IBOutlet NSTextView *txtJSON;
@property (weak) IBOutlet NSButton *cbOC;
@property (weak) IBOutlet NSButton *cbJava;
@property (weak) IBOutlet NSTextField *txtSaveName;

@end

@implementation ViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}


- (IBAction)clickImport:(id)sender {
    NSOpenPanel *op = [NSOpenPanel openPanel];
    [op setCanChooseDirectories:NO];
    [op runModal];
    
    NSData *data = [NSData dataWithContentsOfURL:op.URL];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self.txtJSON setString:str];
    [self.txtImportPath setStringValue:[[op URL] absoluteString]];
}
- (IBAction)clickCreateDataFile:(id)sender {
    
    if ([self review]) {
        CreateJSONDataFile *cf = [[CreateJSONDataFile alloc] init];
        
        [cf createObectCFileWithFileName:[[self.txtSaveName stringValue] capitalizedString] JSON:[self.txtJSON string]];
    }
}

- (BOOL)review{
    BOOL isOK = YES;
    if (![self.txtSaveName stringValue] || [[self.txtSaveName stringValue] length]==0) {
        isOK = NO;
    }
    if (isOK && (![self.txtJSON string] || [[self.txtJSON string] length]==0)) {
        isOK = NO;
    }
    return isOK;
}

@end
