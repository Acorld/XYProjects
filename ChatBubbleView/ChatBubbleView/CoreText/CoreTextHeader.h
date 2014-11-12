//
//  CoreTextHeader.h
//  ChatBubbleView
//
//  Created by JD_Acorld on 14-9-19.
//  Copyright (c) 2014年 hxy. All rights reserved.
//

#ifndef ChatBubbleView_CoreTextHeader_h
#define ChatBubbleView_CoreTextHeader_h

#import "RegexKitLite.h"
#import "SCGIFImageView.h"
#import "CustomLongPressGestureRecognizer.h"
#import "NSAttributedString+Attributes.h"
#import "MarkupParser.h"
#import "OHAttributedLabel.h"
#import "CustomMethod.h"

#define kPhoneStyle     @"\\d{3}-\\d{8}|\\d{3}-\\d{7}|\\d{4}-\\d{8}|\\d{4}-\\d{7}|1+[358]+\\d{9}|\\d{8}|\\d{7}"
#define kLinkStyle      @"(https?|ftp|file)+://[^\\s]*"
#define kEmailStyle     @"\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*.\\w+([-.]\\w+)*"
#endif
