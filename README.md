stubble
=======

An iOS mocking framework in the spirit of Mockito.

Advantages over OCMock:

* Sane syntax

Using stubble
=======

Project Setup
-------
Stubble can be imported as a subproject in Xcode or as a .framework.

In the build settings for your Test target, under `OtherLinkerFlags` add `-ObjC` and `-all_load`.

Creating a Mock
------

    mock([ClassToMock class]);

### Note with ESCOberserver
If you are using ESCObserver, you'll want to do this to your mock objects:

    ClassToMock<ESCOberserverInternal> *mockClass;

Creating a stub
------

    when([ClassToMock methodToStub] thenReturn:@"string");

### Note with ESCObserver
You can do something like this:

    [mockObject.escNotifier notificationMethod];

Verifying calls
------

    verifyCalled([ClassToMock methodToStub]);