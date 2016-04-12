#import "SURControlServiceImp.h"
#import <XPGWifiSDK/XPGWifiSDK.h>
#import "SURPropertyUtils.h"
#import "NSString+SURNSString.h"
#import "SURCommonService.h"

#define DATA_CMD                        @"cmd"                  //命令
#define DATA_ENTITY                     @"entity0"              //实体
#define DATA_ALERTS                     @"alerts"              //警告
#define DATA_FAULTS                     @"faults"              //错误
typedef enum
{
    DeviceCommandWrite    = 1,//写
    DeviceCommandRead     = 2,//读
    DeviceCommandResponse = 3,//读响应
    DeviceCommandNotify   = 4,//通知
}SURDeviceCommand;
static SURControlServiceImp *sharedService = nil;
@interface SURControlServiceImp()
@property (nonatomic,strong) NSArray * propertiesNSArray;
@end

@implementation SURControlServiceImp


+ (SURControlServiceImp *)sharedService
{
    if(nil == sharedService)
    {
        sharedService = [[SURControlServiceImp alloc] init];
    }
    return sharedService;
}

-(void)sendToControlWithEntity0:(NSDictionary *)entity ToDevice:(XPGWifiDevice *)device{
    NSDictionary *data = nil;
    
    data = @{DATA_CMD: @(DeviceCommandWrite),
             DATA_ENTITY: entity};
    if(data == nil){
        NSLog(@"the data is nil");
        return;
    }
    NSLog(@"Write data: %@", data);
    [device write:data];
}

-(void)getDeviceStatus:(XPGWifiDevice *)device{
    NSDictionary *data = nil;
    
    data = @{DATA_CMD: @(DeviceCommandRead)};
    if(data == nil){
        NSLog(@"the data is nil");
        return;
    }
    NSLog(@"Write data: %@", data);
    
    [device write:data];
}

-(void)readDataPoint:(NSDictionary *)allData completion:(readDataPointBlock)block{
    
    if(![allData isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return;
    }
    
    if(![[allData objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return;
    }
    
    NSDictionary *data = [allData objectForKey:@"data"];
    
    if(![data isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read data, error data format.");
        return;
    }
    
    NSNumber *nCommand = [data valueForKey:DATA_CMD];
    if(![nCommand isKindOfClass:[NSNumber class]])
    {
        NSLog(@"Error: could not read cmd, error cmd format.");
        return;
    }
    
    int nCmd = [nCommand intValue];
    if(nCmd != DeviceCommandResponse && nCmd != DeviceCommandNotify)
    {
        NSLog(@"Error: command is invalid, skip.");
        return;
    }
    
    NSDictionary *attributes = [data valueForKey:DATA_ENTITY];
    if(![attributes isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Error: could not read attributes, error attributes format.");
        return;
    }
    
    NSArray *alerts = [allData valueForKey:DATA_ALERTS];
    if(![alerts isKindOfClass:[NSArray class]])
    {
        NSLog(@"Error: could not read alerts, error alerts format.");
        return;
    }
    
    NSArray *faults = [allData valueForKey:DATA_FAULTS];
    if(![faults isKindOfClass:[NSArray class]])
    {
        NSLog(@"Error: could not read faults, error faults format.");
        return;
    }
    
    
    SURProductDataPointModel *dataModel = [[SURProductDataPointModel alloc] init];
    if(nil == self.propertiesNSArray){
        self.propertiesNSArray = [[SURPropertyUtils sharedUtils] allPropertyNames:dataModel];
    }
    
    
    for (int i=0;i<self.propertiesNSArray.count;i++){
        
        //关键词解决方案
        NSString *propertyName = self.propertiesNSArray[i];
        if ([propertyName isEqualToString:@"switch"])
        {
            propertyName = @"_switch";
        }
        
        SEL setSel = [self creatSetterWithPropertyName:propertyName];
        if ([dataModel respondsToSelector:setSel]) {
            //2.2 获取属性字典中key对应的value
            if(attributes[[propertyName handleKeyWord]] != nil){
                
                NSString  *value = [NSString stringWithFormat:@"%@", attributes[[propertyName handleKeyWord]]];
                
                [dataModel performSelectorOnMainThread:setSel
                                            withObject:value.lowercaseString
                                         waitUntilDone:[NSThread isMainThread]];
                
            }
            
        }
        
    }
    block(dataModel,alerts,faults);
}

- (SEL)creatSetterWithPropertyName: (NSString *) propertyName{
    
    //2.拼接上set关键字
    propertyName = [NSString stringWithFormat:@"set%@:", [propertyName firstCapitalLetter]];
    
    //3.返回set方法
    return NSSelectorFromString(propertyName);
}






@end
