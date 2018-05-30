//
//  VMToastController.m
//  pho.to
//
//  Created by Oleg Musinov on 9/8/17.
//  Copyright © 2017 VicMan, LLC. All rights reserved.
//

#import "VMToastController.h"
#import "VMToastView.h"
#import <PureLayout/PureLayout.h>
#import "UIView+VMConstraints.h"

static CGFloat const VMToastControllerShowAnimationDuration = .25;
static CGFloat const VMToastControllerCloseAnimationDuration = .25;
CGFloat const VMToastControllerAutoCloseDuration = 2.5;

@interface VMToastController ()

@property (weak, nonatomic) UIViewController *controller;
@property (strong, nonatomic) NSMutableArray<VMToastView *> *views;

@end

@implementation VMToastController

#pragma mark - Life cycle -

+ (instancetype)toastControllerWithViewController:(UIViewController *)controller {
    return [[VMToastController alloc] initWithViewController:controller];
}

- (instancetype)initWithViewController:(UIViewController *)controller {
    if (self = [super init]) {
        _controller = controller;
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    _views = @[].mutableCopy;
}

#pragma mark - Public -

- (void)showMessage:(NSString *)message {
    [self showMessage:message closeAfterDuration:VMToastControllerAutoCloseDuration];
}

- (void)showMessage:(NSString *)message closeAfterDuration:(CGFloat)closeAfterDuration {
    [self showMessage:message closeAfterDuration:closeAfterDuration completion:nil];
}

- (void)showMessage:(NSString *)message completion:(nullable VMToastControllerCompletionHandler)completion {
    [self showMessage:message closeAfterDuration:VMToastControllerAutoCloseDuration completion:completion];
}

- (void)showMessage:(NSString *)message closeAfterDuration:(CGFloat)closeAfterDuration completion:(nullable VMToastControllerCompletionHandler)completion {
    VMToastView *view = [self viewWithMessage:message];
    view.alpha = 0.;
    
    if ([self.controller isKindOfClass:[UINavigationController class]]) {
        [self.controller.view insertSubview:view atIndex:self.controller.view.subviews.count-1];
    } else {
        if (self.views.count == 0) {
            [self.controller.view addSubview:view];
        } else {
            [self.controller.view insertSubview:view belowSubview:self.views.lastObject];
        }
    }
    
    [view autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [view autoPinEdgeToSuperviewEdge:ALEdgeRight];
    if (self.views.count == 0) {
        [view autoPinEdgeToSuperviewEdge:ALEdgeTop];
    } else {
        [view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.views.lastObject];
    }
    
    NSLayoutConstraint *top = [view firstTopConstraint];
    CGFloat topConstant = top.constant;
    top.constant -= CGRectGetHeight(view.frame);
    [self.controller.view layoutIfNeeded];
    top.constant = topConstant;
    @weakify(self);
    [UIView animateWithDuration:VMToastControllerShowAnimationDuration animations:^{
        @strongify(self);
        view.alpha = 1.;
        [self.controller.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        @strongify(self);
        @weakify(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(closeAfterDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            @strongify(self);
            [self closeView:view completion:completion];
        });
    }];
    
    [self.views addObject:view];
}

#pragma mark - Private -

- (void)closeView:(VMToastView *)view completion:(nullable VMToastControllerCompletionHandler)completion {
    NSLayoutConstraint *top = [view firstTopConstraint];
    top.constant -= CGRectGetHeight(view.frame);
    @weakify(self);
    [UIView animateWithDuration:VMToastControllerCloseAnimationDuration animations:^{
        @strongify(self);
        view.alpha = 0.;
        [self.controller.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        @strongify(self);
        [self.views removeObject:view];
        @safeblock(completion);
    }];
}

- (VMToastView *)viewWithMessage:(NSString *)message {
    VMToastView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([VMToastView class]) owner:nil options:nil] lastObject];
    view.message = message;
    
    return view;
}

@end
