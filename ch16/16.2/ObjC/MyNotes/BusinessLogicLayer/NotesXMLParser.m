#import "NotesXMLParser.h"

@implementation NotesXMLParser

/***
 * 开始解析
 ****/
- (void)startParser
{
    //获取xml数据文件的url
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"Notes"
                                                        ofType:@"xml"];
    NSURL *xmlDataUrl = [NSURL fileURLWithPath:xmlPath];
    
    //初始化解析器
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:xmlDataUrl];
    parser.delegate = self;
    
    //启动解析过程，会回调代理的各个回调函数
    [parser parse];
}


#pragma mark --  【NSXMLParser委托】
//文档开始的时候触发
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    //初始化数据数组
    self.listData = [[NSMutableArray alloc] init];
}

//文档出错的时候触发
- (void)parser:(NSXMLParser *)parser
        parseErrorOccurred:(NSError *)parseError//解析异常
{
    NSLog(@"%@", parseError);
}

//遇到一个开始标签时候触发
- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName //扫描到的标签名
  namespaceURI:(NSString *)namespaceURI //命名空间
 qualifiedName:(NSString *)qualifiedName //完全限定名
    attributes:(NSDictionary *)attributeDict  //该元素对应的属性集
{

    self.currentTagName = elementName;//保存正在解析的标签名
    
    if ([self.currentTagName isEqualToString:@"Note"])
    {
        NSString *identifier = [attributeDict objectForKey:@"id"];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:identifier forKey:@"id"];
        
        [self.listData addObject:dict];
    }

}

//遇到字符串时候触发
- (void)parser:(NSXMLParser *)parser
foundCharacters:(NSString *)string //扫描到的字符串
{
    //替换回车符和空格
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([string isEqualToString:@""]) {
        return;
    }
    
    NSMutableDictionary *dict = [self.listData lastObject];

    if ([self.currentTagName isEqualToString:@"CDate"] && dict)
    {
        [dict setObject:string forKey:@"CDate"];
    }

    if ([self.currentTagName isEqualToString:@"Content"] && dict)
    {
        [dict setObject:string forKey:@"Content"];
    }

    if ([self.currentTagName isEqualToString:@"UserID"] && dict)
    {
        [dict setObject:string forKey:@"UserID"];
    }
}

//遇到结束标签时候出发
- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName  //即将结束的标签名
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    self.currentTagName = nil;
}

//遇到文档结束时候触发
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"NSXML解析完成...");
    //通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadViewNotification"    //通知名
                                                        object:self.listData    //携带的数据
                                                      userInfo:nil];
}

@end
