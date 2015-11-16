# PIReddit SDK
**P**rogramming **I**nterface for **Reddit** v0.4.0
* Uses Reddit's modern OAuth 2 API.
* No third-party dependencies needed. Just plug and play.
* Networking is based on `NSOperation`s.
* Lazy models' properties loading. Property objects are not constructed untill accessed.
* Frequently used fields of models are available as properies. Every model object has the `allFields` dictionary which contains _all_ possible fields for your convenience.
