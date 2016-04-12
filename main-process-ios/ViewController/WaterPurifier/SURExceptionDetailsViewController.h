//
//  SURExceptionDetailsViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 1/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURBaseControlViewController.h"

@interface SURExceptionDetailsViewController : UIViewController

@property (strong, nonatomic)NSString *exceptionTitle;

- (instancetype)initWithExceptionTitle:(NSString*)title;

@end
