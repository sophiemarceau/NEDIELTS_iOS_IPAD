//
//  Sys_AccountView.m
//  IELTS
//
//  Created by melp on 14/11/17.
//  Copyright (c) 2014年 Neworiental. All rights reserved.
//

#import "Sys_AccountView.h"
#import "RusultManage.h"
#import "XDFAppDelegate.h"
//#import "TestViewController.h"
#import "UIImage+fixOrientation.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FileUploadHelper.h"
#import "NetworkManager.h"
#import "UIImageView+WebCache.h"
#import "ZCControl.h"
#import "Dlg_ChangePasswordViewController.h"

@interface Sys_AccountView ()<Dlg_ChangePasswordViewControllerDelegate>

@property (nonatomic,strong)UIPopoverController *popoverCtr;

@property (nonatomic,strong)Dlg_ChangePasswordViewController *changPassWord;
@property (nonatomic,strong) UIControl *maskControlView; //控制收起搜索框搜索框

@end

@implementation Sys_AccountView
{
    BOOL _IsUploading;
}


- (void)initView:(UIViewController *)parentView
{
    if(self.IsInited) return;
    
    [super initView:parentView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserImageClick:)];
    [self.imgUserImage addGestureRecognizer:singleTap];
    [self.imgUserImage setUserInteractionEnabled:YES];
    
    //将头像处理为圆形
    [ZCControl circleImage:self.imgUserImage];
    
    UserModel *um = [RusultManage shareRusultManage].userMode;
    
    //用户头像
    NSString *UserIconPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,um.IconUrl];
    [self.imgUserImage sd_setImageWithURL:[NSURL URLWithString:UserIconPath] placeholderImage:[UIImage imageNamed:@"tou.png"]];
    
    //用户昵称
    self.txtNickName.text = um.NickName;
    self.txtNickName.font = [UIFont systemFontOfSize:20.0f];
    self.txtNickName.textColor = rgb(95, 95, 95, 1.0);
    
    self.IsInited = YES;
}

- (void)onUserImageClick:(UITapGestureRecognizer *)sender
{
//    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中选取", nil];
//    as.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
//    
//    [as showInView:self.ParentViewControll.view];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择图片"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"我要拍照", @"本地上传",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [actionSheet showInView:self.ParentViewControll.view];
//    [actionSheet showFromRect:self.imgUserImage.bounds inView:self.imgUserImage animated:YES];

}

- (IBAction)onUserLogoff:(id)sender
{
    [[RusultManage shareRusultManage].userMode UserLogoff];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOFFCHANGE" object:nil];
}

- (IBAction)chanegPsw:(UIButton *)sender
{
    //[self.chgPassView setHidden:NO];
    Dlg_ChangePasswordViewController *v = [[Dlg_ChangePasswordViewController alloc] initWithNibName:@"Dlg_ChangePasswordViewController" bundle:nil];
    
    v.delegate = self;
    CGFloat with =  v.view.frame.size.width;
    CGFloat heigt = v.view.frame.size.height;
    
    v.view.frame = CGRectMake((1024-with)/2, self.viewController.view.frame.size.height,with, heigt);
    [UIView animateWithDuration:0.35 animations:^{
        v.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    }];
    [self _initMask:v.view];
    
    [self.viewController.parentViewController.parentViewController.view addSubview:v.view];
    self.changPassWord = v;

//    [ZCControl presentModalFromController:self.ParentViewControll toController:v isHiddenNav:YES Width:352 Height:400];
}

#pragma mark - 实现点击键盘以外都收起键盘
- (void)_initMask:(UIView *)textView
{
    //创建点击视图
    if (_maskControlView == nil) {
        _maskControlView = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 1024 , 768)];
//        [_maskControlView addTarget:self action:@selector(maskControlView:) forControlEvents:UIControlEventTouchUpInside];
        _maskControlView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        [self.viewController.parentViewController.parentViewController.view insertSubview:_maskControlView belowSubview:textView];
    }
}
//隐藏alert
- (void)maskControlView:(UIControl *)maskView
{
    CGFloat with =  self.changPassWord.view.frame.size.width;
    CGFloat heigt = self.changPassWord.view.frame.size.height;
    self.changPassWord.view.frame = CGRectMake((1024-with)/2, (768-heigt)/2, with, heigt);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.changPassWord.view.frame = CGRectMake((1024-with)/2, self.viewController.view.height,with, heigt);
        [_maskControlView removeFromSuperview];
        _maskControlView = nil;
    } completion:^(BOOL finished) {
        
        [self.changPassWord.view removeFromSuperview];
        self.changPassWord.view = nil;
        
        [self.changPassWord removeFromParentViewController];
        self.changPassWord = nil;
    }];
}
#pragma mark - Dlg_ChangePasswordViewControllerDelegate
- (void)shutChangePassWordModelView
{
    [self maskControlView:nil];
}


- (void)onDisplayView
{
}

#pragma mark - UIActionSheet 选取图片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //拍照
            //[self UploadImageFromCamera];
            [self performSelector:@selector(UploadImageFromCamera) withObject:nil afterDelay:1];
            break;
            
        case 1: //相册
            //[self UploadImageFromAlbum];
            [self performSelector:@selector(UploadImageFromAlbum) withObject:nil afterDelay:1];
            break;
    }
}

-(void)UploadImageFromAlbum
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType              = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.modalTransitionStyle    = UIModalTransitionStyleCoverVertical;
    imagePicker.allowsEditing = YES;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"OrgWindowFrame" object:nil];
//    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
    UIPopoverController *popver = [[UIPopoverController alloc]initWithContentViewController:imagePicker];
    self.popoverCtr = popver;
    [self.popoverCtr presentPopoverFromRect:self.imgUserImage.bounds inView:self.imgUserImage permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

}


-(void)UploadImageFromCamera
{
    @try
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType              = UIImagePickerControllerSourceTypeCamera;
        imagePicker.modalTransitionStyle    = UIModalTransitionStyleCoverVertical;
        imagePicker.allowsEditing = YES;
        
        [self.ParentViewControll presentViewController:imagePicker animated:YES completion:nil];
    }
    @catch (NSException *e)
    {
        [self AlertTip:@"当前设备不支持"];
    }
}

#pragma mark ImagePicker Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSURL *refURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *imageAsset)
    {
        ALAssetRepresentation *imageRep = [imageAsset defaultRepresentation];
        
        NSLog(@"%@", [imageRep filename]);
        
        UIImage *img = (UIImage*)[info objectForKey:UIImagePickerControllerEditedImage];
        img = [img fixOrientation];
        NSString *fileName = [imageRep filename];
        if (fileName == nil)
        {
            fileName = @"tempcapt.jpg";
        }
        
        NSString *localFile = [FileUploadHelper PreUploadImagePath:img AndFileName:fileName];
        
        if([localFile isEqualToString:@""])
        {
            [self AlertTip:@"图片获取失败"];
            return;
        }
        
        _IsUploading = YES;
       // self.txtUploadMsg.text = @"图片上传中...";
        
        NSString *pathext = [NSString stringWithFormat:@".%@",[localFile pathExtension]];
        pathext = [pathext lowercaseStringWithLocale:[NSLocale currentLocale]];
        
        NSString *path = [NSString stringWithFormat:@"%@/User/UploadMyIcon",BaseURLString];
        
        NSLog(@"path = %@",path);
        
        NSLog(@"localFile = %@",localFile);
        //NSURL *fileUrl = [NSURL fileURLWithPath:localFile];
        
        [FileUploadHelper FileUploadWithUrl:path FilePath:localFile FileName:fileName Success:^(NSDictionary *result)
        {
            BOOL ret = [[result objectForKey:@"Result"] boolValue];
            if(ret)
            {
                NSString *data = [result objectForKey:@"Data"];
                [RusultManage shareRusultManage].userMode.IconUrl = data;
                NSString *imgPath = [NSString stringWithFormat:@"%@/%@",BaseUserIconPath,data];
               [self.imgUserImage sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"tou"]];
               [[NSNotificationCenter defaultCenter] postNotificationName:kUserIconUpdate object:nil];
            }
        }];
        
        /*
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        //NSDictionary *parameters = @{@"file": @"PNG"};
        
        [manager POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
         {
             [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
         }
              success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             _IsUploading = NO;
             //self.txtUploadMsg.text = @"";
             
             NSDictionary *tmpDic = responseObject;
             NSString *imgPath = [tmpDic objectForKey:@"Data"];
             
            // [self.imgUserImage setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"tou"]];
             [self.imgUserImage sd_setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:@"tou"]];
             
             NSLog(@"Success: %@", [operation responseString]);
         }
              failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             _IsUploading = NO;
           //  self.txtUploadMsg.text = @"图片上传失败";
             NSLog(@"Error: %@", error);
         }];
        */
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:refURL resultBlock:resultblock failureBlock:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreWindowFrame" object:nil];
    [picker dismissViewControllerAnimated:YES completion:^(void)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }];
    
    if (self.popoverCtr) {
        [self.popoverCtr dismissPopoverAnimated:YES];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreWindowFrame" object:nil];
    [picker dismissViewControllerAnimated:YES completion:^(void)
     {
         [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
     }];
}
@end
