# ``PaymentSDK``

PaymentSDK provides easy way for you to make payments.

## Overview

PaymentSDK is easy to use SDK, that allows you to make hasle free payments. It includes recipient validation, you can make payment up to 1 000 000 in any currency.<br>
PaymentSDK contains example app to demonstrate SDK's functionality.

### Getting started

You must obtain API token from our website to setup PaymentSDK - ``PSDK.setup(apiToken:logLevel:networkResult:)``<br>
After that you just need to pass **amount**, **currency** and **recipient** to SDK to make payment - ``PSDK.makePayment(amount:currency:recipient:)``.<br>
And that's it. 

### Architecture

PaymentSDK is writen with clean architecture in mind, which allows it to be highly testable, decoupled and scalable.

### Dependecies

PaymentSDK doesn't have any 3rd party dependencies, it is written in Swift.
