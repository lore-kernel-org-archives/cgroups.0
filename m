From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH 10/10] blkcg: implement BPF_PROG_TYPE_IO_COST
Date: Fri, 14 Jun 2019 16:35:35 +0000
Message-ID: <bed0a66a-7aa6-ac36-9182-31a4937257e5@fb.com>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614015620.1587672-11-tj@kernel.org>
 <e4d1df7b-66bb-061a-8ecb-ff1e5be3ab1d@netronome.com>
 <20190614145239.GA538958@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jNRW9EmWXHDKfmPq7ZRz6M8ppAhae7tV4WfQ4SRKB3U=;
 b=NVPU6cUCj7go4ZN7SujSkagzKLFGRAvTuDJxxXSZB551P6cFcWPJuPwECHFebknecsd4
 VyTjACWDRkD/Ouv+sm+sw+Ql2iLP+0b1ymlfnFHd7a0jHw39898gM8V04SDPjzKQ+YxT
 KzH5nTOncGkuUTD31BffwEFwXWm9edhr+ME= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jNRW9EmWXHDKfmPq7ZRz6M8ppAhae7tV4WfQ4SRKB3U=;
 b=UxzpnnnC3dfgmaTf592qdGW5mOmgO2x/XYv25lANqMZL3QcJdoCabA2Z8gB0L3ts1nMo0eBc5rA+YSINSgi0O6MBPcR3RM3GGulxT9rRNSyK4gX/zeaH5wrEE23+LB5QtmRO0pHiUY76oNkx1ihN2Eg7n36BfISVxTM+ux5k/iE=
In-Reply-To: <20190614145239.GA538958@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <28B576F5DD3F7F42A8E9DFABB8D25258@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Quentin Monnet <quentin.monnet@netronome.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, Andy Newell <newella@fb.com>, Chris Mason <clm@fb.com>, "josef@toxicpanda.com" <josef@toxicpanda.com>, Dennis Zhou <dennisz@fb.com>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>, Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>

T24gNi8xNC8xOSA3OjUyIEFNLCBUZWp1biBIZW8gd3JvdGU6DQo+IEhlbGxvLCBRdWVudGluLg0K
PiANCj4gT24gRnJpLCBKdW4gMTQsIDIwMTkgYXQgMTI6MzI6MDlQTSArMDEwMCwgUXVlbnRpbiBN
b25uZXQgd3JvdGU6DQo+PiBQbGVhc2UgbWFrZSBzdXJlIHRvIHVwZGF0ZSB0aGUgZG9jdW1lbnRh
dGlvbiBhbmQgYmFzaA0KPj4gY29tcGxldGlvbiB3aGVuIGFkZGluZyB0aGUgbmV3IHR5cGUgdG8g
YnBmdG9vbC4gWW91DQo+PiBwcm9iYWJseSB3YW50IHNvbWV0aGluZyBsaWtlIHRoZSBkaWZmIGJl
bG93Lg0KPiANCj4gVGhhbmsgeW91IHNvIG11Y2guICBXaWxsIGluY29ycG9yYXRlIHRoZW0uICBK
dXN0IGluIGNhc2UsIHdoaWxlIGl0J3MNCj4gbm90ZWQgaW4gdGhlIGhlYWQgbWVzc2FnZSwgSSBs
b3N0IHRoZSBSRkMgbWFya2VyIHdoaWxlIHByZXBwaW5nIHRoaXMNCj4gcGF0Y2guICBJdCBpc24n
dCB5ZXQgY2xlYXIgd2hldGhlciB3ZSdkIHJlYWxseSBuZWVkIGN1c3RvbSBjb3N0DQo+IGZ1bmN0
aW9ucyBhbmQgdGhpcyBwYXRjaCBpcyBpbmNsdWRlZCBtb3JlIGFzIGEgcHJvb2Ygb2YgY29uY2Vw
dC4gIA0KDQp0aGUgZXhhbXBsZSBicGYgcHJvZyBsb29rcyBmbGV4aWJsZSBlbm91Z2ggdG8gYWxs
b3cgc29tZSBkZWdyZWUNCm9mIGV4cGVyaW1lbnRzLiBUaGUgcXVlc3Rpb24gaXMgd2hhdCBraW5k
IG9mIG5ldyBhbGdvcml0aG1zIHlvdSBlbnZpc2lvbg0KaXQgd2lsbCBkbz8gd2hhdCBvdGhlciBp
bnB1dHMgaXQgd291bGQgbmVlZCB0byBtYWtlIGEgZGVjaXNpb24/DQpJIHRoaW5rIGl0J3Mgb2sg
dG8gc3RhcnQgd2l0aCB3aGF0IGl0IGRvZXMgbm93IGFuZCBleHRlbmQgZnVydGhlcg0Kd2hlbiBu
ZWVkIGFyaXNlcy4NCg0KPiBJZg0KPiBpdCB0dXJucyBvdXQgdGhhdCB0aGlzIGlzIGJlbmVmaWNp
YWwgZW5vdWdoLCB0aGUgZm9sbG93aW5ncyBuZWVkIHRvIGJlDQo+IGFuc3dlcmVkLg0KPiANCj4g
KiBJcyBibG9jayBpb2N0bCB0aGUgcmlnaHQgbWVjaGFuaXNtIHRvIGF0dGFjaCB0aGVzZSBwcm9n
cmFtcz8NCg0KaW1vIGlvY3RsIGlzIGEgYml0IHdlaXJkLCBidXQgc2luY2UgaXRzIG9ubHkgb25l
IHByb2dyYW0gcGVyIGJsb2NrDQpkZXZpY2UgaXQncyBwcm9iYWJseSBvaz8gVW5sZXNzIHlvdSBz
ZWUgaXQgYmVpbmcgY2dyb3VwIHNjb3BlZCBpbg0KdGhlIGZ1dHVyZT8gVGhlbiBjZ3JvdXAtYnBm
IHN0eWxlIGhvb2tzIHdpbGwgYmUgbW9yZSBzdWl0YWJsZQ0KYW5kIGFsbG93IGEgY2hhaW4gb2Yg
cHJvZ3JhbXMuDQoNCj4gKiBBcmUgdGhlcmUgbW9yZSBwYXJhbWV0ZXJzIHRoYXQgbmVlZCB0byBi
ZSBleHBvc2VkIHRvIHRoZSBwcm9ncmFtcz8NCj4gDQo+ICogSXQnZCBiZSBncmVhdCB0byBoYXZl
IGVmZmljaWVudCBhY2Nlc3MgdG8gcGVyLWJsb2NrZGV2IGFuZA0KPiAgICBwZXItYmxvY2tkZXYt
Y2dyb3VwLXBhaXIgc3RvcmFnZXMgYXZhaWxhYmxlIHRvIHRoZXNlIHByb2dyYW1zIHNvDQo+ICAg
IHRoYXQgdGhleSBjYW4ga2VlcCB0cmFjayBvZiBoaXN0b3J5LiAgV2hhdCdkIGJlIHRoZSBiZXN0
IG9mIHdheSBvZg0KPiAgICBkb2luZyB0aGF0IGNvbnNpZGVyaW5nIHRoZSBmYWN0IHRoYXQgdGhl
c2UgcHJvZ3JhbXMgd2lsbCBiZSBjYWxsZWQNCj4gICAgcGVyIGVhY2ggSU8gYW5kIHRoZSBvdmVy
aGVhZCBjYW4gYWRkIHVwIHF1aWNrbHk/DQoNCk1hcnRpbidzIHNvY2tldCBsb2NhbCBzdG9yYWdl
IHNvbHZlZCB0aGF0IGlzc3VlIGZvciBzb2NrZXRzLg0KU29tZXRoaW5nIHZlcnkgc2ltaWxhciBj
YW4gd29yayBmb3IgcGVyLWJsb2NrZGV2LXBlci1jZ3JvdXAuDQo=
