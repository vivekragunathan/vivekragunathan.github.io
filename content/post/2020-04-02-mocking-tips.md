---
title: Pattern for Saner Mocking
author: vivekragunathan
layout: post
date: 2020-04-02
url: /2020/04/02/saner-mocking
categories:
  - Scala
  - Functional-Programming
---

It is common to see mocks being setup this way in unit tests.

```scala
scenario("Test Case 1") {
	...
	when(addressResolutionService.resolve(...)).thenReturn(...)
	when(vendorInventoryService.checkInventory(...)).thenReturn(...)
	...
	.... another bunch of when and then returns
	when(shipmentService.schedule(...)).thenReturn(...)

	...thisIsTheActualCalltoTest(...)

	verify(vendorInventoryService, 1).checkInventory(...)
	... other such verifications
}

scenario("Test Case 2") {
	...
	when(addressResolutionService.resolve(...)).thenReturn(...)
	when(vendorInventoryService.checkInventory(...)).thenReturn(...)
	...
	.... another bunch of when and then returns ...give or take one or more mocks compared to the previous test ...
	when(shipmentService.schedule(...)).thenReturn(...)

	...thisIsTheActualCalltoTest(...)

	verify(vendorInventoryService, 1).checkInventory(...)
	... other such verifications
}

... other such test cases
```

<!--more-->

See something wrong? _Why would do someone write a test with all such services gobbled together in a test?_ Well, that is not the problem and definitely not the topic of this post. The example is arbitrary just to establish the complexity involved in writing such test cases; especially mock-ridden.

My problem is with the way the mocks are being setup. In a typical business application, there are tens of test cases for a given scenario. Each such test might differ in the inputs or other external factors such as configuration etc. It is a typical in such test suites for repeating these mock setups over and over. Yeah, you might throw in a helper method to setup some of the mocks. But let me assure that such helper methods will go outdated or crammed with other irrelevant mocks in no time clouding the original purpose for writing the helper. Or you might end up with a whole bunch of helpers that setup mocks for various cases in question with little differences. I am not even going to talk about the mock `reset`s scattered or sneaked in places leaving you wonder why.

Instead of helpers, we need a mechanism where setting up the mocks inline within the test is not a problem for us. It should completely strip down the cognitive overload involved in comprehending the setting up of mocks. The other problem we like to get rid of is explicitly `reset` mocks.

Let me first share the way I have been practicing for dealing with setting up mocks. And it has worked really well for me.

```scala
import cats.syntax.either._

final case class AddressResolutionMockBuilder(/*any args if required*/) extends LazyLogging {

  val addressServiceMock: AddressResolutionService =
  	mock[AddressResolutionService]

  def resolve(address: String, result: Address): AddressResolutionMockBuilder = {
		when(addressServiceMock.resolve(address)).thenReturn(result.asRight)
		this
	}

  def resolve(address: String, error: Throwable): AddressResolutionMockBuilder = {
  	when(addressServiceMock.resolve(address)).thenReturn(result.asLeft)
  	this
  }

  def resolve(
    address: String,
    result: Either[Throwable, Address]
  ): AddressResolutionMockBuilder = {
  	when(addressServiceMock.resolve(address)).thenReturn(result)
  	this
	}

	def geoLocation(address: String, result: LatLong): AddressResolutionMockBuilder = {
		when(addressServiceMock.geoLocation(address)).thenReturn(result)
		this
	}

	...

	def verifyResolveCalledOnce(withInput: String): AddressResolutionMockBuilder = {
		verify(addressServiceMock, times(1)).resolve(withInput)
		this
	}

	... other verifyXXX methods ...
}
```

Before you are overwhelmed ... here is how your test case is going to look like from now on ...

```scala
scenario("Test Case 1") {
	val addressText     = "...address.."
	val mockAddress = Address(...)
	val mockLatLong = LatLong(...)

	val addressResolutionMock =
		AddressResolutionMockBuilder()
			.resolve(addressText, mockAddress)
			.geoLocation(mockAddress, mockLatLong)

	val result: Option[....] =
		...thisIsTheActualCalltoTest(...)

	addressResolutionMock
		.verifyResolveCalledOnce(mockAddress)
		.verifyGeoLocationCalledOnce(mockLatLong)
		.verifyNormalizeAddressNeverCalled()

	Inside.inside(result) {
		case Some(...) =>
			....
	}
}
```

We create a mock builder class that provides different overloads (as necessary) of the functions you need to mock. We need name these functions same as the original class. That way you won't have to squint what is being mocked. We also provide functions for verifying either calls are made as expected or never made. We use explicit names if a function is expected to called once or never. We allow chaining the functions in our mock builder so that we could use them like a breeze.

If you were overwhelmed earlier with the different overloads for the functions being mocked, it is for the better. Also, it could be the case you need not certain overloads; not so common though. The overloads highly help reduce the noise in your test case code, and you write the mock builder once for all of your test case classes.

I am hopeful that you are convinced with the explanation and taking a look at the above code using the mock builder.

On to the second part of not having to call `reset` explicitly. This is something I learnt from my current [team](https://techblog.livongo.com). The idea is to keep all the entities that a test case depends on local to the test case. The test case is stateless so to speak. It has access to the data and configuration required but does not depend on any state initialized or mutated outside the test case. Think of it as another way of implementing `beforeEach`.

```scala
trait UnitTestEnv {

	val addressResolutionMockBuilder = AddressResolutionMockBuilder(...)

	// Other mock builder and data dependencies ...
}

final class MyTestSuite extends FeatureSpec with MustMatchers ... {
	feature ("....") must {
		scenario ("....") in UnitTestEnv() {

			addressResolutionMockBuilder
				.resolve(addressText, mockAddress)
				.geoLocation(mockAddress, mockLatLong)

			val result: Option[....] =
				...thisIsTheActualCalltoTest(...)

			addressResolutionMockBuilder
				.verifyResolveCalledOnce(mockAddress)
				.verifyGeoLocationCalledOnce(mockLatLong)
				.verifyNormalizeAddressNeverCalled()

			Inside.inside(result) {
				case Some(...) =>
					....
			}
		}
	}
}
```

The `UnitTestEnv` acts as a `beforeEach` but keeping it stateless. The `addressResolutionMockBuilder` and other data dependencies are tore down when the test case completes. The next test case using `UnitTestEnv` gets a fresh copy of the dependencies essentially removing the need to call `reset`. Isn't that something?

Give it a shot. I am sure you will like it.

**Final Thoughts**

- The pattern above is not constrained to Scala. It can be applied to Java with some syntactic oddities. Despite that the test case code will definitely look a lot better.
- I have not discussed about scenarios where you have to mock for repeated calls; with the same or different arguments. I have come across mocking repeated calls to a certain function with the same arguments a few times. But not so much mocking repeated calls with different arguments each time. Either way, it is not particularly hard and accommodated by relevant overloads.
