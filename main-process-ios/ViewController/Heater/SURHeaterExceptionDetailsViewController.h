//
//  SURHeaterExceptionDetailsViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 8/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURBaseControlViewController.h"

@interface SURHeaterExceptionDetailsViewController : UIViewController

- (instancetype)initWithExceptionTitle:(NSString*)title;

@property (strong, nonatomic)NSString *exceptionTitle;
@end
