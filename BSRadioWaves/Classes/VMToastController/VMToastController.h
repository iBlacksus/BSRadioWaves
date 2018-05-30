//
//  VMToastController.h
//  pho.to
//
//  Created by Oleg Musinov on 9/8/17.
//  Copyright © 2017 VicMan, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern CGFloat const VMToastControllerAutoCloseDuration;

typedef void (^VMToastControllerCompletionHandler)();

@interface VMToastController : NSObject

+ (instancetype)toastControllerWithViewController:(UIViewController *)controller;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithViewController:(UIViewController *)controller NS_DESIGNATED_INITIALIZER;

- (void)showMessage:(NSString *)message;

- (void)showMessage:(NSString *)message closeAfterDuration:(CGFloat)closeAfterDuration;

- (void)showMessage:(NSString *)message closeAfterDuration:(CGFloat)closeAfterDuration completion:(nullable VMToastControllerCompletionHandler)completion;

- (void)showMessage:(NSString *)message completion:(nullable VMToastControllerCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
