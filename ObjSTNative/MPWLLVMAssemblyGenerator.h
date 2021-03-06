//
//  MPWLLVMAssemblyGenerator.h
//  ObjectiveSmalltalk
//
//  Created by Marcel Weiher on 12/26/13.
//
//

#import <MPWFoundation/MPWFoundation.h>

@interface MPWLLVMAssemblyGenerator : MPWByteStream
{
    NSMutableDictionary *selectorReferences;
    int numStrings;
    int numBlocks;
    int numLocals;
    NSString *nsnumberclassref;
}

-(void)writeHeaderWithName:(NSString*)name;
-(void)writeExternalReferenceWithName:(NSString*)name type:(NSString*)type;
-(void)writeClassWithName:(NSString*)aName superclassName:(NSString*)superclassName instanceMethodListRef:(NSString*)instanceMethodListSymbol numInstanceMethods:(int)numInstanceMethods;
-(void)writeTrailer;
-(void)writeCategoryNamed:(NSString*)categoryName ofClass:(NSString*)aName instanceMethodListRef:(NSString*)instanceMethodListSymbol numInstanceMethods:(int)numInstanceMethods;


-(NSString*)methodListForClass:(NSString*)className methodNames:(NSArray*)methodNames methodSymbols:(NSArray*)methodSymbols methodTypes:(NSArray*)typeStrings;

-(NSString*)writeMethodNamed:(NSString*)methodName className:(NSString*)className methodType:(NSString*)methodType additionalParametrs:(NSArray*)params methodBody:(void (^)(MPWLLVMAssemblyGenerator*  ))block;
-(NSString*)stringRef:(NSString*)ref;
-(NSString*)writeNSConstantString:(NSString*)value;
-(NSString*)writeNSNumberLiteralForInt:(NSString*)theIntSymbolOrLiteral;

-(NSString*)emitMsg:(NSString*)msgName receiver:(NSString*)receiverName  returnType:(NSString*)retType args:(NSArray*)args argTypes:(NSArray*)argTypes;

-(void)emitReturnVal:(NSString*)val type:(NSString*)type;


-(void)flushSelectorReferences;

//--- temp/testing

-(NSString*)typeToLLVMType:(char)typeChar;


@end

@interface MPWLLVMAssemblyGenerator(testSupport)



-(NSString*)writeConstMethod1:(NSString*)className methodName:(NSString*)methodName methodType:(NSString*)typeString;
-(NSString*)writeStringSplitter:(NSString*)className methodName:(NSString*)methodName methodType:(NSString*)typeString splitString:(NSString*)splitString;
-(NSString*)writeMakeNumberFromArg:(NSString*)className methodName:(NSString*)methodName;
-(NSString*)writeMakeNumber:(int)aNumber className:(NSString*)className methodName:(NSString*)methodName;
-(NSString*)writeUseBlockClassName:(NSString*)className methodName:(NSString*)methodName;
-(NSString*)writeCreateBlockClassName:(NSString*)className methodName:(NSString*)methodName userMessageName:(NSString*)userMessageName;

-(NSString*)writeCreateStackBlockWithVariableCaptureClassName:(NSString*)className methodName:(NSString*)methodName;


@end
