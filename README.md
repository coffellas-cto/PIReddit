# PIReddit SDK
**P**rogramming **I**nterface for **Reddit**
* Uses Reddit's modern OAuth 2 API.
* No third-party dependencies needed. Just plug and play.
* Networking is based on `NSOperation`s.
* Lazy models' properties loading. Property objects are not constructed untill accessed.
* Most used fields of models are available as properies. Every model object has the `allFields` dictionary which contains _all_ possible fields for your convenience.
