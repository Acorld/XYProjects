//
//  ViewController.m
//  ChatBubbleView
//
//  Created by JD_Acorld on 14-9-19.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)configData
{
    self.m_textArray = [NSMutableArray array];
    [self.m_textArray addObject:[CustomMethod escapedString:@"这是一个测试Demo"]];
    [self.m_textArray addObject:[CustomMethod escapedString:@"测试的内容是什么呢？"]];
    [self.m_textArray addObject:[CustomMethod escapedString:@"[大笑][难过][伤心][尴尬][疑惑][喜欢][期待][呆萌][惊讶][生气][害羞][开心]"]];
    [self.m_textArray addObject:[CustomMethod escapedString:@"文字表情同时存在，网址链接，电话链接等等"]];
    [self.m_textArray addObject:[CustomMethod escapedString:@"[大笑]肺结核[难过]韩国的部分就[伤心][尴尬]的风格和部分的[疑惑][喜欢][期待]东方既白国[大笑][大笑]际法的不干净[呆萌][惊讶][生气]大家回复不[伤心]过基本的房[大笑][害羞]间关闭的房间不个[伤心]百分点时刻表[害羞][开心]京东方[伤心][伤心]还不赶紧发的[伤心]是北京的世[伤心]界观的房间"]];
    [self.m_textArray addObject:[CustomMethod escapedString:@"爱到底18092293443修复返回北京的司法鉴定http://www.code4app.com"]];
    [self.m_textArray addObject:[CustomMethod escapedString:@"029-88888888金汉斯[害羞]佛本是道0917-9090909见到你[难过]会计法0917-98293929可拒付深v看029-9829291"]];
    [self.m_textArray addObject:[CustomMethod escapedString:@"发生地方[大开心]法撒旦[大开心]冯绍峰[大开心][大开心][大开心]而威尔额外"]];
    [self.m_textArray addObject:[CustomMethod escapedString:@"测试http://code4app.com/ios/MessageList/5282e8776803faeb61000001"]];
}

- (void)configSelf
{
    NSArray *wk_paceImageNumArray = [[NSArray alloc]initWithObjects:@"emoji_0.png",@"emoji_1.png",@"emoji_2.png",@"emoji_3.png",@"emoji_4.png",@"emoji_5.png",@"emoji_6.png",@"emoji_7.png",@"emoji_8.png",@"emoji_9.png",@"emoji_10.png",@"emoji_11.png", nil];
    NSArray *wk_paceImageNameArray = [[NSArray alloc]initWithObjects:@"[大笑]",@"[难过]",@"[伤心]",@"[尴尬]",@"[疑惑]",@"[喜欢]",@"[期待]",@"[呆萌]",@"[惊讶]",@"[生气]",@"[害羞]",@"[开心]", nil];
    self.m_emojiDic = [[NSDictionary alloc] initWithObjects:wk_paceImageNumArray forKeys:wk_paceImageNameArray];
    
    self.m_labelArray = [NSMutableArray array];
    self.m_rowHeights = [NSMutableDictionary dictionary];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configSelf];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self configData];
}

- (void)resetData
{
    //TODO:其他重置处理
}

- (void)reloadTableView
{
    //TODO:其他刷新处理
    [self.tableView reloadData];
}

- (CGFloat)heightForLabel:(OHAttributedLabel *)label
{
    NSNumber *heightNum = [[NSNumber alloc] initWithFloat:label.frame.size.height];
    return heightNum.floatValue;
}

- (OHAttributedLabel *)addNewMessageForIndex:(NSInteger)index
{
    NSString *msg = [CustomMethod escapedString:self.m_textArray[index]];
    OHAttributedLabel *label = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
    [self creatAttributedLabel:msg Label:label];
    [CustomMethod drawImage:label];
    [self.m_rowHeights setObject:@([self heightForLabel:label]) forKey:@(index)];
    return label;
}

- (void)creatAttributedLabel:(NSString *)o_text Label:(OHAttributedLabel *)label
{
    [label setNeedsDisplay];
    NSMutableArray *httpArr              = [CustomMethod addHttpArr:o_text];
    NSMutableArray *phoneNumArr          = [CustomMethod addPhoneNumArr:o_text];
    NSMutableArray *emailArr             = [CustomMethod addEmailArr:o_text];

    NSString *text                       = [CustomMethod transformString:o_text emojiDic:self.m_emojiDic];
    text                                 = [NSString stringWithFormat:@"<font color='black' strokeColor='gray' face='Palatino-Roman'>%@",text];

    MarkupParser *wk_markupParser        = [[MarkupParser alloc] init];
    NSMutableAttributedString* attString = [wk_markupParser attrStringFromMarkup: text];
    [attString setFont:[UIFont systemFontOfSize:16]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setAttString:attString withImages:wk_markupParser.images];

    NSString *string                     = attString.string;
    //email
    if ([emailArr count])
    {
        for (NSString *emailStr in emailArr)
        {
            [label addCustomLink:[NSURL URLWithString:emailStr] inRange:[string rangeOfString:emailStr]];
        }
    }
    
    //phone
    if ([phoneNumArr count])
    {
        for (NSString *phoneNum in phoneNumArr)
        {
            [label addCustomLink:[NSURL URLWithString:phoneNum] inRange:[string rangeOfString:phoneNum]];
        }
    }
    
    //link
    if ([httpArr count])
    {
        for (NSString *httpStr in httpArr)
        {
            [label addCustomLink:[NSURL URLWithString:httpStr] inRange:[string rangeOfString:httpStr]];
        }
    }
    //点击链接时间回调
    label.delegate        = self;
    CGRect labelRect      = label.frame;
    labelRect.size.width  = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].width;
    labelRect.size.height = [label sizeThatFits:CGSizeMake(200, CGFLOAT_MAX)].height;
    label.frame           = labelRect;
    label.underlineLinks  = YES;//链接是否带下划线
    [label.layer display];
}

#pragma mark -
#pragma -mark ==== OHAttributedLabelDelegate ====
#pragma mark -

- (BOOL)attributedLabel:(OHAttributedLabel *)attributedLabel shouldFollowLink:(NSTextCheckingResult *)linkInfo
{
    NSString *requestString = [linkInfo.URL absoluteString];
    NSLog(@"%@",requestString);
    
    if ([requestString isMatchedByRegex:kPhoneStyle])
    {
        NSLog(@"<.....||Phone||.....>");
    }else if ([requestString isMatchedByRegex:kLinkStyle])
    {
        NSLog(@"<.....||Link||.....>");
    }else if ([requestString isMatchedByRegex:kEmailStyle])
    {
        NSLog(@"<.....||Email||.....>");
    }else
    {
        NSLog(@"<.....||Other||.....>");
    }
    if ([[UIApplication sharedApplication]canOpenURL:linkInfo.URL])
    {
        [[UIApplication sharedApplication]openURL:linkInfo.URL];
    }
    
    return NO;
}

#pragma mark
#pragma mark -  UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.m_textArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.m_rowHeights objectForKey:@(indexPath.row)])
    {
        //如果高度未保存
        [self addNewMessageForIndex:indexPath.row];
    }
    
    if (indexPath.row % 3 == 0)
        return([[self.m_rowHeights objectForKey:@(indexPath.row)] floatValue] + 45);
    else
        return([[self.m_rowHeights objectForKey:@(indexPath.row)] floatValue] + 25);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [[UIView alloc] init];
        view.tag = 201;
        //添加背景图片imageView
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = 202;
        [view addSubview:imageView];
        
        //时间戳
        UILabel *wk_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 15)];
        wk_timeLabel.tag = 199;
        wk_timeLabel.textColor = [UIColor lightGrayColor];
        wk_timeLabel.backgroundColor = [UIColor clearColor];
        wk_timeLabel.textAlignment = NSTextAlignmentCenter;
        wk_timeLabel.font = [UIFont systemFontOfSize:12.0f];
        [cell.contentView addSubview:wk_timeLabel];
        
        UIButton *wk_button = [[UIButton alloc]init];
        wk_button.tag = 198;
        [cell.contentView addSubview:wk_button];
        
        //添加手势
        CustomLongPressGestureRecognizer *wk_longPressGestureRecognizer = [[CustomLongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [wk_longPressGestureRecognizer setMinimumPressDuration:0.5];
        [view addGestureRecognizer:wk_longPressGestureRecognizer];
        [cell.contentView addSubview:view];
        [cell bringSubviewToFront:view];
    }
    
    //重用Cell的时候移除label
    UIView *view = (UIView *)[cell viewWithTag:201];
    view.frame = CGRectMake(20, 0, cell.contentView.frame.size.width-80, [[self.m_rowHeights objectForKey:@(indexPath.row)] floatValue]+20);
    
    for (UIView *subView in [view subviews]) {
        if ([subView isKindOfClass:[OHAttributedLabel class]]) {
            [subView removeFromSuperview];
        }
    }
    
    UILabel *wk_timeLabel = (UILabel *)[cell.contentView viewWithTag:199];
    [wk_timeLabel.superview bringSubviewToFront:wk_timeLabel];
    
    UIButton *wk_button = (UIButton *)[cell.contentView viewWithTag:198];
    [wk_button.superview bringSubviewToFront:wk_button];
    
    UIImage *image;//气泡图片
    float sysVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    //时间戳是否显示
    if (indexPath.row % 3 == 0)
    {
        wk_timeLabel.hidden = NO;
        NSDate *wk_currentTime = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat:@"yyyy-MM-dd  HH:mm:ss"];
        NSString *timeString = [formatter stringFromDate:wk_currentTime];
        wk_timeLabel.text = timeString;
        
        [wk_button setFrame:CGRectMake(5, 25, 35, 35)];
        [wk_button setBackgroundImage:[UIImage imageNamed:@"user_detault_avatar2.jpg"] forState:UIControlStateNormal];
        view.frame = CGRectMake(20, 0, cell.contentView.frame.size.width-80, [[self.m_rowHeights objectForKey:@(indexPath.row)] floatValue]+40);
        
        if (sysVersion < 5.0)
            image = [[UIImage imageNamed:@"message_send_box_other1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        else image = [[UIImage imageNamed:@"message_send_box_other1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20)];
    }else
    {
        wk_timeLabel.hidden = YES;
        [wk_button setFrame:CGRectMake(275, 5, 35, 35)];
        [wk_button setBackgroundImage:[UIImage imageNamed:@"user_detault_avatar1.jpg"] forState:UIControlStateNormal];
        
        if (sysVersion < 5.0)
            image = [[UIImage imageNamed:@"message_send_box_self1.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:30];
        else image = [[UIImage imageNamed:@"message_send_box_self1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 10, 20)];
    }
    
    UIImageView *imageView = (UIImageView *)[view viewWithTag:202];
    imageView.image = image;
    imageView.frame = view.frame;
    
    CustomLongPressGestureRecognizer *recognizer = (CustomLongPressGestureRecognizer *)[view.gestureRecognizers objectAtIndex:0];
    
    //view内添加上label视图
//    OHAttributedLabel *label = [self.m_labelArray objectAtIndex:indexPath.row];
    OHAttributedLabel *label = [self addNewMessageForIndex:indexPath.row];
    [label setCenter:view.center];
    [recognizer setLabel:label];
    
    if (indexPath.row % 3 == 0) {
        label.frame = CGRectMake(view.frame.origin.x+20, view.frame.origin.y+30, recognizer.label.frame.size.width, label.frame.size.height);
        imageView.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y+20, recognizer.label.frame.size.width+40, label.frame.size.height+20);
    }else{
        label.frame = CGRectMake(320-recognizer.label.frame.size.width-70-20, view.frame.origin.y+10, recognizer.label.frame.size.width, label.frame.size.height);
        
        imageView.frame = CGRectMake(label.frame.origin.x-20, view.frame.origin.y, recognizer.label.frame.size.width+40, label.frame.size.height+20);
    }
    
    [view addSubview:label];
    
    return cell;
}

#pragma mark
#pragma mark -  UITableViewDelegate

- (void)longPress:(CustomLongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        currentLabel = gestureRecognizer.label;
        NSIndexPath *pressedIndexPath = [self.tableView indexPathForRowAtPoint:[gestureRecognizer locationInView:self.tableView]];
        currentIndexRow = pressedIndexPath.row;//长按手势在哪个Cell内
        UIAlertView *wk_alertView =  [[UIAlertView alloc] initWithTitle:@"确定复制该消息？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [wk_alertView setTag:100];
        [wk_alertView show];
    }
}

#pragma mark
#pragma mark -  UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
        if (buttonIndex == 1)
        {
            NSString* o_text = [self.m_textArray objectAtIndex:currentIndexRow];//根据Cell Index 获取复制内容
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setString:o_text];
        }
    }
}

@end
