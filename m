From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add auto-detach test
Date: Thu, 23 May 2019 23:06:02 +0000
Message-ID: <5a44b791-899b-5638-4c75-235a31a0cb4d@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
 <20190522232051.2938491-5-guro@fb.com>
 <f7953267-8559-2f58-f39a-b2b0c3bf2e38@fb.com>
 <20190523175833.GA7107@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=phIreuEgZGB7hQWiDfT5EjSzPgXajjPLmKUroPJW/3o=;
 b=i8PEXjCTErOrFLbO0ALMQ0L7wXcHg3OD4nWtbBXeBZdK3pZNyQcZ2V0EA7lamYXMu3v9
 3Pjgob4yxCL5qIJBb3yYinLylsDLWXYKN7avV2eXZAwkBCYC9M5OsBY3OIu00D/z0ccu
 xxIWpGg+4YYhJsxU/QwGEJ+xOzk6r7VVSzQ= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=phIreuEgZGB7hQWiDfT5EjSzPgXajjPLmKUroPJW/3o=;
 b=M3OmUr98ek40/t9N6LlZebmgfWE530LBmu3qBg7KiP+NIuatCTImUALCF80GgyRMR+EZFr08P871ouMbStX+VVNFBUizMIn5xfUyw/vbDZIYj8U+xrfum+DPq/+LTY8ESux4TCt+FxWjuvvdh4NKPKhjDs/A6VqejIa5RWp8MYU=
In-Reply-To: <20190523175833.GA7107@tower.DHCP.thefacebook.com>
Content-Language: en-US
Content-ID: <15E0BB2E1DBFAF4DB4358347764A8F5A@namprd15.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: Alexei Starovoitov <ast@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

DQoNCk9uIDUvMjMvMTkgMTA6NTggQU0sIFJvbWFuIEd1c2hjaGluIHdyb3RlOg0KPiBPbiBXZWQs
IE1heSAyMiwgMjAxOSBhdCAxMDo0NzoyNFBNIC0wNzAwLCBZb25naG9uZyBTb25nIHdyb3RlOg0K
Pj4NCj4+DQo+PiBPbiA1LzIyLzE5IDQ6MjAgUE0sIFJvbWFuIEd1c2hjaGluIHdyb3RlOg0KPj4+
IEFkZCBhIGtzZWxmdGVzdCB0byBjb3ZlciBicGYgYXV0by1kZXRhY2htZW50IGZ1bmN0aW9uYWxp
dHkuDQo+Pj4gVGhlIHRlc3QgY3JlYXRlcyBhIGNncm91cCwgYXNzb2NpYXRlcyBzb21lIHJlc291
cmNlcyB3aXRoIGl0LA0KPj4+IGF0dGFjaGVzIGEgY291cGxlIG9mIGJwZiBwcm9ncmFtcyBhbmQg
ZGVsZXRlcyB0aGUgY2dyb3VwLg0KPj4+DQo+Pj4gVGhlbiBpdCBjaGVja3MgdGhhdCBicGYgcHJv
Z3JhbXMgYXJlIGdvaW5nIGF3YXkgaW4gNSBzZWNvbmRzLg0KPj4+DQo+Pj4gRXhwZWN0ZWQgb3V0
cHV0Og0KPj4+ICAgICAkIC4vdGVzdF9jZ3JvdXBfYXR0YWNoDQo+Pj4gICAgICNvdmVycmlkZTpQ
QVNTDQo+Pj4gICAgICNtdWx0aTpQQVNTDQo+Pj4gICAgICNhdXRvZGV0YWNoOlBBU1MNCj4+PiAg
ICAgdGVzdF9jZ3JvdXBfYXR0YWNoOlBBU1MNCj4+Pg0KPj4+IE9uIGEga2VybmVsIHdpdGhvdXQg
YXV0by1kZXRhY2hpbmc6DQo+Pj4gICAgICQgLi90ZXN0X2Nncm91cF9hdHRhY2gNCj4+PiAgICAg
I292ZXJyaWRlOlBBU1MNCj4+PiAgICAgI211bHRpOlBBU1MNCj4+PiAgICAgI2F1dG9kZXRhY2g6
RkFJTA0KPj4+ICAgICB0ZXN0X2Nncm91cF9hdHRhY2g6RkFJTA0KPj4NCj4+IEkgcmFuIHRoaXMg
cHJvYmxlbSB3aXRob3V0IGJvdGggb2xkIGFuZCBuZXcga2VybmVscyBhbmQNCj4+IGJvdGggZ2V0
IGFsbCBQQVNTZXMuIE15IHRlc3RpbmcgZW52aXJvbm1lbnQgaXMgYSBWTS4NCj4+IENvdWxkIHlv
dSBzcGVjaWZ5IGhvdyB0byB0cmlnZ2VyIHRoZSBhYm92ZSBmYWlsdXJlPw0KPiANCj4gTW9zdCBs
aWtlbHkgeW91J3JlIHJ1bm5pbmcgY2dyb3VwIHYxLCBzbyB0aGUgbWVtb3J5IGNvbnRyb2xsZXIN
Cj4gaXMgbm90IGVuYWJsZWQgb24gdW5pZmllZCBoaWVyYXJjaHkuIFlvdSBuZWVkIHRvIHBhc3MN
Cj4gImNncm91cF9ub192MT1hbGwgc3lzdGVtZC51bmlmaWVkX2Nncm91cF9oaWVyYXJjaHk9MSIN
Cj4gYXMgYm9vdCB0aW1lIG9wdGlvbnMgdG8gcnVuIGZ1bGx5IG9uIGNncm91cCB2Mi4NCg0KSSB0
ZXN0ZWQgb24gYSBjZ3JvdXAgdjIgbWFjaGluZSBhbmQgaXQgaW5kZWVkIGZhaWxlZCB3aXRob3V0
DQp0aGUgY29yZSBwYXRjaC4gVGhhbmtzIQ0KDQo+IA0KPiBCdXQgZ2VuZXJhbGx5IHNwZWFraW5n
LCB0aGUgbGlmZWN5Y2xlIG9mIGEgZHlpbmcgY2dyb3VwIGlzDQo+IGNvbXBsZXRlbHkgaW1wbGVt
ZW50YXRpb24tZGVmaW5lZC4gTm8gZ3VhcmFudGVlcyBhcmUgcHJvdmlkZWQuDQo+IFNvIGZhbHNl
IHBvc2l0aXZlcyBhcmUgZmluZSBoZXJlLCBhbmQgc2hvdWxkbid0IGJlIGNvbnNpZGVyZWQgYXMN
Cj4gc29tZXRoaW5nIGJhZC4NCj4gDQo+IEF0IHRoZSBlbmQgYWxsIHdlIHdhbnQgaXQgdG8gZGV0
YWNoIHByb2dyYW1zIGluIGEgcmVhc29uYWJsZSB0aW1lDQo+IGFmdGVyIHJtZGlyLg0KPiANCj4g
QnR3LCB0aGFuayB5b3UgZm9yIHRoZSBjYXJlZnVsIHJldmlldyBvZiB0aGUgcGF0Y2hzZXQuIEkn
bGwNCj4gYWRkcmVzcyB5b3VyIGNvbW1lbnRzLCBhZGQgYWNrcyBhbmQgd2lsbCBzZW5kIG91dCB2
My4NCj4gDQo+IFRoYW5rcyENCj4gDQo=
