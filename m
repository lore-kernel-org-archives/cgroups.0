From: =?utf-8?B?TGl4aW9uZyBMaXUgKOWImOWIqembhCk=?= 
        <Lixiong.Liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: cgroup user-after-free
Date: Wed, 1 Feb 2023 06:04:04 +0000
Message-ID: <3bb8e65797b905e4e9d4fad93a8f4fe26b8958a4.camel@mediatek.com>
References: <697032f2331a92eec0e03e85e46cb78bd975a788.camel@mediatek.com>
         <Y8Cwdsk5pYNd8fX8@slm.duckdns.org>
         <f8b24df3bd009d112479e9d5db36ec4afff9bb71.camel@mediatek.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=yzvs+YvZPWqNwv/4NYDDD2VPWghmfGCFkmwOGLsLv80=;
        b=Ia5xwtaPZzabpQtAtLr17Zd65MdHk9j20LQE4vRy6Glkf5Mgup9Qlupcq3Q4kSm57twDQKabz4v+RnoaQY8Wr4yLvdkb+oFYR0YDbJuy7NDhioQSxhp9dY/+P4nU+yGULhwPQzkpcmIA3jsK01K8UmWy+7KNuSN37XU3HEQmlHM=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzvs+YvZPWqNwv/4NYDDD2VPWghmfGCFkmwOGLsLv80=;
 b=iFFDfg9B/QexmaEKnag4XuFBs4a/g6a9JsZdss94cEnVWkWaVBZ5480dMXrmFCG3c9TWxbWVEuyf6vMeiVjV8N8jUFMChh5EEfiTY+S7cqxoI7MfrL7mrO3csTKkwHcoU9SyXsmdpcNEAR8AZDYHSmi5sJbXXzdHcbER0o87J00=
In-Reply-To: <f8b24df3bd009d112479e9d5db36ec4afff9bb71.camel-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <07E3047408019941B471670B8603DAC7-Ld2OyNlpylScE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?B?V2VuanUgWHUgKOiuuOaWh+S4vik=?= <Wenju.Xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, wsd_upstream <wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, =?utf-8?B?SmluZy1UaW5nIFd1ICjlkLPpnZzlqbcp?= <Jing-Ting.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?utf-8?B?V0ogV2FuZyAo546L5YabKQ==?= <wj.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, =?utf-8?B?QW5kcmVzcyBLdW8gKOmDreWtn+S/rik=?= <Andress.Kuo-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

T24gRnJpLCAyMDIzLTAxLTEzIGF0IDEzOjQwICswODAwLCBsaXhpb25nIGxpdSB3cm90ZToNCj4g
PiA+IFJvb3QgY2F1c2U6IA0KPiA+ID4gY2dyb3VwX21pZ3JhdGVfZmluaXNoIGZyZWUgY3NldOKA
mXMgY2dyb3VwLA0KPiA+ID4gDQo+ID4gPiBidXQgY2dyb3VwX3NrX2FsbG9jIHVzZSB0aGUgZnJl
ZWQgY2dyb3VwLA0KPiA+ID4gDQo+ID4gPiB0aGVuIHVzZS1hZnRlci1mcmVlIGhhcHBlbmVkLg0K
PiA+IA0KPiA+IFNvdW5kcyBzaW1pbGFyIHRvIHRoZSBwcm9ibGVtIGZpeGVkIGJ5IDA3ZmQ1YjZj
ZGYzYyAoImNncm91cDogVXNlDQo+ID4gc2VwYXJhdGUNCj4gPiBzcmMvZHN0IG5vZGVzIHdoZW4g
cHJlbG9hZGluZyBjc3Nfc2V0cyBmb3IgbWlncmF0aW9uIikuIENhbiB5b3UgdHJ5DQo+ID4gaXQg
b3V0Pw0KPiA+IA0KPiA+IFRoYW5rcy4NCj4gPiANCj4gDQo+IA0KPiBUaGFua3MgZm9yIHlvdXIg
cXVpY2sgZmVlZGJhY2suDQo+IA0KPiANCj4gICANCj4gQnV0IHdlIGVuY291bnRlcmVkIHVzZS1h
ZnRlci1mcmVlIHZlcnNpb24NCj4gDQo+IGFscmVhZHkgY29udGFpbnMgdGhpcyBwYXRjaC4NCj4g
DQo+IA0KPiANCj4gU28sIHdpdGggdGhpcyBwYXRjaCB3aWxsIGFsc28gZW5jb3VudGVyDQo+IA0K
PiB0aGlzIHVzZS1hZnRlci1mcmVlLg0KPiANCj4gVGhhbmtzIQ0KPiANCj4gDQogIERvIHlvdSBo
YXZlIGFueSBzdWdnZXN0aW9uIGZvciB0aGlzIGlzc3VlPw0KDQogIEJlc3QgcmVnYXJkcywNCiAg
TGl4aW9uZyBMaXUNCg==
