Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED35031714A;
	Thu, 16 Jul 2026 03:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.70.192.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784173775; cv=none; b=AiuzSGaU89cybAov7wGk3DL70KAm4zTXSUFaIUGexYBOvfLGEJ/s4eVZApnNyG49VTW5QLIc3uMcRKEaR9JqtndOKe0fK6JsD4BixqVB9r3ezPEoaAoj/O3ot/3eM1CIlDy5Tl5no/d3v+xH9QVRcxV0M5kVJMvj+SvjEfItlng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784173775; c=relaxed/simple;
	bh=ItYi06FPqOAolJ383qO1b9Qz7jYMs7AKYeDjpmFSRKs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dflCNdXlwV1RjpbSjlT3Th6Ml1kCx3DFa9BpCEuGoV0J5nr68oNTP3mLnzRy9KtsGkRxAOGjnJER3hKKxvXcRIb1f7dh8eJnzA6GbosGEVgKLtvgyEh6lCVIYr7paUx000l1p/yDedXIPXG5CaURFgu6WYTfbJDjOOLWH0ib+sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=honor.com; spf=pass smtp.mailfrom=honor.com; dkim=pass (1024-bit key) header.d=honor.com header.i=@honor.com header.b=Akq2uFSu; arc=none smtp.client-ip=81.70.192.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=honor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=honor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=honor.com header.i=@honor.com header.b="Akq2uFSu"
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=ItYi06FPqOAolJ383qO1b9Qz7jYMs7AKYeDjpmFSRKs=;
	b=Akq2uFSu1WY0LiWc8i46u88FYYLlM1IOjcYvZd4czQ4tt/LUY5nD4aKgyUJafBB04mJnysSB4
	KSNhhsgXr6vhyvybGHB18kvGvoR69bWakugaRs5XElsRiHiPVn7oKCW8+ohyxgFgEkOhJdCTG99
	PZBllL98gkHIRlYFF9zIq6M=
Received: from TW006-1.hihonor.com (unknown [10.77.215.153])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4h0zYt4y6KzYm6WT;
	Thu, 16 Jul 2026 11:49:22 +0800 (CST)
Received: from TA009-1.hihonor.com (10.77.226.44) by TW006-1.hihonor.com
 (10.77.215.153) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 16 Jul
 2026 11:49:22 +0800
Received: from TA012-1.hihonor.com (10.77.199.132) by TA009-1.hihonor.com
 (10.77.226.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 16 Jul
 2026 11:49:22 +0800
Received: from TA012-1.hihonor.com ([fe80::6668:8cd2:ec5c:99b2]) by
 TA012-1.hihonor.com ([fe80::6668:8cd2:ec5c:99b2%13]) with mapi id
 15.02.2562.017; Thu, 16 Jul 2026 11:49:05 +0800
From: wangzicheng <wangzicheng@honor.com>
To: Ridong Chen <ridong.chen@linux.dev>, "T.J. Mercier" <tjmercier@google.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"yuanchu@google.com" <yuanchu@google.com>, "tj@kernel.org" <tj@kernel.org>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "mkoutny@suse.com"
	<mkoutny@suse.com>, "corbet@lwn.net" <corbet@lwn.net>, "kasong@tencent.com"
	<kasong@tencent.com>, "qi.zheng@linux.dev" <qi.zheng@linux.dev>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "baohua@kernel.org"
	<baohua@kernel.org>, "axelrasmussen@google.com" <axelrasmussen@google.com>,
	"weixugc@google.com" <weixugc@google.com>, "david@kernel.org"
	<david@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "roman.gushchin@linux.dev"
	<roman.gushchin@linux.dev>, "muchun.song@linux.dev" <muchun.song@linux.dev>,
	"cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "willy@infradead.org" <willy@infradead.org>,
	denghaojie <denghaojie@honor.com>, "baoquan.he@linux.dev"
	<baoquan.he@linux.dev>, "kaleshsingh@google.com" <kaleshsingh@google.com>,
	wangtao <tao.wangtao@honor.com>, zhangji <zhangji1@honor.com>, wangzhen
	<wangzhen5@honor.com>
Subject: RE: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
Thread-Topic: [RFC v2 0/3] mm/mglru: proactive aging via memory.aging
Thread-Index: AQHdE4pwfI2vhxgx7kyzLikejPZWhrZuWS0AgACPXACAAJiMMA==
Date: Thu, 16 Jul 2026 03:49:05 +0000
Message-ID: <f61e49966c434900b3c244c6bbabb6db@honor.com>
References: <20260714121529.2237261-1-wangzicheng@honor.com>
 <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
 <c01c77ed-9ce2-43e6-8ab8-dc2a8fb43b4b@linux.dev>
In-Reply-To: <c01c77ed-9ce2-43e6-8ab8-dc2a8fb43b4b@linux.dev>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

PiBPbiA3LzE2LzIwMjYgMTo1NSBBTSwgVC5KLiBNZXJjaWVyIHdyb3RlOg0KPiA+IE9uIFR1ZSwg
SnVsIDE0LCAyMDI2IGF0IDU6MTXigK9BTSBaaWNoZW5nIFdhbmcgPHdhbmd6aWNoZW5nQGhvbm9y
LmNvbT4NCj4gd3JvdGU6DQo+ID4+IFRoZSBiZW5lZml0IGlzIHdvcmtsb2FkLWRlcGVuZGVudDog
ZmlsZS1jYWNoZS1ib3VuZCBzZXJ2ZXJzIGdhaW4gZnJvbQ0KPiA+PiBhZ2luZywgYW5vbi1ib3Vu
ZCBzZXJ2ZXJzIGRvIG5vdCwgc28gbm8ga2VybmVsIGRlZmF1bHQgaXMgY29ycmVjdCBmb3INCj4g
Pj4gYWxsLiAgVGhlIGtlcm5lbCBhbHNvIGNhbm5vdCBrbm93IHdoZW4gdG8gYWdlOiBvbiBBbmRy
b2lkIHRoZSByaWdodA0KPiA+PiBtb21lbnQgaXMgdGhlIGZvcmVncm91bmQtdG8tYmFja2dyb3Vu
ZCB0cmFuc2l0aW9uLCB3aGVuIHRoZSBhcHAncw0KPiBwYWdlcw0KPiA+PiBhcmUgY29sZCBidXQg
dGhlaXIgUFRFIGFjY2Vzc2VkIGJpdHMgYXJlIHN0aWxsIGFjY3VyYXRlIGZyb20gZm9yZWdyb3Vu
ZA0KPiA+PiBleGVjdXRpb24sIGEgZnJhbWV3b3JrIGNvbmNlcHQuDQo+ID4NCj4gPiBXaGVuIGFu
IGFwcCB0cmFuc2l0aW9ucyBhbmQgYmVjb21lcyBjYWNoZWQsIHdlIGF0dGVtcHQgdG8gcmVjbGFp
bSBpdHMNCj4gPiBlbnRpcmUgd29ya2luZ3NldC4gV2UgYmFzaWNhbGx5IGNhdCBtZW1vcnkuY3Vy
cmVudCA+IG1lbW9yeS5yZWNsYWltDQo+ID4gYW5kIGZyZWV6ZSB0aGUgY2dyb3VwLg0KPiA+IGh0
dHBzOi8vY3MuYW5kcm9pZC5jb20vYW5kcm9pZC9wbGF0Zm9ybS9zdXBlcnByb2plY3QvKy9hbmRy
b2lkLWxhdGVzdC0NCj4gcmVsZWFzZTpzeXN0ZW0vY29yZS9saWJwcm9jZXNzZ3JvdXAvdGFza19w
cm9maWxlcy5jcHA7ZHJjPTY1YmQ3YWI5NDFhNzANCj4gOWJmMDQ5ODcxNDA2OTgxMDIyYjk4OGUx
NzIxO2w9NzA2DQo+ID4NCj4gPiBGaWxlIC8gYW5vbiBiYWxhbmNlIHZzIGhvdG5lc3MgYW5kIGdl
bmVyYXRpb25hbCBwbGFjZW1lbnQgZG9lc24ndA0KPiA+IG1hdHRlciBpbiB0aGF0IHNjZW5hcmlv
IGJlY2F1c2Ugd2Ugd2FudCB0byBnZXQgcmlkIG9mIGFsbCBvZiBpdC4gU28gSQ0KPiA+IGRvbid0
IHJlYWxseSB1bmRlcnN0YW5kIGhvdyB5b3UnZCB3YW50IHRvIHVzZSBhbiBhZ2luZyBrbm9iLg0K
PiA+DQo+IA0KPiBXaGVuIHRoZSBhcHAgYmVjb21lcyB0aGUgZm9yZWdyb3VuZCBhcHAgYWdhaW4s
IHJlY2xhaW1pbmcgYWxsIG9mIGl0cw0KPiBiYWNrZ3JvdW5kIG1lbWNnIG1lbW9yeSBtYXkgaW5j
cmVhc2UgcmVmYXVsdCBkYXRhLCB3aGljaCBtYXkgaW4gdHVybg0KPiBzbG93IGRvd24gd2FybS1s
YXVuY2ggcGVyZm9ybWFuY2UuDQo+IA0KPiAtLQ0KPiBCZXN0IHJlZ2FyZHMNCj4gUmlkb25nDQo+
IA0KDQpIaSBSaWRvbmcsDQoNCkFncmVlZC4gVGhhdCBpcyB0aGUgbW90aXZhdGlvbiBmb3IgcHJv
YWN0aXZlIGFnaW5nOiBrZWVwIHRoZSBmaWxlIGNhY2hlDQphbmQgc2hlZCBjb2xkIGFub255bW91
cyBwYWdlcywgc28gdGhlcmUgaXMgbGVzcyB0byByZWZhdWx0IG9uIHRoZQ0KbmV4dCBsYXVuY2gg
YW5kIHNjcm9sbCBqYW5rcy4gDQoNCkJlc3QsDQpaaWNoZW5nDQoNCg==
