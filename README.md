#gSoap使用教程
- 把demo里的gsoap文件夹里的5个文件拷贝到你的项目中 如图：
![gsoap文件](https://github.com/likanjie/image/blob/master/61FF0801-6175-4AD5-95FE-4720D081612B.png?raw=true)
- 在gsoap文件夹里新建一个server.h文件 如图：
![建server.h文件](https://github.com/likanjie/image/blob/master/A2E5433D-2688-4E05-BB46-120883687956.png?raw=true)
- 在server.h里写接口：固定写法：
`int ns__方法名();`

如图：
![写接口](https://github.com/likanjie/image/blob/master/75A8F412-F148-4E91-9EF4-0C01B20A2791.png?raw=true)
- 打开终端cd到项目中的gsoap文件夹中，然后编写命令行编译接口：
`./soapcpp2 -C -x server.h`

然后生成如图的文件(`Compilation successful`表示编译成功)
![编写命令行](https://github.com/likanjie/image/blob/master/199CB584-93AA-4F57-BB02-2F6A3EC12FB8.png?raw=true)
- 在项目中右击Add files to...添加gsoap文件夹 如图
![添加文件](https://github.com/likanjie/image/blob/master/A0FD1473-810B-4B1F-884A-030CD7B9C0B1.png?raw=true)
- 把一些没用的文件给删掉
![删掉文件](https://github.com/likanjie/image/blob/master/8BE55D1D-CA7B-4941-A780-8FE1316754D5.png?raw=true)
- command + b编译之后出现这些错误，解决方法Foundation头文件:(`#import <Foundation/Foundation.h>`)
-![添加头文件](https://github.com/likanjie/image/blob/master/7FF13AD0-3CD0-476A-B0BC-927271AB5206.png?raw=true)
- 再次编译之后还报这些错误
![arc报错](https://github.com/likanjie/image/blob/master/4143CA1A-8804-4DFD-8E89-81E01813743F.png?raw=true)
解决方法：MRC和ARC混编
![解决方法](https://github.com/likanjie/image/blob/master/DBA2855F-8AA8-49E0-B169-1AF367A27BD7.png?raw=true)
- 再次编译，还是报错：
![报错](https://github.com/likanjie/image/blob/master/93EED972-75E3-4921-8193-2C29EEF1A7DC.png?raw=true)
解决方法：把main.m文件的后缀改为.mm,然后在main.mm文件中引入头文件
![引入头文件](https://github.com/likanjie/image/blob/master/84567A71-5643-4FD8-8A84-834FBEFE29EF.png?raw=true)
- 再次编译之后已经编译成功，但会出现一百多个警告
![警告](https://github.com/likanjie/image/blob/master/FE18B4F6-2846-48EE-B2E4-3A4CDE4D5B05.png?raw=true)
解决方法：在所在的文件中加 -w 然后编译就会全部通过了
![编译通过](https://github.com/likanjie/image/blob/master/37E831E6-0FED-4F58-8E08-0998A0F5802B.png?raw=true)
- 调用接口时，需要在所在的控制器中把后缀名改为.mm，因为gsoap是用C++写，得兼容。并引入gsoap头文件
![兼容C++](https://github.com/likanjie/image/blob/master/422ECB10-26C2-428D-9A69-0D25033FA964.png?raw=true)
- 写调用接口代码


    `  struct soap *soap = soap_new();
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
`

返回的数据：
![返回的数据](https://github.com/likanjie/image/blob/master/1A296FC9-7B57-499F-935A-14A80D00C7E0.png?raw=true)

###提示
以后写接口时在server.h里写接口并保存，然后在终端中cd到server.h的文件夹中，执行命令：`./soapcpp2 -C -x server.h` 当出现 Compilation successful 时表示已经编译成功
以后在想哪个控制器请求数据时，就引入两个文件`#import "soapStub.h"` `#import "gsoapios.h"`。 只修改`int status = soap_call_ns__方法名(参数，参数，结果)`的代码;
