From: Chaitanya Kulkarni <chaitanyak@nvidia.com>
Subject: Re: [PATCH v2] blk-ioprio: Introduce promote-to-rt policy
Date: Tue, 21 Feb 2023 18:04:03 +0000
Message-ID: <65a521aa-dbb9-0638-174c-3762df89fe83@nvidia.com>
References: <20230220135428.2632906-1-houtao@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eiZ1T9W8rI0nSik7AWw5HX9R/24n2bpB8kZOYRiZ2Sk=;
 b=bbt4ZlpbfxrfNdm7pM49dG14wSAcKEL/sqBtK7/u7n4AZ9FmlZjIElz7jKJ4v78U/1A1MqjYj2X3wWNScntCfc7TY5VyxjavMsN1SY1SzodnpZteaPUphp0ibbfgxpoibWXdeOJY2FnBdEnh6yCriLuN6wGCTMX0JnuTL6EX9NJUa/dIhuTzEqVB1P70yEmb0cxqFEmWpzsLq7grQDMgSq/oAsD2Yb4tU57/HWOulTFPFG/zaD7hQxuUvThF+eGcor5BiFbUxMcUeZZ7bc5jzWCZffqTt3dcmXvmnYfRg1HQ7f7Yk4AzeNIWjMQ4z9u+KTIiv0VmEtyPVn6L9IKXGQ==
In-Reply-To: <20230220135428.2632906-1-houtao@huaweicloud.com>
Content-Language: en-US
Content-ID: <16CCC625A940804EA4F52256A538E45C@namprd12.prod.outlook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Hou Tao <houtao@huaweicloud.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, Jan Kara <jack@suse.cz>, Bagas Sanjaya <bagasdotme@gmail.com>, Jens Axboe <axboe@kernel.dk>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "houtao1@huawei.com" <houtao1@huawei.com>

T24gMi8yMC8yMDIzIDU6NTQgQU0sIEhvdSBUYW8gd3JvdGU6DQo+IEZyb206IEhvdSBUYW8gPGhv
dXRhbzFAaHVhd2VpLmNvbT4NCj4gDQo+IFNpbmNlIGNvbW1pdCBhNzg0MThlNmEwNGMgKCJibG9j
azogQWx3YXlzIGluaXRpYWxpemUgYmlvIElPIHByaW9yaXR5IG9uDQo+IHN1Ym1pdCIpLCBiaW8t
PmJpX2lvcHJpbyB3aWxsIG5ldmVyIGJlIElPUFJJT19DTEFTU19OT05FIHdoZW4gY2FsbGluZw0K
PiBibGtjZ19zZXRfaW9wcmlvKCksIHNvIHRoZXJlIHdpbGwgYmUgbm8gd2F5IHRvIHByb21vdGUg
dGhlIGlvLXByaW9yaXR5DQo+IG9mIG9uZSBjZ3JvdXAgdG8gSU9QUklPX0NMQVNTX1JULCBiZWNh
dXNlIGJpX2lvcHJpbyB3aWxsIGFsd2F5cyBiZQ0KPiBncmVhdGVyIHRoYW4gb3IgZXF1YWxzIHRv
IElPUFJJT19DTEFTU19SVC4NCj4gDQo+IEl0IHNlZW1zIHBvc3NpYmxlIHRvIGNhbGwgYmxrY2df
c2V0X2lvcHJpbygpIGZpcnN0IHRoZW4gdHJ5IHRvDQo+IGluaXRpYWxpemUgYmlfaW9wcmlvIGxh
dGVyIGluIGJpb19zZXRfaW9wcmlvKCksIGJ1dCB0aGlzIGRvZXNuJ3Qgd29yaw0KPiBmb3IgYmlv
IGluIHdoaWNoIGJpX2lvcHJpbyBpcyBhbHJlYWR5IGluaXRpYWxpemVkIChlLmcuLCBkaXJlY3Qt
aW8pLCBzbw0KPiBpbnRyb2R1Y2UgYSBuZXcgaW9wcmlvIHBvbGljeSB0byBwcm9tb3RlIHRoZSBp
b3ByaW9yaXR5IG9mIGJpbyB0bw0KPiBJT1BSSU9fQ0xBU1NfUlQgaWYgdGhlIGlvcHJpbyBpcyBu
b3QgYWxyZWFkeSBSVC4NCj4gDQo+IFNvIGludHJvZHVjZSBhIG5ldyBwcm9tb3RlLXRvLXJ0IHBv
bGljeSB0byBhY2hpZXZlIHRoaXMuIEZvciBub25lLXRvLXJ0DQo+IHBvbGljeSwgYWx0aG91Z2gg
aXQgZG9lc24ndCB3b3JrIG5vdywgYnV0IGNvbnNpZGVyaW5nIHRoYXQgaXRzIHB1cnBvc2UNCj4g
d2FzIGFsc28gdG8gb3ZlcnJpZGUgdGhlIGlvLXByaW9yaXR5IHRvIFJUIGFuZCBhbGxvdyBmb3Ig
YSBzbW9vdGhlcg0KPiB0cmFuc2l0aW9uLCBqdXN0IGtlZXAgaXQgYW5kIHRyZWF0IGl0IGFzIGFu
IGFsaWFzIG9mIHRoZSBwcm9tb3RlLXRvLXJ0DQo+IHBvbGljeS4NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IEhvdSBUYW8gPGhvdXRhbzFAaHVhd2VpLmNvbT4NCg0KDQpUaGFua3MgZm9yIHVwZGF0aW5n
IGRvY3VtZW50YXRpb24gYW5kIGFkZGluZyBtZWFuaW5nZnVsIGNvbW1lbnQuDQoNCkxvb2tzIGdv
b2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0K
DQotY2sNCg0KDQo=
