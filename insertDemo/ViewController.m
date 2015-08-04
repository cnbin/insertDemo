//
//  ViewController.m
//  insertDemo
//
//  Created by Apple on 8/4/15.
//  Copyright (c) 2015 华讯网络投资有限公司. All rights reserved.
//

#import "ViewController.h"
#import "NSString+URLEncoding.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    Text=[[UITextField alloc]initWithFrame:CGRectMake(20,80, 280, 30)];
    Text.placeholder=@" 请输入手机号-1";
    Text.keyboardType = UIKeyboardTypeNumberPad;
    Text.returnKeyType=UIReturnKeyDone;
    Text.clearButtonMode = UITextFieldViewModeWhileEditing;
    [Text.layer setBorderWidth:1.0];
    [Text.layer setCornerRadius:8.0];
    [self.view addSubview:Text];

    loginButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame=CGRectMake(20, Text.frame.origin.y+Text.frame.size.height+20, 280, 30);
    [loginButton setTitle:@"发送" forState:UIControlStateNormal];
    [loginButton setBackgroundColor:[UIColor greenColor]];
    [loginButton.layer setBorderWidth:1.0];
    
    [loginButton.layer setMasksToBounds:YES];
    [loginButton.layer setCornerRadius:10.0];
    loginButton.tag=1;
    [loginButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];

}

-(void)buttonAction:(UIButton *)button{
    
    [self startRequest];
    
}

-(void)startRequest
{
    NSString *strURL = [[NSString alloc] initWithFormat:@"http://192.168.40.10/Login/login.asmx"];
    NSURL *url = [NSURL URLWithString:[strURL URLEncodedString]];
    
    NSString * envelopeText = [NSString stringWithFormat:@"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                               "<soap:Body>"
                               "<insertInfo xmlns=\"http://tempuri.org/\">"
                               "<text>%@</text>"
                               "</insertInfo>"
                               "</soap:Body>"
                               "</soap:Envelope>",Text.text];
    
    NSData *envelope = [envelopeText dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:envelope];
    [request setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [envelope length]] forHTTPHeaderField:@"Content-Length"];
    
    NSURLConnection *connection = [[NSURLConnection alloc]
                                   initWithRequest:request delegate:self];
    
    if (connection) {
    }
}

#pragma mark- NSURLConnection 回调方法
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    
}

-(void) connection:(NSURLConnection *)connection didFailWithError: (NSError *)error {
    
    NSLog(@"%@",[error localizedDescription]);
}

- (void) connectionDidFinishLoading: (NSURLConnection*) connection {
    
    NSLog(@"请求完成...");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
