//
//  PPTDownloadViewController.h
//  Java Programming
//
//  Created by way on 14-7-3.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQAsynDownload.h"
#import "PPTDownloadTableCell.h"
#import <QuickLook/QuickLook.h>
@interface PPTDownloadViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>

-(BOOL)searchFile:(NSString *)Filename;

@end
