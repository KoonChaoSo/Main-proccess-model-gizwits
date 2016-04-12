//
//  SURHeaterMainViewController.h
//  sunrainapp_ios
//
//  Created by Cmb on 6/10/15.
//  Copyright © 2015 Sunrain. All rights reserved.
//

#import "SURBaseControlViewController.h"

typedef enum {
    SURHeaterRegular,
    SURHeaterIrregular,
    SURHeaterPowerOff,
}SURHeaterModel;

typedef enum{
    timing,
    conservation,
    constantTemp,
}SURMode;

@interface SURHeaterMainViewController : SURBaseControlViewController

@end
