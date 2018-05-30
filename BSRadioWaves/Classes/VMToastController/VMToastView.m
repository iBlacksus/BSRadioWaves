//
//  VMToastView.m
//  pho.to
//
//  Created by Oleg Musinov on 9/8/17.
//  Copyright © 2017 VicMan, LLC. All rights reserved.
//

#import "VMToastView.h"

@interface VMToastView ()

@property (strong, nonatomic) IBOutlet UILabel *messageLabel;

@end

@implementation VMToastView

#pragma mark - Accessors -

- (void)setMessage:(NSString *)message {
    _message = message;
    
    self.messageLabel.text = message;
}

#pragma mark - Life cycle -

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.autoresizingMask = UIViewAutoresizingNone;
}

@end
