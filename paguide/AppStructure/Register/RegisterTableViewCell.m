//
//  RegisterTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 27/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RegisterTableViewCell.h"

#define TERM_OF_USE @"TermsofService"

@interface RegisterTableViewCell() <TTTAttributedLabelDelegate,UITextFieldDelegate>

@property (nonatomic,strong)NSArray<KeyValueModel>* arrayKeyValueList;

@property (nonatomic,copy)StringBlock completionStrBlock;

@end

@implementation RegisterTableViewCell 

- (IBAction)btnOneClicked:(id)sender {
    
    
    if (self.didSelectBlock)
    {
        self.didSelectBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.txtDefault.delegate = self;
    // Initialization code
    
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: APP_MAIN_COLOR,
                                     NSUnderlineColorAttributeName: APP_MAIN_COLOR,
                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    self.lblCustomText.linkAttributes = linkAttributes; // customizes the appearance of links
 
}

-(void)setLoginViewModel:(LoginViewModel *)loginViewModel
{
 
    _loginViewModel = loginViewModel;

    
    switch (_loginViewModel.type) {
        case REGISTER_CELL_TYPE_email_address:
            

            self.txtDefault.text = loginViewModel.emailAddress;
            break;
            
        case REGISTER_CELL_TYPE_name:
            self.txtDefault.text = loginViewModel.name;

            break;
        case REGISTER_CELL_TYPE_country:
           
            [self.btnCountry setTitle:loginViewModel.countryName forState:UIControlStateNormal] ;

            break;
        case REGISTER_CELL_TYPE_phone_number:
           
            self.txtDefault.text = loginViewModel.phoneNumber;
            
            [self.btnPrefix setTitle:loginViewModel.prefix forState:UIControlStateNormal] ;
            
            break;
        case REGISTER_CELL_TYPE_TNC:
            
            break;
        case REGISTER_CELL_TYPE_Password:
            self.txtDefault.text = loginViewModel.password;

            break;
        case REGISTER_CELL_TYPE_RE_Password:
            self.txtDefault.text = loginViewModel.retypepassword;

            break;
            
        default:
            break;
    }
   
    self.txtDefault.placeholder = _loginViewModel.description;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setup:(NSString*)main KeyValue:(NSArray<KeyValueModel>*)array DidClickBlock:(StringBlock)completionStrBlock
{
    NSString* term = main;
    
    self.lblCustomText.text = term;
    
    self.arrayKeyValueList = array;
    
    self.lblCustomText.delegate = self;

    
    for (int i = 0; i < self.arrayKeyValueList.count; i++) {
        
        //NSRange termofuse = [term rangeOfString:@"Terms of Service"];
       
        KeyValueModel* model = self.arrayKeyValueList[i];

        NSRange range = [term rangeOfString:model.value];

        
        NSURL *url = [NSURL URLWithString:model.key];
        
        [self.lblCustomText addLinkToURL:url withRange:range];
        
    }
  
    
    self.completionStrBlock = completionStrBlock;

}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    for (int i = 0; i<self.arrayKeyValueList.count; i++) {
        
        KeyValueModel* model = self.arrayKeyValueList[i];

        if ([url.absoluteString isEqualToString:model.key]) {
           
            if (self.completionStrBlock) {
                self.completionStrBlock(model.key);
            }
        }
       
    }
    

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
    switch (_loginViewModel.type) {
        case REGISTER_CELL_TYPE_email_address:
            
            _loginViewModel.emailAddress = textField.text;

            break;
            
        case REGISTER_CELL_TYPE_name:
            _loginViewModel.name = textField.text;
            
            break;
        case REGISTER_CELL_TYPE_country:
            
            
            break;
        case REGISTER_CELL_TYPE_phone_number:
            _loginViewModel.phoneNumber = textField.text;
            
            break;
        case REGISTER_CELL_TYPE_TNC:
            
            break;
        case REGISTER_CELL_TYPE_Password:
            _loginViewModel.password = textField.text;
            
            break;
        case REGISTER_CELL_TYPE_RE_Password:
            _loginViewModel.retypepassword = textField.text;
            
            break;
            
        default:
            break;
    }

   
    if (self.didUpdateModelBlock) {
        self.didUpdateModelBlock(self.loginViewModel);
    }
}

@end
