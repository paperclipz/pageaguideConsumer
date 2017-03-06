//
//  RegisterTableViewCell.m
//  paguide
//
//  Created by Evan Beh on 27/02/2017.
//  Copyright © 2017 Evan Beh. All rights reserved.
//

#import "RegisterTableViewCell.h"

#define TERM_OF_USE @"TermsofService"

@interface RegisterTableViewCell() <TTTAttributedLabelDelegate>

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
    // Initialization code
    
    
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                     NSUnderlineColorAttributeName: [UIColor redColor],
                                     NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    
    // assume that textView is a UITextView previously created (either by code or Interface Builder)
    self.lblCustomText.linkAttributes = linkAttributes; // customizes the appearance of links
 
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


@end
