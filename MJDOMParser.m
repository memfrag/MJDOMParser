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

#import "MJDOMParser.h"

@class MJDOMAttrImpl;

#pragma mark - MJDOMImplementationImpl

@interface MJDOMImplementationImpl : NSObject <MJDOMImplementation>
@end

@implementation MJDOMImplementationImpl

- (BOOL)hasFeature:(NSString *)feature version:(NSString *)version
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me
    return NO;
}

@end

#pragma mark - MJDOMNodeImpl

@interface MJDOMNodeImpl : NSObject <MJDOMNode>
@property (nonatomic, copy) NSString *nodeName;
@property (nonatomic, assign) MJDOMNodeType nodeType;
@property (nonatomic, strong) id<MJDOMNode> parentNode;
@property (nonatomic, strong) id<MJDOMDocument> ownerDocument;
- (id)initWithName:(NSString *)name type:(MJDOMNodeType)type value:(NSString *)value;
@end

@implementation MJDOMNodeImpl {
    NSMutableArray *_childNodes;
    NSMutableDictionary *_attributes;
}

@synthesize nodeValue = _nodeValue;

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithName:type:value:");
    return nil;
}

- (id)initWithName:(NSString *)name type:(MJDOMNodeType)type value:(NSString *)value
{
    self = [super init];
    if (self) {
        _nodeName = [name copy];
        _nodeType = type;
        _nodeValue = [value copy];
        _childNodes = [NSMutableArray array];
        _attributes = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray *)childNodes
{
    return _childNodes;
}

- (NSDictionary *)attributes
{
    return _attributes;
}

- (id<MJDOMNode>)firstChild
{
    if (_childNodes.count == 0) {
        return nil;
    } else {
        return _childNodes[0];
    }
}

- (id<MJDOMNode>)lastChild
{
    if (_childNodes.count == 0) {
        return nil;
    } else {
        return [_childNodes lastObject];
    }
}

- (id<MJDOMNode>)previousSibling
{
    if (self.parentNode) {
        NSUInteger index = [self.parentNode.childNodes indexOfObject:self];
        if (index != NSNotFound && index > 0) {
            return [self.parentNode.childNodes objectAtIndex:(index - 1)];
        }
    }
    return nil;
}

- (id<MJDOMNode>)nextSibling
{
    if (self.parentNode) {
        NSUInteger index = [self.parentNode.childNodes indexOfObject:self];
        if (index != NSNotFound && index < self.parentNode.childNodes.count - 1) {
            return [self.parentNode.childNodes objectAtIndex:(index + 1)];
        }
    }
    return nil;
}

- (BOOL)nodeAllowedAsChild:(id<MJDOMNode>)potentialChild
{
    if (potentialChild.nodeType == MJDOM_ATTRIBUTE_NODE) {
        NSAssert(NO, @"Attribute nodes cannot be child nodes.");
        return NO;
    } else if (potentialChild.nodeType == MJDOM_DOCUMENT_NODE) {
        NSAssert(NO, @"Document nodes cannot be child nodes.");
        return NO;
    } else if (potentialChild.nodeType == MJDOM_DOCUMENT_FRAGMENT_NODE) {
        // FIXME: Implement this condition
        NSAssert(NO, @"Document fragment nodes are not implemented yet.");
        return NO;
    } else {
        return YES;
    }
}

- (id<MJDOMNode>)insertNewChild:(id<MJDOMNode>)newChild beforeChild:(id<MJDOMNode>)child
{
    if (![self nodeAllowedAsChild:newChild]) {
        return nil;
    }
    
    if (child == nil) {
        [_childNodes addObject:child];
        ((MJDOMNodeImpl *)newChild).parentNode = self;
        return newChild;
    }
        
    NSUInteger index = [_childNodes indexOfObject:child];
    if (index == NSNotFound) {
        return nil;
    }
    
    [_childNodes insertObject:newChild atIndex:index];
    ((MJDOMNodeImpl *)newChild).parentNode = self;
    
    return newChild;
}

- (id<MJDOMNode>)replaceChild:(id<MJDOMNode>)oldChild withNewChild:(id<MJDOMNode>)newChild
{
    if (![self nodeAllowedAsChild:newChild]) {
        return nil;
    }

    if (newChild.parentNode) {
        [newChild.parentNode removeChild:newChild];
    }
    
    NSUInteger index = [_childNodes indexOfObject:oldChild];
    if (index == NSNotFound) {
        // FIXME: Indicate error better
        return nil;
    }
    [_childNodes replaceObjectAtIndex:index withObject:newChild];
    ((MJDOMNodeImpl *)oldChild).parentNode = nil;
    ((MJDOMNodeImpl *)newChild).parentNode = self;
    
    return oldChild;
}

- (id<MJDOMNode>)removeChild:(id<MJDOMNode>)oldChild
{
    [_childNodes removeObject:oldChild];
    // FIXME: Is there a better way to do this that doesn't require that
    //        we know implementation details?
    ((MJDOMNodeImpl *)oldChild).parentNode = nil;
    return oldChild;
}

- (id<MJDOMNode>)appendChild:(id<MJDOMNode>)newChild
{
    if (![self nodeAllowedAsChild:newChild]) {
        return nil;
    }

    if (newChild.parentNode) {
        [newChild.parentNode removeChild:newChild];
    }
    
    [_childNodes addObject:newChild];
    ((MJDOMNodeImpl *)newChild).parentNode = self;
    
    return newChild;
}

- (BOOL)hasChildNodes
{
    return _childNodes.count > 0;
}

- (id<MJDOMNode>)cloneNodeDeeply:(BOOL)deeply
{
    NSAssert(NO, @"%s: Node cloning not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement condition
    return nil;
}

- (id<MJDOMAttr>)internalSetAttributeNode:(id<MJDOMAttr>)newAttr
{
    [_attributes setObject:newAttr forKey:newAttr.name];
    return newAttr;
}

- (id<MJDOMAttr>)internalRemoveAttributeNode:(id<MJDOMAttr>)oldAttr
{
    [_attributes removeObjectForKey:oldAttr.name];
    return oldAttr;
}

// NOT PART OF SPEC

- (id<MJDOMNode>)childByNodeName:(NSString *)childName
{
    for (id<MJDOMNode> node in _childNodes) {
        if ([node.nodeName isEqualToString:childName]) {
            return node;
        }
    }
    
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@>", _nodeName];
}

@end

#pragma mark - MJDOMDocumentFragmentImpl

@interface MJDOMDocumentFragmentImpl : MJDOMNodeImpl <MJDOMDocumentFragment>
@end

@implementation MJDOMDocumentFragmentImpl
- (id)init
{
    self = [super initWithName:@"#document-fragment" type:MJDOM_DOCUMENT_FRAGMENT_NODE value:nil];
    if (self) {
        
    }
    return self;
}
@end

#pragma mark - MJDOMAttrImpl

@interface MJDOMAttrImpl : MJDOMNodeImpl <MJDOMAttr>
@property (nonatomic, assign) BOOL specified;
- (id)initWithName:(NSString *)name;
@end

@implementation MJDOMAttrImpl
@synthesize value = _value;

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithName:");
    return nil;
}

- (id)initWithName:(NSString *)name
{
    self = [super initWithName:name type:MJDOM_ATTRIBUTE_NODE value:nil];
    if (self) {
        
    }
    return self;
}

- (NSString *)name
{
    return self.nodeName;
}

@end

#pragma mark - MJDOMCharacterDataImpl

@interface MJDOMCharacterDataImpl : MJDOMNodeImpl <MJDOMCharacterData>
- (id)initWithName:(NSString *)name type:(MJDOMNodeType)type value:(NSString *)value;
@end

@implementation MJDOMCharacterDataImpl
@synthesize data = _data;

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithName:type:value:");
    return nil;
}

- (id)initWithName:(NSString *)name type:(MJDOMNodeType)type value:(NSString *)value
{
    self = [super initWithName:name type:type value:value];
    if (self) {
        _data = [value copy];
    }
    return self;
}

@end

#pragma mark - MJDOMElementImpl

@interface MJDOMElementImpl : MJDOMNodeImpl <MJDOMElement>
- (id)initWithTagName:(NSString *)tagName;
@end

@implementation MJDOMElementImpl
@synthesize tagName = _tagName;

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithTagName:");
    return nil;
}

- (id)initWithTagName:(NSString *)tagName
{
    self = [super initWithName:tagName type:MJDOM_ELEMENT_NODE value:nil];
    if (self) {
    }
    return self;
}

- (NSString *)attributeForName:(NSString *)name
{
    MJDOMAttrImpl *attribute = [self attributeNodeWithName:name];
    if (attribute) {
        return attribute.value;
    } else {
        return nil;
    }
}

- (void)setAttributeForName:(NSString *)name value:(NSString *)value
{
    MJDOMAttrImpl *attribute = [self attributeNodeWithName:name];
    if (attribute) {
        attribute.value = value;
    } else {
        attribute = [self.ownerDocument createAttributeWithName:name];
        attribute.value = value;
        [self setAttributeNode:attribute];
    }
}

- (void)removeAttributeWithName:(NSString *)name
{
    MJDOMAttrImpl *attribute = self.attributes[name];
    if (attribute) {
        [self removeAttributeNode:attribute];
    }
}

- (id<MJDOMAttr>)attributeNodeWithName:(NSString *)name
{
    MJDOMAttrImpl *attribute = self.attributes[name];
    if (attribute) {
        return attribute;
    } else {
        return nil;
    }
}

- (id<MJDOMAttr>)setAttributeNode:(id<MJDOMAttr>)newAttr
{
    [self removeAttributeWithName:newAttr.name];
    [self internalSetAttributeNode:newAttr];
    return newAttr;
}

- (id<MJDOMAttr>)removeAttributeNode:(id<MJDOMAttr>)oldAttr
{
    [self internalRemoveAttributeNode:oldAttr];
    return oldAttr;
}

- (NSArray *)elementsByTagName:(NSString *)name
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me
    return nil;
}

- (void)normalize
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me
}

@end

#pragma mark - MJDOMTextImpl

@interface MJDOMTextImpl : MJDOMCharacterDataImpl <MJDOMText>
- (id)initWithData:(NSString *)data;
@end

@implementation MJDOMTextImpl

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithData;");
    return nil;
}

- (id)initWithData:(NSString *)data
{
    self = [super initWithName:@"#text" type:MJDOM_TEXT_NODE value:data];
    if (self) {

    }
    return self;
}

- (id<MJDOMText>)splitTextAtOffset:(NSUInteger)offset
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me
    return nil;
}

@end

#pragma mark - MJDOMCommentImpl

@interface MJDOMCommentImpl : MJDOMCharacterDataImpl <MJDOMComment>
- (id)initWithData:(NSString *)data;
@end

@implementation MJDOMCommentImpl

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithData:");
    return nil;
}

- (id)initWithData:(NSString *)data
{
    self = [super initWithName:@"#comment" type:MJDOM_COMMENT_NODE value:data];
    if (self) {
        
    }
    return self;
}

@end

#pragma mark - MJDOMCDATASectionImpl

@interface MJDOMCDATASectionImpl : MJDOMTextImpl <MJDOMCDATASection>
- (id)initWithData:(NSString *)data;
@end

@implementation MJDOMCDATASectionImpl

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithData:");
    return nil;
}

- (id)initWithData:(NSString *)data
{
    self = [super initWithName:@"#cdata-section" type:MJDOM_CDATA_SECTION_NODE value:data];
    if (self) {
        
    }
    return self;
}
@end

#pragma mark - MJDOMDocumentTypeImpl

@interface MJDOMDocumentTypeImpl : MJDOMNodeImpl <MJDOMDocumentType>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDictionary *entities;
@property (nonatomic, strong) NSDictionary *notations;
- (id)initWithName:(NSString *)name;
@end

@implementation MJDOMDocumentTypeImpl

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithName:");
    return nil;
}

- (id)initWithName:(NSString *)name
{
    self = [super initWithName:name type:MJDOM_DOCUMENT_TYPE_NODE value:nil];
    if (self) {
        _name = [name copy];
    }
    return self;
}
@end

#pragma mark - MJDOMNotationImpl

@interface MJDOMNotationImpl : MJDOMNodeImpl <MJDOMNotation>
@property (nonatomic, copy) NSString *publicId;
@property (nonatomic, copy) NSString *systemId;
- (id)initWithName:(NSString *)name;
@end

@implementation MJDOMNotationImpl

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithName:");
    return nil;
}

- (id)initWithName:(NSString *)name
{
    self = [super initWithName:name type:MJDOM_NOTATION_NODE value:nil];
    if (self) {
    }
    return self;
}
@end

#pragma mark - MJDOMEntityImpl

@interface MJDOMEntityImpl : MJDOMNodeImpl <MJDOMEntity>
@property (nonatomic, copy) NSString *publicId;
@property (nonatomic, copy) NSString *systemId;
@property (nonatomic, copy) NSString *notationName;
- (id)initWithEntityName:(NSString *)entityName;
@end

@implementation MJDOMEntityImpl

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithEntityName:");
    return nil;
}

- (id)initWithEntityName:(NSString *)entityName
{
    self = [super initWithName:entityName type:MJDOM_ENTITY_NODE value:nil];
    if (self) {
    }
    return self;
}

@end

#pragma mark - MJDOMEntityReferenceImpl

@interface MJDOMEntityReferenceImpl : MJDOMNodeImpl <MJDOMEntityReference>
- (id)initWithReferencedEntityName:(NSString *)name;
@end

@implementation MJDOMEntityReferenceImpl

// TODO: Figure out what this class is meant to do exactly.

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithReferencedEntityName:");
    return nil;
}

- (id)initWithReferencedEntityName:(NSString *)name
{
    self = [super initWithName:name type:MJDOM_ENTITY_REFERENCE_NODE value:nil];
    if (self) {
    }
    return self;
}

@end

#pragma mark - MJDOMProcessingInstructionImpl

@interface MJDOMProcessingInstructionImpl : MJDOMNodeImpl <MJDOMProcessingInstruction>
@property (nonatomic, copy) NSString *target;
- (id)initWithTarget:(NSString *)target data:(NSString *)data;
@end

@implementation MJDOMProcessingInstructionImpl
@synthesize data = _data;

- (id)init
{
    // This should not be called.
    NSAssert(NO, @"Use the designated initialized initWithName:type:value:");
    return nil;
}

- (id)initWithTarget:(NSString *)target data:(NSString *)data
{
    self = [super initWithName:target type:MJDOM_ENTITY_REFERENCE_NODE value:data];
    if (self) {
        _target = [target copy];
        _data = [data copy];
    }
    return self;
}

@end

#pragma mark - MJDOMDocumentImpl

@interface MJDOMDocumentImpl : MJDOMNodeImpl <MJDOMDocument>
@property (nonatomic, strong) id<MJDOMDocumentType> doctype;
@property (nonatomic, strong) id<MJDOMImplementation> implementation;
@property (nonatomic, strong) id<MJDOMElement> documentElement;
@end

@implementation MJDOMDocumentImpl

- (id)init
{
    self = [super initWithName:@"#document" type:MJDOM_DOCUMENT_NODE value:nil];
    if (self) {
        
    }
    return self;
}

- (id<MJDOMElement>)createElementWithTagName:(NSString *)tagName
{
    MJDOMElementImpl *element = [[MJDOMElementImpl alloc] initWithTagName:tagName];
    element.ownerDocument = self;
    return element;
}

- (id<MJDOMDocumentFragment>)createDocumentFragment
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me
    return nil;
}

- (id<MJDOMText>)createTextNodeWithData:(NSString *)data
{
    MJDOMTextImpl *textNode = [[MJDOMTextImpl alloc] initWithData:data];
    textNode.ownerDocument = self;
    return textNode;
}

- (id<MJDOMComment>)createCommentWithData:(NSString *)data
{
    MJDOMCommentImpl *commentNode = [[MJDOMCommentImpl alloc] initWithData:data];
    commentNode.ownerDocument = self;
    return commentNode;
}

- (id<MJDOMCDATASection>)createCDATASectionWithData:(NSString *)data
{
    MJDOMCDATASectionImpl *cdataNode = [[MJDOMCDATASectionImpl alloc] initWithData:data];
    cdataNode.ownerDocument = self;
    return cdataNode;
}

- (id<MJDOMProcessingInstruction>)createProcessingInstructionWithTarget:(NSString *)target
                                                                   data:(NSString *)data
{
    MJDOMProcessingInstructionImpl *processingInstruction = [[MJDOMProcessingInstructionImpl alloc]
                                                             initWithTarget:target data:data];
    processingInstruction.ownerDocument = self;
    return processingInstruction;
}

- (id<MJDOMAttr>)createAttributeWithName:(NSString *)name
{
    MJDOMAttrImpl *attribute = [[MJDOMAttrImpl alloc] initWithName:name];
    attribute.ownerDocument = self;
    return attribute;
}

- (id<MJDOMEntityReference>)createEntityReferenceWithName:(NSString *)name
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me
    return nil;
}

- (NSArray *)elementsByTagName:(NSString *)tagname
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me
    return nil;
}

// NOT PART OF SPEC

- (id<MJDOMNode>)nodeAtPath:(NSString *)nodePath
{
    return [self nodeAtArrayPath:[nodePath componentsSeparatedByString:@"/"]];
}


- (id<MJDOMNode>)nodeAtArrayPath:(NSArray *)nodePath
{
    id<MJDOMNode> node = self;
    
    for (NSString *name in nodePath) {
        id<MJDOMNode> childNode = [node childByNodeName:name];
        if (childNode) {
            node = childNode;
        } else {
            return nil;
        }
    }
    
    return node;
}


@end

#pragma mark - MJDOMParser

@implementation MJDOMParser {
    MJDOMDocumentImpl *_document;
    MJDOMDocumentImpl *_finishedDocument;
    MJDOMNodeImpl *_parentNode;
    NSMutableString *_currentString;
}

- (id<MJDOMDocument>)parseXML:(NSData *)xmlData
{
    @synchronized (self) {
        
        _finishedDocument = nil;
        
        NSXMLParser *xmlParser = [self xmlParserWithData:xmlData];
        [xmlParser setDelegate:self];
        
        (void)[xmlParser parse];
        return _finishedDocument;
        
    }
}

- (NSXMLParser *)xmlParserWithData:(NSData *)xmlData
{
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    [xmlParser setShouldProcessNamespaces:NO]; // FIXME: YES, later
    [xmlParser setShouldReportNamespacePrefixes:NO]; // FIXME: YES, later
    [xmlParser setShouldResolveExternalEntities:NO];
    return xmlParser;
}

#pragma mark - MJDOMParser - XML Parser Delegate

// sent when the parser begins parsing of the document.
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    _document = [[MJDOMDocumentImpl alloc] init];
    _parentNode = _document;
}

// sent when the parser has completed parsing. If this is encountered, the parse was successful.
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    _finishedDocument = _document;
}

// DTD handling methods for various declarations.
/*
- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
    
}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName
{
    
}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue
{
    
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model
{
    
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value
{
    
}

- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID
{
    
}
*/

- (void)addParsedNode:(MJDOMNodeImpl *)node
{
    if (_currentString) {
        MJDOMTextImpl *textNode = [_document createTextNodeWithData:_currentString];
        [_parentNode appendChild:textNode];
        _currentString = nil;
    }
    [_parentNode appendChild:node];
}

// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    MJDOMElementImpl *element = [_document createElementWithTagName:elementName];
    
    for (NSString *name in attributeDict) {
        NSString *value = attributeDict[name];
        MJDOMAttrImpl *attribute =[_document createAttributeWithName:name];
        attribute.value = value;
        [element setAttributeNode:attribute];
    }
    
    [self addParsedNode:element];
    _parentNode = element;
}

// sent when an end tag is encountered. The various parameters are supplied as above.
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (_currentString) {
        MJDOMTextImpl *textNode = [_document createTextNodeWithData:_currentString];
        [_parentNode appendChild:textNode];
        _currentString = nil;
    }
    _parentNode = _parentNode.parentNode;
}

// sent when the parser first sees a namespace attribute.
// In the case of the cvslog tag, before the didStartElement:, you'd get one of these with prefix == @"" and namespaceURI == @"http://xml.apple.com/cvslog" (i.e. the default namespace)
// In the case of the radar:radar tag, before the didStartElement: you'd get one of these with prefix == @"radar" and namespaceURI == @"http://xml.apple.com/radar"
- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me
}

// sent when the namespace prefix in question goes out of scope.
- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix
{
    NSAssert(NO, @"%s: Not implemented yet.", __PRETTY_FUNCTION__);
    // FIXME: Implement me

}

// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!_currentString) {
        _currentString = [NSMutableString stringWithCapacity:string.length];
    }
    [_currentString appendString:string];
}

// The parser reports ignorable whitespace in the same way as characters it's found.
- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString
{
    // FIXME: Implement me
    
}

// The parser reports a processing instruction to you using this method. In the case above, target == @"xml-stylesheet" and data == @"type='text/css' href='cvslog.css'"
- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data
{
    MJDOMProcessingInstructionImpl *piNode = [_document createProcessingInstructionWithTarget:target data:data];
    [self addParsedNode:piNode];
}

// A comment (Text in a <!-- --> block) is reported to the delegate as a single string
- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment
{
    MJDOMCommentImpl *commentNode = [_document createCommentWithData:comment];
    [self addParsedNode:commentNode];
}

// this reports a CDATA block to the delegate as an NSData.
- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    // FIXME: How to handle data?
    NSString *data = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    MJDOMCDATASectionImpl *cdataNode = [_document createCDATASectionWithData:data];
    [self addParsedNode:cdataNode];
}

// this gives the delegate an opportunity to resolve an external entity itself and reply with the resulting data.
/*
- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(NSString *)systemID
{
    
}
*/

// ...and this reports a fatal error to the delegate. The parser will stop parsing.
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    // FIXME: Implement me
    NSLog(@"Parser error: %@", [parseError localizedDescription]);
}

// If validation is on, this will report a fatal validation error to the delegate. The parser will stop parsing.
- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError
{
    // FIXME: Implement me
    NSLog(@"Validation error: %@", [validationError localizedDescription]);
}

@end
