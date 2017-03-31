//
//  RegisterViewController.h
//  paguide
//
//  Created by Evan Beh on 27/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacebookModel.h"

typedef enum
{
    REGISTER_TYPE_FACEBOOK = 1,
    REGISTER_TYPE_NORMAL = 2,
    
}REGISTER_TYPE;


@interface RegisterViewController : UIViewController


@property (nonatomic,assign)REGISTER_TYPE type;

@property (nonatomic,strong)FacebookModel* fbModel;

@end
