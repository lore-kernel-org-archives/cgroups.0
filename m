From: Rik van Riel <riel-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: fix occasional OOMs due to proportional
 memory.low reclaim
Date: Tue, 17 Aug 2021 18:44:11 +0000
Message-ID: <0f4b106ad6f7dc8ac6a56b98861a9b65bdd66bc5.camel@fb.com>
References: <20210817180506.220056-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5cDldqj3vFq1S2OIX4yKJ4U+Z9fA7hc6GDBfB+wmUyU=;
 b=GHmEsk0uo9X+kPGXC+EMJz8P0SNccS47ioNuxQP+wqeObo1ZzJ9ZH0BNtwGViViwdUpu
 KPzJGZLZmltoe0e9kNhILp7Ec33xCLLyh0crHR4iExNb0G0xXkNqVhszjHl/t/5E82gS
 eAYgy2184Jk1DTwa/vz+YRfTmsVpvUPmIqY= 
In-Reply-To: <20210817180506.220056-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Content-Language: en-US
Content-ID: <FA6DBFDE1046CC4AB0DEB70F6AB46055-JGF9Izt3QrScE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org" <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Leon Yang <lnyng-b10kYP2dOMg@public.gmane.org>, "mhocko-IBi9RG/b67k@public.gmane.org" <mhocko-IBi9RG/b67k@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <Kernel-team-b10kYP2dOMg@public.gmane.org>

T24gVHVlLCAyMDIxLTA4LTE3IGF0IDE0OjA1IC0wNDAwLCBKb2hhbm5lcyBXZWluZXIgd3JvdGU6
DQo+IFRvIGZpeCB0aGlzLCBob29rIHByb3BvcnRpb25hbCByZWNsYWltIGludG8gdGhlIHNhbWUg
cmV0cnkgbG9naWMgd2UNCj4gaGF2ZSBpbiBwbGFjZSBmb3Igd2hlbiBjZ3JvdXBzIGFyZSBza2lw
cGVkIGVudGlyZWx5LiBUaGlzIHdheSBpZg0KPiByZWNsYWltIGZhaWxzIGFuZCBzb21lIGNncm91
cHMgd2VyZSBzY2FubmVkIHdpdGggZGltaXNoZWQgcHJlc3N1cmUsDQo+IHdlJ2xsIHRyeSBhbm90
aGVyIGZ1bGwtZm9yY2UgY3ljbGUgYmVmb3JlIGdpdmluZyB1cCBhbmQgT09NaW5nLg0KDQpHb29k
IGNhdGNoLg0KDQo+IFJlcG9ydGVkLWJ5OiBMZW9uIFlhbmcgPGxueW5nQGZiLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogSm9oYW5uZXMgV2VpbmVyIDxoYW5uZXNAY21weGNoZy5vcmc+DQoNClJldmll
d2VkLWJ5OiBSaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+DQo=
