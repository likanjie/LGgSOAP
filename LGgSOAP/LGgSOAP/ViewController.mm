//
//  ViewController.m
//  LGgSOAP
//
//  Created by 李堪阶 on 16/6/24.
//  Copyright © 2016年 DM. All rights reserved.
//

#import "ViewController.h"
#import "soapStub.h"
#import "gsoapios.h"
#define Secret_char const_cast<char *>("~~~~~~")
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
}

- (void)getData{
    
    struct soap *soap = soap_new();
    
    if (soap_register_plugin(soap, soap_ios) == SOAP_OK) {
        
        soap_ios_setcachepolicy(soap, NSURLRequestReturnCacheDataElseLoad);
        
        //请求时间 单位为秒
        soap_ios_settimeoutinterval(soap, 3);
        
        //转码
        soap_set_mode(soap, SOAP_C_UTFSTRING);
        
        //接收值
        std::string str;
        
        //访问地址
        const char *http = [@"http://~~~~~~~~~/" UTF8String];
        //命名空间
        const char *blank = [@"http://tempuri.org/xx" UTF8String];
        
        /**
         *  请求返回的状态
         *
         *  @param soap        soap
         *  @param http        访问地址
         *  @param blank       命名空间
         *  @param Secret_char 参数
         *  @param str         请求返回的数据
         *
         *  @return 返回请求状态
         */
        int status = soap_call_ns__GetCity(soap, http, blank, Secret_char, &str);
        
        soap_free_temp(soap);
        
        if (status == SOAP_OK) { //请求数据成功
            
            NSString *resultString = [NSString stringWithUTF8String:str.c_str()];
            
            //请求结果
            NSLog(@"%@",resultString);
            
        }else{//请求数据失败
            
            soap_print_fault(soap, stderr);
        }
    }
    
    soap_end(soap);
    soap_free(soap);
}

@end
