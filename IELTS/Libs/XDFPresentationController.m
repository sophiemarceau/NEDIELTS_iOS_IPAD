//
//  XDFPresentationController.m
//  IELTS
//
//  Created by melp on 14/12/1.
//  Copyright (c) 2014年 Newton. All rights reserved.
//

#import "XDFPresentationController.h"

@implementation XDFPresentationController
{
     UIView *dimmingView;
     CGRect _FrameRect;
}

- (void)setFormRect:(CGRect)rect
{
    _FrameRect = rect;
}

- (CGRect)frameOfPresentedViewInContainerView
{
    return _FrameRect;//CGRectMake(62.f, 114.f, 350.f, 540.f);
}

-(id) initWithPresentedViewController:(UIViewController *)presentedViewController
             presentingViewController:(UIViewController *)presentingViewController
{
    self = [super initWithPresentedViewController:presentedViewController presentingViewController:presentingViewController];
    if(self){
        
        dimmingView = [[UIView alloc] init];
        dimmingView.backgroundColor = [UIColor grayColor];
        dimmingView.alpha = 0.0;
    }
    return self;
}

- (void)presentationTransitionWillBegin
{

    dimmingView.frame = self.containerView.bounds;
    [self.containerView addSubview:dimmingView];
    [self.containerView addSubview:self.presentedView];
    
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        dimmingView.alpha = 0.5;
    } completion:nil];
}

- (void)presentationTransitionDidEnd:(BOOL)completed
{
    if(!completed){
        [dimmingView removeFromSuperview];
    }
}

- (void)dismissalTransitionWillBegin
{
    id<UIViewControllerTransitionCoordinator> coordinator = self.presentingViewController.transitionCoordinator;
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        dimmingView.alpha = 0.0;
    } completion:nil];
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    if(completed){
        [dimmingView removeFromSuperview];
    }
}

@end
