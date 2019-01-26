From: Roman Gushchin <guro@fb.com>
Subject: Re: pids.current with invalid value for hours [5.0.0 rc3 git]
Date: Sat, 26 Jan 2019 01:41:04 +0000
Message-ID: <20190126014055.GA25864@castle.DHCP.thefacebook.com>
References: <df806a77-3327-9db5-8be2-976fde1c84e5@gmail.com>
 <20190117122535.njcbqhlmzozdkncw@mikami>
 <1d36b181-cbaf-6694-1a31-2f7f55d15675@gmail.com>
 <96ef6615-a5df-30af-b4dc-417a18ca63f1@gmail.com>
 <1cdbef13-564d-61a6-95f4-579d2cad243d@gmail.com>
 <20190125163731.GJ50184@devbig004.ftw2.facebook.com>
 <a95d004a-4358-7efc-6d21-12aac4411b32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=s9ysb9p7FtoGVSZgQomcsivhUmASooGQCwtxL9McI28=;
 b=bt8R0IcqMZ6G0VLq3K6EbB/5B2WniJ2Z6Y6Uz+qpPjyv1yGwLXOX+LtgYGUP0kH4iHG2
 csXFtvSlwpROGI8Ac5ciGNqYYbTe1Uovm4X/ZC4JsoMAz7HW6Qb0POlZVmgx7HiXsQOe
 aL2pLUr+jEQcRf39/08SzhPatqiYxh3dZus= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9ysb9p7FtoGVSZgQomcsivhUmASooGQCwtxL9McI28=;
 b=GvCTi5DGNvQsoyx8Bd+MEdIHiXOzDdZQTeXBtqMh1b3/9g4z7McQuce2nwsJDq+NTQbvdD1KWaIOub58KgLgP+oRzcP+rkdb/KbADu1NIIIqJutKUqh/GGBYsNUiHjKN5bsRFRylwzsbzYJ/do42qhpfygDx9VnWWGfCEJ2oHng=
In-Reply-To: <a95d004a-4358-7efc-6d21-12aac4411b32@gmail.com>
Content-Language: en-US
Content-ID: <45EA340A70ADF044AFF0F3C3F0EBB07F@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: =?utf-8?B?QXJrYWRpdXN6IE1pxZtraWV3aWN6?= <a.miskiewicz@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

T24gRnJpLCBKYW4gMjUsIDIwMTkgYXQgMDg6NDc6NTdQTSArMDEwMCwgQXJrYWRpdXN6IE1pxZtr
aWV3aWN6IHdyb3RlOg0KPiBPbiAyNS8wMS8yMDE5IDE3OjM3LCBUZWp1biBIZW8gd3JvdGU6DQo+
ID4gT24gRnJpLCBKYW4gMjUsIDIwMTkgYXQgMDg6NTI6MTFBTSArMDEwMCwgQXJrYWRpdXN6IE1p
xZtraWV3aWN6IHdyb3RlOg0KPiA+PiBPbiAyNC8wMS8yMDE5IDEyOjIxLCBBcmthZGl1c3ogTWnF
m2tpZXdpY3ogd3JvdGU6DQo+ID4+PiBPbiAxNy8wMS8yMDE5IDE0OjE3LCBBcmthZGl1c3ogTWnF
m2tpZXdpY3ogd3JvdGU6DQo+ID4+Pj4gT24gMTcvMDEvMjAxOSAxMzoyNSwgQWxla3NhIFNhcmFp
IHdyb3RlOg0KPiA+Pj4+PiBPbiAyMDE5LTAxLTE3LCBBcmthZGl1c3ogTWnFm2tpZXdpY3ogPGEu
bWlza2lld2ljekBnbWFpbC5jb20+IHdyb3RlOg0KPiA+Pj4+Pj4gVXNpbmcga2VybmVsIDQuMTku
MTMuDQo+ID4+Pj4+Pg0KPiA+Pj4+Pj4gRm9yIG9uZSBjZ3JvdXAgSSBub3RpY2VkIHdlaXJkIGJl
aGF2aW91cjoNCj4gPj4+Pj4+DQo+ID4+Pj4+PiAjIGNhdCBwaWRzLmN1cnJlbnQNCj4gPj4+Pj4+
IDYwDQo+ID4+Pj4+PiAjIGNhdCBjZ3JvdXAucHJvY3MNCj4gPj4+Pj4+ICMNCj4gPj4+Pj4NCj4g
Pj4+Pj4gQXJlIHRoZXJlIGFueSB6b21iaWVzIGluIHRoZSBjZ3JvdXA/IHBpZHMuY3VycmVudCBp
cyBsaW5rZWQgdXAgZGlyZWN0bHkNCj4gPj4+Pj4gdG8gX19wdXRfdGFza19zdHJ1Y3QgKHNvIGV4
aXQoMikgd29uJ3QgZGVjcmVhc2UgaXQsIG9ubHkgdGhlIHRhc2tfc3RydWN0DQo+ID4+Pj4+IGFj
dHVhbGx5IGJlaW5nIGZyZWVkIHdpbGwgZGVjcmVhc2UgaXQpLg0KPiA+Pj4+Pg0KPiA+Pj4+DQo+
ID4+Pj4gVGhlcmUgYXJlIG5vIHpvbWJpZSBwcm9jZXNzZXMuDQo+ID4+Pj4NCj4gPj4+PiBJbiBt
ZWFuIHRpbWUgdGhlIHByb2JsZW0gc2hvd3Mgb24gbXVsdGlwbGUgc2VydmVycyBhbmQgc28gZmFy
IHNhdyBpdA0KPiA+Pj4+IG9ubHkgaW4gY2dyb3VwcyB0aGF0IHdlcmUgT09NZWQuDQo+ID4+Pj4N
Cj4gPj4+PiBXaGF0IGhhcyBjaGFuZ2VkIG9uIHRoZXNlIHNlcnZlcnMgKHllc3RlcmRheSkgaXMg
dHVybmluZyBvbg0KPiA+Pj4+IG1lbW9yeS5vb20uZ3JvdXA9MSBmb3IgYWxsIGNncm91cHMgYW5k
IGNoYW5naW5nIG1lbW9yeS5oaWdoIGZyb20gMUcgdG8NCj4gPj4+PiAibWF4IiAobGVhdmluZyBt
ZW1vcnkubWF4PTJHIGxpbWl0IG9ubHkpLg0KPiA+Pj4+DQo+ID4+Pj4gUHJldmlvdXNseSB0aGVy
ZSB3YXMgbm8gc3VjaCBwcm9ibGVtLg0KPiA+Pj4+DQo+ID4+Pg0KPiA+Pj4gSSdtIGF0dGFjaGlu
ZyByZXByb2R1Y2VyLiBUaGlzIHRpbWUgdHJpZWQgb24gZGlmZmVyZW50IGRpc3RyaWJ1dGlvbg0K
PiA+Pj4ga2VybmVsIChhcmNoIGxpbnV4KS4NCj4gPj4+DQo+ID4+PiBBZnRlciA2MHMgcGlkcy5j
dXJyZW50IHN0aWxsIHNob3dzIDM3IHByb2Nlc3NlcyBldmVuIGlmIHRoZXJlIGFyZSBubw0KPiA+
Pj4gcHJvY2Vzc2VzIHJ1bm5pbmcgKGFjY29yZGluZyB0byBwcyBhdXgpLg0KPiA+Pg0KPiA+Pg0K
PiA+PiBUaGUgc2FtZSB0ZXN0IG9uIDUuMC4wLXJjMy0wMDEwNC1nYzA0ZTJhNzgwY2FmIGFuZCBp
dCdzIGVhc3kgdG8NCj4gPj4gcmVwcm9kdWNlIGJ1Zy4gTm8gcHJvY2Vzc2VzIGluIGNncm91cCBi
dXQgcGlkcy5jdXJyZW50IHJlcG9ydHMgOTEuDQo+ID4gDQo+ID4gQ2FuIHlvdSBwbGVhc2Ugc2Vl
IHdoZXRoZXIgdGhlIHByb2JsZW0gY2FuIGJlIHJlcHJvZHVjZWQgb24gdGhlDQo+ID4gY3VycmVu
dCBsaW51eC1uZXh0Pw0KPiA+IA0KPiA+ICBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xp
bnV4L2tlcm5lbC9naXQvbmV4dC9saW51eC1uZXh0LmdpdA0KPiANCj4gSSBjYW4gcmVwcm9kdWNl
IG9uIG5leHQgKDUuMC4wLXJjMy1uZXh0LTIwMTkwMTI1KSwgdG9vOg0KDQpIb3cgcmVsaWFibHkg
eW91IGNhbiByZXByb2R1Y2UgaXQ/IEkndmUgdHJpZWQgdG8gcnVuIHlvdXIgcmVwcm9kdWNlcg0K
c2V2ZXJhbCB0aW1lcyB3aXRoIGRpZmZlcmVudCBwYXJhbWV0ZXJzLCBidXQgd2Fzbid0IGx1Y2t5
IHNvIGZhci4NCldoYXQncyB5b3VycyBjcHUgbnVtYmVyIGFuZCB0b3RhbCByYW0gc2l6ZT8NCg0K
Q2FuIHlvdSwgcGxlYXNlLCBwcm92aWRlIHRoZSBjb3JyZXNwb25kaW5nIGRtZXNnIG91dHB1dD8N
Cg0KSSd2ZSBjaGVja2VkIHRoZSBjb2RlIGFnYWluLCBhbmQgbXkgd2lsZCBndWVzcyBpcyB0aGF0
IHRoZXNlIG1pc3NpbmcNCnRhc2tzIGFyZSB3YWl0aW5nIChtYXliZSBob3BlbGVzc2x5KSBmb3Ig
dGhlIE9PTSByZWFwZXIuIERtZXNnIG91dHB1dA0KbWlnaHQgYmUgdmVyeSB1c2VmdWwgaGVyZS4N
Cg0KVGhhbmtzIQ0K
