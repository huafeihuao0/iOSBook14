
#import "NotesTBXMLParser.h"


@implementation NotesTBXMLParser

//开始解析
-(void)startParser
{
    //初始化解析数据的容器
    self.listData = [[NSMutableArray alloc] init];
    
    //初始化TBXML解析器
    TBXML* tbxmlParser = [[TBXML alloc] initWithXMLFile:@"Notes.xml"
                                            error:nil];
    
    TBXMLElement * rootEle = tbxmlParser.rootXMLElement;//获取根元素，作为最高父节点
    
	// 如果root元素有效
	if (rootEle)
    {
        
		TBXMLElement * noteElement = [TBXML childElementNamed:@"Note" parentElement:rootEle];
        
        while ( noteElement != nil)
        {
            //实例化note字典
            NSMutableDictionary *noteDict = [NSMutableDictionary new];
            
            //解析note子元素cdate
            TBXMLElement *dateElement = [TBXML childElementNamed:@"CDate"
                                                   parentElement:noteElement];
            if ( dateElement != nil)
            {
                NSString *date = [TBXML textForElement:dateElement];//获取cdate文本内容
                noteDict[@"CDate"] = date;
            }
            
            //解析note子元素content
            TBXMLElement *contentElement = [TBXML childElementNamed:@"Content"
                                                      parentElement:noteElement];
            if ( contentElement != nil)
            {
                NSString *content = [TBXML textForElement:contentElement];
                noteDict[@"Content"] = content;
            }
            
            //解析note子元素
            TBXMLElement *userIDElement = [TBXML childElementNamed:@"UserID" parentElement:noteElement];
            if ( userIDElement != nil)
            {
                NSString *userID = [TBXML textForElement:userIDElement];
                noteDict[@"UserID"] = userID;
            }
            
            //获得ID属性
            NSString *identifier = [TBXML valueOfAttributeNamed:@"id" forElement:noteElement error:nil];
            noteDict[@"id"] = identifier;
            
            [self.listData addObject:noteDict];
            
            //继续遍历下一个兄弟节点
            noteElement = [TBXML nextSiblingNamed:@"Note"
                                searchFromElement:noteElement];
            
		}
    }
    
    NSLog(@"TBXML解析完成...");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadViewNotification"
                                                        object:self.listData
                                                      userInfo:nil];
    self.listData = nil;
    
}


@end
