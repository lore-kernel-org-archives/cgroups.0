From: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper
 size
Date: Fri, 28 Jul 2023 02:26:45 +0000
Message-ID: <CH3PR11MB7345C15CA3D7C5E630BF1353FC06A@CH3PR11MB7345.namprd11.prod.outlook.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com>
 <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
 <CH3PR11MB7345E9EAC5917338F1C357C0FC789@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod6txDQ9kOHrNFL64XiKxmbVHqMtWNiptUdGt9UuhQVLOQ@mail.gmail.com>
 <ZGMYz+08I62u+Yeu@xsang-OptiPlex-9020>
 <20230517162447.dztfzmx3hhetfs2q@google.com>
 <CANn89iL0SD=F69b=naEmzoKysscnHGX7tP6jF9MOvthSeZ53Pw@mail.gmail.com>
 <CALvZod6LFdydR5Zdhx1SMgknxTUJgabewi5-Ux6U=nO105GPSg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690511209; x=1722047209;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=HwzsRqxzjCszbsy1MnuNxvXF/3BkBEt4OqzXHy0+Ojo=;
  b=aNd+BC+Fq0GtoaVHeWk5cxO7E178jmqdl+ijxDt4gV8Y866bWf4Z93gk
   XjrsST2epKZCylX9tSjCs0OtG4HqpoCotPDYsmgdNGLTD2GRSe5WZrJFQ
   paSzqb5Xy8lexP6/9+nbO5dAswMh7E63Fn+heM9PAvWMrTIFvuTG37TKb
   8XtUsZMilRQZYq/9nPAM1qXET5BcAKT2AShSAYpGwJ+nl2GPTgVrwYhoe
   t5SurTFacyII7g7ObKULojz6OBN8bG+j17w6z9TymGNbwVKjOxrbd9pBW
   XWj2QO7SE4kBEAVE+sVgim+QuAqgo63eZzHvnEEUW/bPQHzNq8jaGmdj4
   Q==;
In-Reply-To: <CALvZod6LFdydR5Zdhx1SMgknxTUJgabewi5-Ux6U=nO105GPSg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Sang, Oliver" <oliver.sang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Yin, Fengwei" <fengwei.yin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Tang, Feng" <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Li, Philip" <philip.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Liu, Yujie" <yujie.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

IA0KPiBUaGUgaGllcmFyY2hpY2FsIG5hdHVyZSBvZiBtZW1jZyBtYWtlcyB0aGF0IGEgYml0IGNv
bXBsaWNhdGVkLiBXZSBoYXZlDQo+IHNvbWV0aGluZyBzaW1pbGFyIGZvciBtZW1jZyBzdGF0cyB3
aGljaCBpcyByc3RhdCBpbmZyYSB3aGVyZSB0aGUgc3RhdHMgYXJlDQo+IHNhdmVkIHBlci1tZW1j
ZyBwZXItY3B1IGFuZCBnZXQgYWNjdW11bGF0ZWQgaGllcmFyY2hpY2FsbHkgZXZlcnkgMg0KPiBz
ZWNvbmRzLiBUaGlzIHdvcmtzIGZpbmUgZm9yIHN0YXRzIGJ1dCBmb3IgbGltaXRzIHRoZXJlIHdv
dWxkIGJlIGEgbmVlZCBmb3INCj4gc29tZSBhZGRpdGlvbmFsIHJlc3RyaWN0aW9ucy4NCj4gDQo+
IEFsc28gc29tZXRpbWUgYWdvIEFuZHJldyBhc2tlZCBtZSB0byBleHBsb3JlIHJlcGxhY2luZyB0
aGUgYXRvbWljIGNvdW50ZXINCj4gaW4gcGFnZV9jb3VudGVyIHdpdGggcGVyY3B1X2NvdW50ZXIu
IEludHVpdGlvbiBpcyB0aGF0IG1vc3Qgb2YgdGhlIHRpbWUgdGhlDQo+IHVzYWdlIGlzIG5vdCBo
aXR0aW5nIHRoZSBsaW1pdCwgc28gd2UgY2FuIHVzZSBfX3BlcmNwdV9jb3VudGVyX2NvbXBhcmUg
Zm9yDQo+IGVuZm9yY2VtZW50Lg0KPiANCj4gTGV0IG1lIHNwZW5kIHNvbWUgdGltZSB0byBleHBs
b3JlIHBlci1tZW1jZyBwZXItY3B1IGNhY2hlIG9yIGlmDQo+IHBlcmNwdV9jb3VudGVyIHdvdWxk
IGJlIGJldHRlci4NCg0KR3JlZXRpbmdzIFNoYWtlZWwsDQoNCkhvcGUgdGhpcyBtZXNzYWdlIGZp
bmRzIHlvdSB3ZWxsLiBJIHdhbnQgdG8gaW5xdWlyeSBhYm91dCB0aGUgY3VycmVudCBzdGF0dXMg
b2YNCnRoZSBmaXhpbmcuIEhhdmUgeW91IGNvbXBsZXRlZCB0aGUgZXZhbHVhdGlvbiBhbmQgc3Rh
cnRlZCB3b3JraW5nIG9uIHRoZSBmaW5hbA0Kc29sdXRpb24/DQoNCj4gDQo+IEZvciBub3csIHRo
aXMgcGF0Y2ggaXMgbW9yZSBsaWtlIGFuIFJGQy4NCg==
