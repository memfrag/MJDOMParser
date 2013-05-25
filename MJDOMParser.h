//
//  Copyright (c) 2013 Martin Johannesson
//
//  Permission is hereby granted, free of charge, to any person obtaining a
//  copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense,
//  and/or sell copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
//  DEALINGS IN THE SOFTWARE.
//
//  (MIT License)
//

/**
 * Document Object Model (Core) Level 1
 *
 * http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html#ID-745549614
 */

#import <Foundation/Foundation.h>

typedef enum MJDOMErrorCode {
    MJDOM_INDEX_SIZE_ERR = 1,
    MJDOM_DOMSTRING_SIZE_ERR = 2,
    MJDOM_HIERARCHY_REQUEST_ERR = 3,
    MJDOM_WRONG_DOCUMENT_ERR = 4,
    MJDOM_INVALID_CHARACTER_ERR = 5,
    MJDOM_NO_DATA_ALLOWED_ERR = 6,
    MJDOM_NO_MODIFICATION_ALLOWED_ERR = 7,
    MJDOM_NOT_FOUND_ERR = 8,
    MJDOM_NOT_SUPPORTED_ERR = 9,
    MJDOM_INUSE_ATTRIBUTE_ERR = 10
} MJDOMErrorCode;

typedef enum MJDOMNodeType {
    MJDOM_ELEMENT_NODE = 1,
    MJDOM_ATTRIBUTE_NODE = 2,
    MJDOM_TEXT_NODE = 3,
    MJDOM_CDATA_SECTION_NODE = 4,
    MJDOM_ENTITY_REFERENCE_NODE = 5,
    MJDOM_ENTITY_NODE = 6,
    MJDOM_PROCESSING_INSTRUCTION_NODE = 7,
    MJDOM_COMMENT_NODE = 8,
    MJDOM_DOCUMENT_NODE = 9,
    MJDOM_DOCUMENT_TYPE_NODE = 10,
    MJDOM_DOCUMENT_FRAGMENT_NODE = 11,
    MJDOM_NOTATION_NODE = 12
} MJDOMNodeType;

@protocol MJDOMDocument;

@protocol MJDOMImplementation <NSObject>
- (BOOL)hasFeature:(NSString *)feature version:(NSString *)version;
@end

@protocol MJDOMNode <NSObject>
@property (nonatomic, copy, readonly) NSString *nodeName;
@property (nonatomic, copy) NSString *nodeValue;
@property (nonatomic, assign, readonly) MJDOMNodeType nodeType;
@property (nonatomic, strong, readonly) id<MJDOMNode> parentNode;
@property (nonatomic, strong, readonly) NSArray *childNodes;
@property (nonatomic, strong, readonly) id<MJDOMNode> firstChild;
@property (nonatomic, strong, readonly) id<MJDOMNode> lastChild;
@property (nonatomic, strong, readonly) id<MJDOMNode> previousSibling;
@property (nonatomic, strong, readonly) id<MJDOMNode> nextSibling;
@property (nonatomic, strong, readonly) NSDictionary *attributes;
@property (nonatomic, strong, readonly) id<MJDOMDocument> ownerDocument;
- (id<MJDOMNode>)insertNewChild:(id<MJDOMNode>)newChild beforeChild:(id<MJDOMNode>)child;
- (id<MJDOMNode>)replaceChild:(id<MJDOMNode>)oldChild withNewChild:(id<MJDOMNode>)newChild;
- (id<MJDOMNode>)removeChild:(id<MJDOMNode>)oldChild;
- (id<MJDOMNode>)appendChild:(id<MJDOMNode>)newChild;
- (BOOL)hasChildNodes;
- (id<MJDOMNode>)cloneNodeDeeply:(BOOL)deeply;

// NOT PART OF SPEC
- (id<MJDOMNode>)childByNodeName:(NSString *)name;
@end

@protocol MJDOMDocumentFragment <MJDOMNode>
@end

@protocol MJDOMAttr <MJDOMNode>
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) BOOL specified;
@property (nonatomic, copy) NSString *value;
@end

@protocol MJDOMCharacterData <MJDOMNode>
@property (nonatomic, copy) NSString *data;
@end

@protocol MJDOMElement <MJDOMNode>
@property (nonatomic, copy, readonly) NSString *tagName;
- (NSString *)attributeForName:(NSString *)name;
- (void)setAttributeForName:(NSString *)name value:(NSString *)value;
- (void)removeAttributeWithName:(NSString *)name;
- (id<MJDOMAttr>)attributeNodeWithName:(NSString *)name;
- (id<MJDOMAttr>)setAttributeNode:(id<MJDOMAttr>)newAttr;
- (id<MJDOMAttr>)removeAttributeNode:(id<MJDOMAttr>)oldAttr;
- (NSArray *)elementsByTagName:(NSString *)name;
- (void)normalize;
@end

@protocol MJDOMText <MJDOMCharacterData>
- (id<MJDOMText>)splitTextAtOffset:(NSUInteger)offset;
@end

@protocol MJDOMComment <MJDOMCharacterData>
@end

@protocol MJDOMCDATASection <MJDOMText>
@end

@protocol MJDOMDocumentType <MJDOMNode>
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSDictionary *entities;
@property (nonatomic, strong, readonly) NSDictionary *notations;
@end

@protocol MJDOMNotation <MJDOMNode>
@property (nonatomic, copy, readonly) NSString *publicId;
@property (nonatomic, copy, readonly) NSString *systemId;
@end

@protocol MJDOMEntity <MJDOMNode>
@property (nonatomic, copy, readonly) NSString *publicId;
@property (nonatomic, copy, readonly) NSString *systemId;
@property (nonatomic, copy, readonly) NSString *notationName;
@end

@protocol MJDOMEntityReference <MJDOMNode>
@end

@protocol MJDOMProcessingInstruction <MJDOMNode>
@property (nonatomic, copy, readonly) NSString *target;
@property (nonatomic, copy) NSString *data;
@end

@protocol MJDOMDocument <MJDOMNode>
@property (nonatomic, strong, readonly) id<MJDOMDocumentType> doctype;
@property (nonatomic, strong, readonly) id<MJDOMImplementation> implementation;
@property (nonatomic, strong, readonly) id<MJDOMElement> documentElement;
- (id<MJDOMElement>)createElementWithTagName:(NSString *)tagName;
- (id<MJDOMDocumentFragment>)createDocumentFragment;
- (id<MJDOMText>)createTextNodeWithData:(NSString *)data;
- (id<MJDOMComment>)createCommentWithData:(NSString *)data;
- (id<MJDOMCDATASection>)createCDATASectionWithData:(NSString *)data;
- (id<MJDOMProcessingInstruction>)createProcessingInstructionWithTarget:(NSString *)target
                                                                   data:(NSString *)data;
- (id<MJDOMAttr>)createAttributeWithName:(NSString *)name;
- (id<MJDOMEntityReference>)createEntityReferenceWithName:(NSString *)name;
- (NSArray *)elementsByTagName:(NSString *)tagname;

// NOT PART OF SPEC
- (id<MJDOMNode>)nodeAtPath:(NSString *)nodePath;
- (id<MJDOMNode>)nodeAtArrayPath:(NSArray *)nodePath;

@end

@interface MJDOMParser : NSObject <NSXMLParserDelegate>
- (id<MJDOMDocument>)parseXML:(NSData *)xmlData;
@end
