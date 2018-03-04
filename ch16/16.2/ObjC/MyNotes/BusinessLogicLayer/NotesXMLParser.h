
#import <Foundation/Foundation.h>

@interface NotesXMLParser : NSObject <NSXMLParserDelegate>

//解析出的数据内部是字典类型
@property(strong, nonatomic) NSMutableArray *listData;
//当前标签的名字
@property(strong, nonatomic) NSString *currentTagName;

//开始解析
- (void)startParser;

@end
