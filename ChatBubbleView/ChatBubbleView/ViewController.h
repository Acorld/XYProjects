//
//  ViewController.h
//  ChatBubbleView
//
//  Created by JD_Acorld on 14-9-19.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextHeader.h"
@interface ViewController : UIViewController<OHAttributedLabelDelegate,UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    BOOL singleLine;
    int currentIndexRow;
    OHAttributedLabel *currentLabel;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) dispatch_queue_t m_drawImageQueue;
@property (nonatomic, strong) NSMutableArray *m_textArray;
@property (nonatomic, strong) NSMutableDictionary *m_rowHeights;
@property (nonatomic, strong) NSMutableArray *m_labelArray;
@property (nonatomic, strong) NSDictionary *m_emojiDic;

@end
