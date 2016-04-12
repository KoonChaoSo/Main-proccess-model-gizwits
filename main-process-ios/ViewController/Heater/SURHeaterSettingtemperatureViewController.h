//
//  SURHeaterSettingtemperatureViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 8/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURBaseControlViewController.h"

@interface SURHeaterSettingtemperatureViewController : SURBaseControlViewController<UITableViewDataSource,UITableViewDelegate>
@property (assign, nonatomic) BOOL isHot;
@end
