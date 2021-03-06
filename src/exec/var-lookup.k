module VAR-LOOKUP
    imports CORE-SORTS
    imports SUBTYPING
    imports STATIC-INIT         //for staticInit()

//@ \subsection{Local variable access}

/* Local variable access. At runtime may have one form:
    - 'ExprName(X:Id) - local variable
*/


/*@ At execution phase 'ExprName(X) always represent a local variable.
*/
rule [ExprName-local]:
    <k> 'ExprName(X:Id) => typedLookup(L) ...</k>
    <env>... X |-> L:Int ...</env>

rule [lvalue-ExprName-local]:
    <k> lvalue('ExprName(X:Id)) => typedLoc(L) ...</k>
    <env>... X |-> L:Int ...</env>

/*@ \subsection{QThis - Self reference} */

// 'QThis(Class:ClassType)
rule [QThis]:
    <k>
      'QThis(Class:ClassType) => lookupQThis(Class, RV::CrntClass)
      ...
    </k>
    <crntClass> CrntClass:ClassType </crntClass>
    <location> OL:Int </location>
    <store>
      ...
      OL |-> RV:RawVal :: _
      ...
    </store>

//@ Search for the right value representing QThis(Class) - an expression of type Class.this
syntax KItem ::=  lookupQThis (
                ClassType,  //the type of this to look for,
                TypedVal    //the objectRef where the type should be found
              )

rule [lookupQThis-found]:
    lookupQThis(Class:ClassType, RV:RawVal::Class) => RV::Class

/*@ When we have QThis target class Class, and we look for it in a target object with a different
compile-time type ObjClass, we continue our search in the enclosing object of the layer corresponding to ObjClass.
This way we may have O.B < O.A, with layers O.B and O.A having different enclosing instance of O,
and we will be able to pick the correct enclosing object inside both O.A and O.B.
*/
rule [lookupQThis-next]:
    <k>
      lookupQThis(Class:ClassType,
        objectRef(OId:Int, _) :: RefClass:ClassType
      ) => lookupQThis(Class:ClassType, EnclosingObj)
      ...
    </k>
    <objectId> OId </objectId>
    <layerClass> RefClass </layerClass>
    <layerEnclosingObject> EnclosingObj:KResult </layerEnclosingObject>
when
    Class =/=K RefClass

/*@ \subsection{Instance field access} */

/*@ Variable access. May have 2 forms:
    - 'ExprName(Class, X:Id) - static field
    - 'ExprName(Qual, X:Id) - instance field
*/
context 'Field(HOLE,, _)
context lvalue('Field(HOLE,, _))

rule [Field-instance]:
    <k>
      'Field(objectRef(OId:Int, _ ) :: TargetClass:ClassType,, X:Id) => TV
      ...
    </k>
    <objectId> OId </objectId>
    <layerClass> TargetClass </layerClass>
    <layerEnv>... X |-> TV:TypedVal ...</layerEnv>

rule [lvalue-Field-instance]:
    <k>
      lvalue('Field(objectRef(OId:Int, _ ) :: TargetClass:ClassType,, X:Id))
      => fieldloc(OId, TargetClass, X) :: T
      ...
    </k>
    <objectId> OId </objectId>
    <layerClass> TargetClass </layerClass>
    <layerEnv>... X |-> _ :: T:Type ...</layerEnv>

rule [Field-instance-OfNull]:
    'Field(null::_,, _) => throw new classNullPointerException(null::classString);
        [anywhere]

/*@ \subsection{Static field access} */

rule [Field-static]:
    'Field( TargetClass:ClassType,, X:Id )
    => staticInit(TargetClass) ~> staticFieldLookup(TargetClass, X)

rule [lvalue-Field-static]:
    lvalue('Field( TargetClass:ClassType,, X:Id ))
    => staticInit(TargetClass) ~> lvalue(staticFieldLookup(TargetClass, X))

/*@ The actual implementation of static field lookup. The distinction between this function and
    'Field(Class, X) term is that at the moment when this function is called the target clas is
    surely initialized.
*/
syntax KItem ::= staticFieldLookup ( ClassType , Id )

rule [staticFieldLookup]:
    <k>
      staticFieldLookup(TargetClass:ClassType, X:Id) => TV
      ...
    </k>
    <classType> TargetClass </classType>
    <staticEnv>... X |-> TV:TypedVal ...</staticEnv>

rule [lvalue-Field-static]:
    <k>
      lvalue(staticFieldLookup(TargetClass:ClassType, X:Id))
      => fieldloc(TargetClass, X) :: T
      ...
    </k>
    <classType> TargetClass </classType>
    <staticEnv>... X |-> _ :: T:Type ...</staticEnv>

/*@ \subsection{lvalue and loc} */

//@ Typed version of lookup and loc
syntax KItem ::= typedLookup ( Int )

rule [typedLookup]:
    <k> typedLookup(L:Int) => lookup(loc(L), T) ...</k>
    <store>... L |-> _::T:Type ...</store>

rule [lvalue-typedLookup]:
    lvalue( typedLookup(L:Int) ) => typedLoc(L)

syntax KItem ::= typedLoc ( Int )

rule [typedLoc]:
    <k> typedLoc(L:Int) => loc(L)::T ...</k>
    <store>... L |-> _::T:Type ...</store>

rule [lvalue-typedLoc]:
    lvalue(typedLoc(L:Int)) => typedLoc(L)

/*@ \subsection{lookup} */

/*@ Retrieve a value from the store based on its location and the given compile-time type.
  May be wrapped inside lvalue. If lookup is unwrapped, it evaluates to TypedVal - the store value,
  of the type T - the second lookup argument. If lookup is wrapped into lvalue, it evaluates to loc(OL)::T.
*/
syntax Exp ::= lookup (
                    Loc,  //OL - the store location to lookup
                    Type  // T - the compile-time type of the resulting value
                  )

rule lvalue(lookup(L:Loc, T:Type)) => L::T          [structural]

rule [lookup-loc]:
     <k> lookup(loc(L:Int), T1:Type) => subtype(T2, T1) ~> true? ~> (V::T1) ... </k>
     <store>... L |-> V:RawVal :: T2:Type ...</store>

rule [lookup-fieldloc-instance]:
     <k> lookup(fieldloc(OId:Int, TargetClass:ClassType, X:Id), T1:Type) => subtype(T2, T1) ~> true? ~> (V::T1) ... </k>
     <objectId> OId </objectId>
     <layerClass> TargetClass </layerClass>
     <layerEnv> ... X |-> V:RawVal :: T2:Type ... </layerEnv>
     [transition-threading]

rule [lookup-fieldloc-static]:
     <k> lookup(fieldloc(TargetClass:ClassType, X:Id), T1:Type) => subtype(T2, T1) ~> true? ~> (V::T1) ... </k>
     <classType> TargetClass </classType>
     <staticEnv>... X |-> V:RawVal :: T2:Type ...</staticEnv>
     [transition-threading]

endmodule
