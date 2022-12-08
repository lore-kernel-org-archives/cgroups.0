From: =?utf-8?B?56iL5Z6y5rabIENoZW5na2FpdGFvIENoZW5n?= 
        <chengkaitao@didiglobal.com>
Subject: Re: [PATCH v2] mm: memcontrol: protect the memory in cgroup from
 being oom killed
Date: Thu, 8 Dec 2022 07:59:27 +0000
Message-ID: <CEFD5AB7-17FB-4CC0-B818-1988484B8E55@didiglobal.com>
References: <Y5GTM5HLhGrx9zFO@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <Y5GTM5HLhGrx9zFO@dhcp22.suse.cz>
Content-Language: zh-CN
Content-ID: <CABC8BE52CB22F45A909440FC229C1FC@didichuxing.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.com>, chengkaitao <pilgrimtao@gmail.com>
Cc: "tj@kernel.org" <tj@kernel.org>, "lizefan.x@bytedance.com" <lizefan.x@bytedance.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "roman.gushchin@linux.dev" <roman.gushchin@linux.dev>, "shakeelb@google.com" <shakeelb@google.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "songmuchun@bytedance.com" <songmuchun@bytedance.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>, "ebiederm@xmission.com" <ebiederm@xmission.com>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "chengzhihao1@huawei.com" <chengzhihao1@huawei.com>, "haolee.swjtu@gmail.com" <haolee.swjtu@gmail.com>, "yuzhao@google.com" <yuzhao@google.com>, "willy@infradead.org" <willy@infradead.or>

QXQgMjAyMi0xMi0wOCAxNTozMzowNywgIk1pY2hhbCBIb2NrbyIgPG1ob2Nrb0BzdXNlLmNvbT4g
d3JvdGU6DQo+T24gVGh1IDA4LTEyLTIyIDExOjQ2OjQ0LCBjaGVuZ2thaXRhbyB3cm90ZToNCj4+
IEZyb206IGNoZW5na2FpdGFvIDxwaWxncmltdGFvQGdtYWlsLmNvbT4NCj4+IA0KPj4gV2UgY3Jl
YXRlZCBhIG5ldyBpbnRlcmZhY2UgPG1lbW9yeS5vb20ucHJvdGVjdD4gZm9yIG1lbW9yeSwgSWYg
dGhlcmUgaXMNCj4+IHRoZSBPT00ga2lsbGVyIHVuZGVyIHBhcmVudCBtZW1vcnkgY2dyb3VwLCBh
bmQgdGhlIG1lbW9yeSB1c2FnZSBvZiBhDQo+PiBjaGlsZCBjZ3JvdXAgaXMgd2l0aGluIGl0cyBl
ZmZlY3RpdmUgb29tLnByb3RlY3QgYm91bmRhcnksIHRoZSBjZ3JvdXAncw0KPj4gdGFza3Mgd29u
J3QgYmUgT09NIGtpbGxlZCB1bmxlc3MgdGhlcmUgaXMgbm8gdW5wcm90ZWN0ZWQgdGFza3MgaW4g
b3RoZXINCj4+IGNoaWxkcmVuIGNncm91cHMuIEl0IGRyYXdzIG9uIHRoZSBsb2dpYyBvZiA8bWVt
b3J5Lm1pbi9sb3c+IGluIHRoZQ0KPj4gaW5oZXJpdGFuY2UgcmVsYXRpb25zaGlwLg0KPj4gDQo+
PiBJdCBoYXMgdGhlIGZvbGxvd2luZyBhZHZhbnRhZ2VzLA0KPj4gMS4gV2UgaGF2ZSB0aGUgYWJp
bGl0eSB0byBwcm90ZWN0IG1vcmUgaW1wb3J0YW50IHByb2Nlc3Nlcywgd2hlbiB0aGVyZQ0KPj4g
aXMgYSBtZW1jZydzIE9PTSBraWxsZXIuIFRoZSBvb20ucHJvdGVjdCBvbmx5IHRha2VzIGVmZmVj
dCBsb2NhbCBtZW1jZywNCj4+IGFuZCBkb2VzIG5vdCBhZmZlY3QgdGhlIE9PTSBraWxsZXIgb2Yg
dGhlIGhvc3QuDQo+PiAyLiBIaXN0b3JpY2FsbHksIHdlIGNhbiBvZnRlbiB1c2Ugb29tX3Njb3Jl
X2FkaiB0byBjb250cm9sIGEgZ3JvdXAgb2YNCj4+IHByb2Nlc3NlcywgSXQgcmVxdWlyZXMgdGhh
dCBhbGwgcHJvY2Vzc2VzIGluIHRoZSBjZ3JvdXAgbXVzdCBoYXZlIGENCj4+IGNvbW1vbiBwYXJl
bnQgcHJvY2Vzc2VzLCB3ZSBoYXZlIHRvIHNldCB0aGUgY29tbW9uIHBhcmVudCBwcm9jZXNzJ3MN
Cj4+IG9vbV9zY29yZV9hZGosIGJlZm9yZSBpdCBmb3JrcyBhbGwgY2hpbGRyZW4gcHJvY2Vzc2Vz
LiBTbyB0aGF0IGl0IGlzDQo+PiB2ZXJ5IGRpZmZpY3VsdCB0byBhcHBseSBpdCBpbiBvdGhlciBz
aXR1YXRpb25zLiBOb3cgb29tLnByb3RlY3QgaGFzIG5vDQo+PiBzdWNoIHJlc3RyaWN0aW9ucywg
d2UgY2FuIHByb3RlY3QgYSBjZ3JvdXAgb2YgcHJvY2Vzc2VzIG1vcmUgZWFzaWx5LiBUaGUNCj4+
IGNncm91cCBjYW4ga2VlcCBzb21lIG1lbW9yeSwgZXZlbiBpZiB0aGUgT09NIGtpbGxlciBoYXMg
dG8gYmUgY2FsbGVkLg0KPj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBjaGVuZ2thaXRhbyA8cGlsZ3Jp
bXRhb0BnbWFpbC5jb20+DQo+PiAtLS0NCj4+IHYyOiBNb2RpZnkgdGhlIGZvcm11bGEgb2YgdGhl
IHByb2Nlc3MgcmVxdWVzdCBtZW1jZyBwcm90ZWN0aW9uIHF1b3RhLg0KPg0KPlRoZSBuZXcgZm9y
bXVsYSBkb2Vzbid0IHJlYWxseSBhZGRyZXNzIGNvbmNlcm5zIGV4cHJlc3NlZCBwcmV2aW91c2x5
Lg0KPlBsZWFzZSByZWFkIG15IGZlZWRiYWNrIGNhcmVmdWxseSBhZ2FpbiBhbmQgZm9sbG93IHVw
IHdpdGggcXVlc3Rpb25zIGlmDQo+c29tZXRoaW5nIGlzIG5vdCBjbGVhci4NCg0KVGhlIHByZXZp
b3VzIGRpc2N1c3Npb24gd2FzIHF1aXRlIHNjYXR0ZXJlZC4gQ2FuIHlvdSBoZWxwIG1lIHN1bW1h
cml6ZQ0KeW91ciBjb25jZXJucyBhZ2Fpbj8gTGV0IG1lIHRoaW5rIGFib3V0IHRoZSBvcHRpbWl6
YXRpb24gcGxhbiBmb3IgdGhlc2UNCnByb2JsZW1zLg0KLS0gDQpUaGFua3MgZm9yIHlvdXIgY29t
bWVudCENCmNoZW5na2FpdGFvDQoNCg==
