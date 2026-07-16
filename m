Received: from mta21.hihonor.com (mta21.hihonor.com [81.70.160.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24752343885;
	Thu, 16 Jul 2026 03:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=81.70.160.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784172904; cv=none; b=T+XACGlRFPVAT5MPDH4thG6+SiqIqMXzvWKxIOaaGG9eRZA5CgYshdo/QFYxnTGpn82+Ph1N7mxYBZ2PYKswFxnBNRwdu1PBFEy8iS/5NDKX/NUsXkexPv2gMATg3QqIZ4qOVM/T2Q0jARdVoSamUMJqAMR+pc7NMdoY5wqqSV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784172904; c=relaxed/simple;
	bh=5+8+NbPuaGLWx5/PBVIMntj2fE0TmHgC7SasPUv0ypc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZV43QCx1+1/rHQG9JKlUR2csTLoHB7ihhv2ljNOLmPN2AtpLGW46WYUpnK9wMFe3HFQ60szfyWuEUp6+Tau2t845Up2UAeutOY21OW0qCEIbSDDnAqsVGPS0y9GlDBWRm4hRvgsxStnNwNQ6H0gfHBcBYlzgYBGtugIIAx5Caxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=honor.com; spf=pass smtp.mailfrom=honor.com; arc=none smtp.client-ip=81.70.160.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=honor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=honor.com
Received: from TW002-1.hihonor.com (unknown [10.72.0.137])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4h0zFB0cGPzYlKMk;
	Thu, 16 Jul 2026 11:34:54 +0800 (CST)
Received: from TA009-1.hihonor.com (10.77.226.44) by TW002-1.hihonor.com
 (10.72.0.137) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 16 Jul
 2026 11:34:53 +0800
Received: from TA012-1.hihonor.com (10.77.199.132) by TA009-1.hihonor.com
 (10.77.226.44) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 16 Jul
 2026 11:34:53 +0800
Received: from TA012-1.hihonor.com ([fe80::6668:8cd2:ec5c:99b2]) by
 TA012-1.hihonor.com ([fe80::6668:8cd2:ec5c:99b2%13]) with mapi id
 15.02.2562.017; Thu, 16 Jul 2026 11:34:43 +0800
From: wangzicheng <wangzicheng@honor.com>
To: "T.J. Mercier" <tjmercier@google.com>
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
Thread-Index: AQHdE4pwfI2vhxgx7kyzLikejPZWhrZuWS0AgAEfKFA=
Date: Thu, 16 Jul 2026 03:34:42 +0000
Message-ID: <75116e612e8142f4ada1dfcc834ceb09@honor.com>
References: <20260714121529.2237261-1-wangzicheng@honor.com>
 <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
In-Reply-To: <CABdmKX3y841t4Oqg3RRHTGXWP-LMMSi_exDuxAc4jR9v9ChD2g@mail.gmail.com>
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

PiBPbiBUdWUsIEp1bCAxNCwgMjAyNiBhdCA1OjE14oCvQU0gWmljaGVuZyBXYW5nIDx3YW5nemlj
aGVuZ0Bob25vci5jb20+DQo+IHdyb3RlOg0KPiA+IFRoZSBiZW5lZml0IGlzIHdvcmtsb2FkLWRl
cGVuZGVudDogZmlsZS1jYWNoZS1ib3VuZCBzZXJ2ZXJzIGdhaW4gZnJvbQ0KPiA+IGFnaW5nLCBh
bm9uLWJvdW5kIHNlcnZlcnMgZG8gbm90LCBzbyBubyBrZXJuZWwgZGVmYXVsdCBpcyBjb3JyZWN0
IGZvcg0KPiA+IGFsbC4gIFRoZSBrZXJuZWwgYWxzbyBjYW5ub3Qga25vdyB3aGVuIHRvIGFnZTog
b24gQW5kcm9pZCB0aGUgcmlnaHQNCj4gPiBtb21lbnQgaXMgdGhlIGZvcmVncm91bmQtdG8tYmFj
a2dyb3VuZCB0cmFuc2l0aW9uLCB3aGVuIHRoZSBhcHAncyBwYWdlcw0KPiA+IGFyZSBjb2xkIGJ1
dCB0aGVpciBQVEUgYWNjZXNzZWQgYml0cyBhcmUgc3RpbGwgYWNjdXJhdGUgZnJvbSBmb3JlZ3Jv
dW5kDQo+ID4gZXhlY3V0aW9uLCBhIGZyYW1ld29yayBjb25jZXB0Lg0KPiANCj4gV2hlbiBhbiBh
cHAgdHJhbnNpdGlvbnMgYW5kIGJlY29tZXMgY2FjaGVkLCB3ZSBhdHRlbXB0IHRvIHJlY2xhaW0g
aXRzDQo+IGVudGlyZSB3b3JraW5nc2V0LiBXZSBiYXNpY2FsbHkgY2F0IG1lbW9yeS5jdXJyZW50
ID4gbWVtb3J5LnJlY2xhaW0NCj4gYW5kIGZyZWV6ZSB0aGUgY2dyb3VwLg0KPiBodHRwczovL2Nz
LmFuZHJvaWQuY29tL2FuZHJvaWQvcGxhdGZvcm0vc3VwZXJwcm9qZWN0LysvYW5kcm9pZC1sYXRl
c3QtDQo+IHJlbGVhc2U6c3lzdGVtL2NvcmUvbGlicHJvY2Vzc2dyb3VwL3Rhc2tfcHJvZmlsZXMu
Y3BwO2RyYz02NWJkN2FiOTQxYTcwDQo+IDliZjA0OTg3MTQwNjk4MTAyMmI5ODhlMTcyMTtsPTcw
Ng0KPiANCj4gRmlsZSAvIGFub24gYmFsYW5jZSB2cyBob3RuZXNzIGFuZCBnZW5lcmF0aW9uYWwg
cGxhY2VtZW50IGRvZXNuJ3QNCj4gbWF0dGVyIGluIHRoYXQgc2NlbmFyaW8gYmVjYXVzZSB3ZSB3
YW50IHRvIGdldCByaWQgb2YgYWxsIG9mIGl0LiBTbyBJDQo+IGRvbid0IHJlYWxseSB1bmRlcnN0
YW5kIGhvdyB5b3UnZCB3YW50IHRvIHVzZSBhbiBhZ2luZyBrbm9iLg0KDQpIaSBULkouLA0KDQpU
aGFua3MgZm9yIHRoZSByZWZlcmVuY2UuDQoNCldlIGtub3cgQW5kcm9pZCByZWNsYWltcyB0aGUg
ZW50aXJlIHdvcmtpbmdzZXQgYW5kIGZyZWV6ZXMgdGhlIGNncm91cA0Kb24gYmFja2dyb3VuZGlu
ZyAod2UgZGlzY3Vzc2VkIHRoaXMgYXQgTFNGL01NL0JQRiAyMDI2LCBpZiBJIHJlY2FsbCkuDQpX
ZSBhcmUgY29uY2VybmVkIGFib3V0IHBlcmZvcm1hbmNlOiB0aGF0IG1lYW5zIGEgc3Vic2VxdWVu
dCBob3Qgc3RhcnQNCmhhcyB0byByZS1mYXVsdCB0aGUgd2hvbGUgc2V0LCB3aGljaCBtYXkgaW5j
cmVhc2UgSU8sIENQVSwgYW5kIHBvd2VyDQpjb3N0LiBXZSB3b3VsZCBwcmVmZXIgYSByZWNsYWlt
IHJhdGlvIHR1bmVkIHBlciBTb0MsIHRyYWRpbmcgbWVtb3J5DQpoZWFkcm9vbSBhZ2FpbnN0IGhv
dC1zdGFydCBsYXRlbmN5Lg0KDQpQcm9hY3RpdmUgYWdpbmcgaXMgd2hhdCBtYWtlcyB0aGF0IHdv
cmthYmxlOiBhZ2UgZmlyc3Qgc28gYW5vbnltb3VzDQpwYWdlcyBiZWNvbWUgcmVjbGFpbWFibGUs
IHRoZW4gcmVjbGFpbSB0aGVtIHdoaWxlIHJldGFpbmluZyB0aGUgZmlsZQ0KY2FjaGUuDQoNCmZn
LT5iZyBpcyBhIHNpbXBsZSBhbmQgZWZmZWN0aXZlIGhldXJpc3RpYy4gUHJvYWN0aXZlIGFnaW5n
IGlzIHVzZWZ1bA0KYmV5b25kIGl0OiBvbiBmaWxlLWNhY2hlLWJvdW5kIHNlcnZlcnMgKGZpbyBy
YW5kb20tcmVhZCArMzEuOCUgaW4gb3VyDQptZWFzdXJlbWVudHMpLCBhbmQgbGlrZWx5IGluIG90
aGVyIEFuZHJvaWQgc2NlbmFyaW9zIHdlIGhhdmUgbm90IHlldA0KZXhwbG9yZWQuDQogIA0KQmVz
dCwNClppY2hlbmcNCg==
