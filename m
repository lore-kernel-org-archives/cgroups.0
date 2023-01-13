From: =?utf-8?B?TGl4aW9uZyBMaXUgKOWImOWIqembhCk=?= 
        <Lixiong.Liu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>
Subject: Re: cgroup user-after-free
Date: Fri, 13 Jan 2023 05:40:08 +0000
Message-ID: <f8b24df3bd009d112479e9d5db36ec4afff9bb71.camel@mediatek.com>
References: <697032f2331a92eec0e03e85e46cb78bd975a788.camel@mediatek.com>
         <Y8Cwdsk5pYNd8fX8@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=NYbeQh7Rgw1KknPgPEBf6Uxnq0LgTEYU6DiZQiPCXTw=;
        b=PwWmZf7LpqsdSAKthP5lAa08228STm5VEK0ShPH7eZ4MGtDuZagdGnPyW6VibYs7G5h4jcwibuPX+gnNve7sWC0QPhFeDwnAGrJJiqOCkC/qwbEgPAZg/SacqmMpNIOnriOCKNXFAB99vV/UhIqnWgdZ75WJ9KBIrd8Tyn24CWE=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYbeQh7Rgw1KknPgPEBf6Uxnq0LgTEYU6DiZQiPCXTw=;
 b=RFUNMO/2x0xxQwk7dIg92fvy2RcTSDXoBFmNhOidXkEcnwpRAffSdx2RXl29oNaz3rN05h7HrAxg1UB6WFlIl+2WXLlwNhEj8u7eFaW6OxTWFX6b7TTRHmq9TYtTzSEJZLxlhjq138LSjZszbuLpSEWUz3/DZ99msWtTGdaBDqY=
In-Reply-To: <Y8Cwdsk5pYNd8fX8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
Content-ID: <C0A90EC1935DAD4A9CBB0ED17B719D39-Ld2OyNlpylScE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?B?V2VuanUgWHUgKOiuuOaWh+S4vik=?= <Wenju.Xu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, wsd_upstream <wsd_upstream-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, =?utf-8?B?SmluZy1UaW5nIFd1ICjlkLPpnZzlqbcp?= <Jing-Ting.Wu-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?utf-8?B?V0ogV2FuZyAo546L5YabKQ==?= <wj.wang-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, =?utf-8?B?QW5kcmVzcyBLdW8gKOmDreWtn+S/rik=?= <Andress.Kuo-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org>, "matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

PiA+IFJvb3QgY2F1c2U6IA0KPiA+IGNncm91cF9taWdyYXRlX2ZpbmlzaCBmcmVlIGNzZXTigJlz
IGNncm91cCwNCj4gPiANCj4gPiBidXQgY2dyb3VwX3NrX2FsbG9jIHVzZSB0aGUgZnJlZWQgY2dy
b3VwLA0KPiA+IA0KPiA+IHRoZW4gdXNlLWFmdGVyLWZyZWUgaGFwcGVuZWQuDQo+IA0KPiBTb3Vu
ZHMgc2ltaWxhciB0byB0aGUgcHJvYmxlbSBmaXhlZCBieSAwN2ZkNWI2Y2RmM2MgKCJjZ3JvdXA6
IFVzZQ0KPiBzZXBhcmF0ZQ0KPiBzcmMvZHN0IG5vZGVzIHdoZW4gcHJlbG9hZGluZyBjc3Nfc2V0
cyBmb3IgbWlncmF0aW9uIikuIENhbiB5b3UgdHJ5DQo+IGl0IG91dD8NCj4gDQo+IFRoYW5rcy4N
Cj4gDQoNCg0KVGhhbmtzIGZvciB5b3VyIHF1aWNrIGZlZWRiYWNrLg0KDQoNCiAgDQpCdXQgd2Ug
ZW5jb3VudGVyZWQgdXNlLWFmdGVyLWZyZWUgdmVyc2lvbg0KDQphbHJlYWR5IGNvbnRhaW5zIHRo
aXMgcGF0Y2guDQoNCg0KDQpTbywgd2l0aCB0aGlzIHBhdGNoIHdpbGwgYWxzbyBlbmNvdW50ZXIN
Cg0KdGhpcyB1c2UtYWZ0ZXItZnJlZS4NCg0KVGhhbmtzIQ0KDQoNCg0KQmVzdCByZWdhcmRzLA0K
TGl4aW9uZyBMaXUNCg==
