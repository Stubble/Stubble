stubble
=======

An iOS mocking framework in the spirit of Mockito.

Using stubble
=======

Project Setup
-------
Stubble can be imported as a subproject in Xcode or as a .framework. If imported as a subproject, make sure you update the Header Search Paths in the build settings for your Test target, and to update the Link Binary With Libraries in Build Phases.

In the build settings for your Test target, under `OtherLinkerFlags` add `-ObjC` and `-all_load`.

Creating a Mock
------

    mock([ClassToMock class]);

### Note with ESCOberserver
If you are using ESCObserver, you'll want to do this to your mock objects:

    ClassToMock<ESCOberserverInternal> *mockClass;

Creating a stub
------

    [when([ClassToMock methodToStub] thenReturn:@"string")];

### Note with ESCObserver
You can do something like this:

    [mockObject.escNotifier notificationMethod];

Verifying calls
------

    verifyCalled([ClassToMock methodToStub]);