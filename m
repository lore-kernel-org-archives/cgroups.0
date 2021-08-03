From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 2/5] mm, memcg: narrow the scope of percpu_charge_mutex
Date: Tue, 3 Aug 2021 07:13:35 +0000
Message-ID: <898130C3-FDF2-41C2-81DD-D33721C977C6@fb.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-3-linmiaohe@huawei.com> <YQNsxVPsRSBZcfGG@carbon.lan>
 <YQOhGs3k9rHx3mmT@dhcp22.suse.cz>
 <4a3c23c4-054c-2896-29c5-8cf9a4deee98@huawei.com>
 <YQi6lOT6j2DtOGlT@carbon.dhcp.thefacebook.com>
 <95629d91-6ae8-b445-e7fc-b51c888cad59@huawei.com>,<YQjsHTW+46bG9XsV@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=79998fF840Dkp1r85lrkR0Hrx1OGK4+YPPULC29XaVU=;
 b=BHdHla4gn44VGrNW9wfr1B9ZLxUfrUOcdGGdJ4AFVO6nkIPSam4d1OpzD3+iZUobmvT7
 7wNJJNzicBb72YtHDK76GI7K7a7audDzjrM5Qa6AaA2DW5e6mOaJd0T/ShFfQCNrGy4S
 KFblB9ukZlenK6bWB78YthydEpBn1+/78Ho= 
In-Reply-To: <YQjsHTW+46bG9XsV-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org" <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

SeKAmWQgZ28gd2l0aCBhdG9taWNfZGVjKCkuDQoNClNlbnQgZnJvbSBteSBpUGhvbmUNCg0KPiBP
biBBdWcgMywgMjAyMSwgYXQgMDA6MTEsIE1pY2hhbCBIb2NrbyA8bWhvY2tvQHN1c2UuY29tPiB3
cm90ZToNCj4gDQo+IO+7v09uIFR1ZSAwMy0wOC0yMSAxNDoyOToxMywgTWlhb2hlIExpbiB3cm90
ZToNCj4gWy4uLl0NCj4+IGRpZmYgLS1naXQgYS9tbS9tZW1jb250cm9sLmMgYi9tbS9tZW1jb250
cm9sLmMNCj4+IGluZGV4IDYxNmQxYTcyZWNlMy4uNjIxMGIxMTI0OTI5IDEwMDY0NA0KPj4gLS0t
IGEvbW0vbWVtY29udHJvbC5jDQo+PiArKysgYi9tbS9tZW1jb250cm9sLmMNCj4+IEBAIC0yMjA4
LDExICsyMjA4LDExIEBAIHN0YXRpYyB2b2lkIHJlZmlsbF9zdG9jayhzdHJ1Y3QgbWVtX2Nncm91
cCAqbWVtY2csIHVuc2lnbmVkIGludCBucl9wYWdlcykNCj4+ICAqLw0KPj4gc3RhdGljIHZvaWQg
ZHJhaW5fYWxsX3N0b2NrKHN0cnVjdCBtZW1fY2dyb3VwICpyb290X21lbWNnKQ0KPj4gew0KPj4g
LSAgICAgICBzdGF0aWMgREVGSU5FX01VVEVYKHBlcmNwdV9jaGFyZ2VfbXV0ZXgpOw0KPj4gICAg
ICAgIGludCBjcHUsIGN1cmNwdTsNCj4+ICsgICAgICAgc3RhdGljIGF0b21pY190IGRyYWluZXIg
PSBBVE9NSUNfSU5JVCgwKTsNCj4+IA0KPj4gICAgICAgIC8qIElmIHNvbWVvbmUncyBhbHJlYWR5
IGRyYWluaW5nLCBhdm9pZCBhZGRpbmcgcnVubmluZyBtb3JlIHdvcmtlcnMuICovDQo+PiAtICAg
ICAgIGlmICghbXV0ZXhfdHJ5bG9jaygmcGVyY3B1X2NoYXJnZV9tdXRleCkpDQo+PiArICAgICAg
IGlmIChhdG9taWNfY21weGNoZygmZHJhaW5lciwgMCwgMSkgIT0gMCkNCj4+ICAgICAgICAgICAg
ICAgIHJldHVybjsNCj4+ICAgICAgICAvKg0KPj4gICAgICAgICAqIE5vdGlmeSBvdGhlciBjcHVz
IHRoYXQgc3lzdGVtLXdpZGUgImRyYWluIiBpcyBydW5uaW5nDQo+PiBAQCAtMjI0NCw3ICsyMjQ0
LDcgQEAgc3RhdGljIHZvaWQgZHJhaW5fYWxsX3N0b2NrKHN0cnVjdCBtZW1fY2dyb3VwICpyb290
X21lbWNnKQ0KPj4gICAgICAgICAgICAgICAgfQ0KPj4gICAgICAgIH0NCj4+ICAgICAgICBwdXRf
Y3B1KCk7DQo+PiAtICAgICAgIG11dGV4X3VubG9jaygmcGVyY3B1X2NoYXJnZV9tdXRleCk7DQo+
PiArICAgICAgIGF0b21pY19zZXQoJmRyYWluZXIsIDApOw0KPiANCj4gYXRvbWljX3NldCBkb2Vz
bid0IGltcGx5IG1lbW9yeSBiYXJyaWVyIElJUkMuIElzIHRoaXMgc2FmZT8NCj4gDQo+IC0tIA0K
PiBNaWNoYWwgSG9ja28NCj4gU1VTRSBMYWJzDQo=
