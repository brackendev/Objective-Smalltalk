//
//  MPWBlockContext.m
//  MPWTalk
//
//  Created by Marcel Weiher on 11/22/04.
//  Copyright 2004 Marcel Weiher. All rights reserved.
//

#import "MPWBlockContext.h"
#import "MPWStatementList.h"
#import "MPWEvaluator.h"
#import <MPWFoundation/MPWBlockFilterStream.h>
#import "MPWBinding.h"

@implementation MPWBlockContext

idAccessor( block, setBlock )
idAccessor( context, setContext )

-initWithBlock:aBlock context:aContext
{
	self=[super init];
	[self setBlock:aBlock];
	[self setContext:aContext];
	return self;
}

+blockContextWithBlock:aBlock context:aContext
{
	return [[[self alloc] initWithBlock:aBlock context:aContext] autorelease];
}


-contextClass
{
	id localContextClass=[[self context] class];
	if ( !localContextClass) {
		localContextClass=[MPWEvaluator class];
	}
	return localContextClass;
}


-freshExecutionContextForRealLocalVars
{
    //	NSLog(@"creating new context from context: %@",[self context]);
	MPWEvaluator *evalContext= [[[[self contextClass] alloc] initWithParent:[self context]] autorelease];
    
    
    return evalContext;
}

-evaluationContext
{
#if 0
    return [self context];
#else
    MPWEvaluator *evalContext=[self freshExecutionContextForRealLocalVars];
    return evalContext;
#endif
}


-evaluateIn_block:aContext arguments:(NSArray*)args {
    int numArgs=[args count];
    NSArray *formals=[[self block] arguments];
    numArgs=MIN(numArgs,[formals count]);
    for (int i=0;i<numArgs;i++) {
        MPWBinding *b=[aContext createLocalBindingForName:[formals objectAtIndex:i]];
        [b bindValue:[args objectAtIndex:i]];
//        [aContext bindValue:[args objectAtIndex:i] toVariableNamed:[formals objectAtIndex:i]];
    }
	if ( aContext ) {
		return [aContext evaluate:[[self block] statements]];
	} else {
		return [[[self block] statements] evaluateIn:aContext];
	}
}

-invokeWithArgs:(va_list)args
{
    NSMutableArray *argArray=[NSMutableArray arrayWithCapacity:[[[self block] arguments] count]];
    for ( NSString *paramName in [[self block] arguments] ) {
        [argArray addObject:va_arg(args, id)];
    }
    return [self evaluateIn_block:[self evaluationContext] arguments:argArray];
}

-value
{
	return [self evaluateIn_block:[self evaluationContext] arguments:nil];
}

-value:anObject
{
	return [self evaluateIn_block:[self evaluationContext] arguments:@[ anObject]];
}



-(void)drawOnContext:aContext
{
    [self value:aContext];
}

-whileTrue:anotherBlock
{
    id retval=nil;
	while ( [[self value] boolValue] ) {
		retval=[anotherBlock value];
	}
    return retval;
}

-copyWithZone:aZone
{
    return [self retain];
}

-(void)dealloc
{
	[block release];
	[context release];
	[super dealloc];
}



-defaultComponentInstance

{
    MPWBlockFilterStream *s=[MPWBlockFilterStream stream];
    [s setBlock:self];
    return s;
}




@end

#import "MPWStCompiler.h"

@implementation MPWBlockContext(tests)

+(void)testObjcBlocksWithNoArgsAreMapped
{
    IDEXPECT([MPWStCompiler evaluate:@"a:=0. #( 1 2 3 4 ) enumerateObjectsUsingBlock:[ a := a+1. ]. a."], [NSNumber numberWithInt:4], @"just counted the elements in an array using block enumeration");
}

+(void)testObjcBlocksWithObjectArgsAreMapped
{
    IDEXPECT([MPWStCompiler evaluate:@"a:=0. #( 1 2 3 4 ) enumerateObjectsUsingBlock:[ :obj |  a := a+obj. ]. a."], [NSNumber numberWithInt:10], @"added the elements in an array using block enumeration");
}


+(void)testBlockArgsDontMessWithEnclosingScope
{
    IDEXPECT([MPWStCompiler evaluate:@"a:=3. block:=[:a| a+10]. block value:42. a."], [NSNumber numberWithInt:3], @"local var");
}

+(NSArray*)testSelectors
{
    return [NSArray arrayWithObjects:
            @"testObjcBlocksWithNoArgsAreMapped",
            @"testObjcBlocksWithObjectArgsAreMapped",
            @"testBlockArgsDontMessWithEnclosingScope",
            nil];
}

@end
