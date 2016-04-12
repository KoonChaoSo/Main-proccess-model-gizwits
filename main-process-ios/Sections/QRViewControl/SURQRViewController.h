#import <UIKit/UIKit.h>
#import <XPGWifiSDK/XPGWifiSDK.h>

typedef void(^QRUrlBlock)(NSString *url);

@interface SURQRViewController : UIViewController<XPGWifiSDKDelegate>{
    XPGWifiDevice *selectedDeivce;
}

@property (nonatomic, copy) QRUrlBlock qrUrlBlock;

@property (strong, nonatomic) XPGWifiDevice *slectedDevice;

-(instancetype)initWithDevice:(XPGWifiDevice *)device;

@end
