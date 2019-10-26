//
//  UIView+ViewController.m
//  CiticMoblieBank
//
//  Created by lsl on 8/28/14.
//  Copyright (c) 2014 com.ictic.bank. All rights reserved.
//

#import "UIView+ViewController.h"

@implementation UIView (ViewController)

- (UIViewController *)viewController
{
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    return nil;
}

@end
