From: Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v2 bpf-next 0/4] cgroup bpf auto-detachment
Date: Thu, 23 May 2019 05:17:05 +0000
Message-ID: <0403d453-c003-c823-cf57-28d200a6e40a@fb.com>
References: <20190522232051.2938491-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=LbF2DUFZnjFuRWy9XC3ULdnqPz+cnRQPlgZncdo+klM=;
 b=K4ZLG+KsqJQ7Vrea7WkgyAh9WifNnacUX8NShIJKQtTWPjOIYpobxMacZ/k1tXH0SNC1
 yu/o+mARXrz3VzCj2s63jiESilxas9lxUNMUowoA5Pwx87cX0/GI/93cwVnb3t0SdpOw
 LvaiBAENBZAvzw5kOzH9XzGETUKV+jGc43g= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LbF2DUFZnjFuRWy9XC3ULdnqPz+cnRQPlgZncdo+klM=;
 b=AYAP4Chxjx2BiqRxqXtmKZOnnKHjpER92tlp/svZyzjatu6+cG/+ivFOrRJ01pZaVYSjiIw0O8M3XqW7zdYYrAsNwfSNGeEFUyEUcIZNMEIci8PMCc1sRTvv1ajonjZ2hWuULV5seMQq4km3gy9uQwu6H5/etNeWGFXnCCEFDq0=
In-Reply-To: <20190522232051.2938491-1-guro@fb.com>
Content-Language: en-US
Content-ID: <373C19A206E4ED41BCA7E8BFFF211415@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>, Alexei Starovoitov <ast@kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Stanislav Fomichev <sdf@fomichev.me>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

DQoNCk9uIDUvMjIvMTkgNDoyMCBQTSwgUm9tYW4gR3VzaGNoaW4gd3JvdGU6DQo+IFRoaXMgcGF0
Y2hzZXQgaW1wbGVtZW50cyBhIGNncm91cCBicGYgYXV0by1kZXRhY2htZW50IGZ1bmN0aW9uYWxp
dHk6DQo+IGJwZiBwcm9ncmFtcyBhcmUgYXR0YWNoZWQgYXMgc29vbiBhcyBwb3NzaWJsZSBhZnRl
ciByZW1vdmFsIG9mIHRoZQ0KdHlwbyBoZXJlICJhdHRhY2hlZCIgPT4gImRldGFjaGVkIj8NCg0K
PiBjZ3JvdXAsIHdpdGhvdXQgd2FpdGluZyBmb3IgdGhlIHJlbGVhc2Ugb2YgYWxsIGFzc29jaWF0
ZWQgcmVzb3VyY2VzLg0KPiANCj4gUGF0Y2hlcyAyIGFuZCAzIGFyZSByZXF1aXJlZCB0byBpbXBs
ZW1lbnQgYSBjb3JyZXNwb25kaW5nIGtzZWxmdGVzdA0KPiBpbiBwYXRjaCA0Lg0KPiANCj4gdjI6
DQo+ICAgIDEpIHJlbW92ZWQgYSBib2d1cyBjaGVjayBpbiBwYXRjaCA0DQo+ICAgIDIpIG1vdmVk
IGJ1ZltsZW5dID0gMCBpbiBwYXRjaCAyDQo+IA0KPiANCj4gUm9tYW4gR3VzaGNoaW4gKDQpOg0K
PiAgICBicGY6IGRlY291cGxlIHRoZSBsaWZldGltZSBvZiBjZ3JvdXBfYnBmIGZyb20gY2dyb3Vw
IGl0c2VsZg0KPiAgICBzZWxmdGVzdHMvYnBmOiBjb252ZXJ0IHRlc3RfY2dycDJfYXR0YWNoMiBl
eGFtcGxlIGludG8ga3NlbGZ0ZXN0DQo+ICAgIHNlbGZ0ZXN0cy9icGY6IGVuYWJsZSBhbGwgYXZh
aWxhYmxlIGNncm91cCB2MiBjb250cm9sbGVycw0KPiAgICBzZWxmdGVzdHMvYnBmOiBhZGQgYXV0
by1kZXRhY2ggdGVzdA0KPiANCj4gICBpbmNsdWRlL2xpbnV4L2JwZi1jZ3JvdXAuaCAgICAgICAg
ICAgICAgICAgICAgfCAgIDggKy0NCj4gICBpbmNsdWRlL2xpbnV4L2Nncm91cC5oICAgICAgICAg
ICAgICAgICAgICAgICAgfCAgMTggKysrDQo+ICAga2VybmVsL2JwZi9jZ3JvdXAuYyAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHwgIDI1ICsrLQ0KPiAgIGtlcm5lbC9jZ3JvdXAvY2dyb3VwLmMg
ICAgICAgICAgICAgICAgICAgICAgICB8ICAxMSArLQ0KPiAgIHNhbXBsZXMvYnBmL01ha2VmaWxl
ICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiAtDQo+ICAgdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvYnBmL01ha2VmaWxlICAgICAgICAgIHwgICA0ICstDQo+ICAgdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvYnBmL2Nncm91cF9oZWxwZXJzLmMgIHwgIDU3ICsrKysrKysNCj4gICAuLi4vc2Vs
ZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2guYyAgICAgICAgfCAxNDUgKysrKysrKysrKysr
KysrKy0tDQo+ICAgOCBmaWxlcyBjaGFuZ2VkLCAyNDMgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRp
b25zKC0pDQo+ICAgcmVuYW1lIHNhbXBsZXMvYnBmL3Rlc3RfY2dycDJfYXR0YWNoMi5jID0+IHRv
b2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X2Nncm91cF9hdHRhY2guYyAoNzklKQ0KPiAN
Cg==
