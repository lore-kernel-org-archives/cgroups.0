From: "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Subject: Re: [PATCH 01/16] lib: fix match_string() helper on -1 array size
Date: Wed, 8 May 2019 11:31:15 +0000
Message-ID: <c8cfa5dbdfc0b0665d1b48f37ba57c3ec1233197.camel@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
         <20190508112842.11654-2-alexandru.ardelean@analog.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5znCPRPKBRTF+JsmgIj6aBz2AD2vefu9H7uU0wxS3Bk=;
 b=ST5Z/dIpKXaTMbKZaXyicKhHdXlzGRr2cvNr4QiUG7GY+t2c8tYrS8HUzZk7zoQX2Sqwe4wEAPF+A8JRA7yBnsNWwHplIEFbWx98uHp1nu1y/AQc7kTAAlpBLD/QdcBgnMXwfvYN222CXVA7LOxKe+AxnGT9uWSdnYuXbWlIovg=
In-Reply-To: <20190508112842.11654-2-alexandru.ardelean@analog.com>
Content-Language: en-US
Content-ID: <BE083E2328EDB84B98DBA67ED168014A@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, devel@driverdev.osu
Cc: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>

T24gV2VkLCAyMDE5LTA1LTA4IGF0IDE0OjI4ICswMzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3Jv
dGU6DQo+IFRoZSBkb2N1bWVudGF0aW9uIHRoZSBgX21hdGNoX3N0cmluZygpYCBoZWxwZXIgbWVu
dGlvbnMgdGhhdCBgbmANCj4gc2hvdWxkIGJlOg0KPiAgKiBAbjogbnVtYmVyIG9mIHN0cmluZ3Mg
aW4gdGhlIGFycmF5IG9yIC0xIGZvciBOVUxMIHRlcm1pbmF0ZWQgYXJyYXlzDQo+IA0KPiBUaGUg
YmVoYXZpb3Igb2YgdGhlIGZ1bmN0aW9uIGlzIGRpZmZlcmVudCwgaW4gdGhlIHNlbnNlIHRoYXQg
aXQgZXhpdHMgb24NCj4gdGhlIGZpcnN0IE5VTEwgZWxlbWVudCBpbiB0aGUgYXJyYXksIHJlZ2Fy
ZGxlc3Mgb2Ygd2hldGhlciBgbmAgaXMgLTEgb3IgYQ0KPiBwb3NpdGl2ZSBudW1iZXIuDQo+IA0K
PiBUaGlzIHBhdGNoIGNoYW5nZXMgdGhlIGJlaGF2aW9yLCB0byBleGl0IHRoZSBsb29wIHdoZW4g
YSBOVUxMIGVsZW1lbnQgaXMNCj4gZm91bmQgYW5kIG4gPT0gLTEuIEVzc2VudGlhbGx5LCB0aGlz
IGFsaWducyB0aGUgYmVoYXZpb3Igd2l0aCB0aGUNCj4gZG9jLXN0cmluZy4NCj4gDQo+IFRoZXJl
IGFyZSBjdXJyZW50bHkgbWFueSB1c2VycyBvZiBgbWF0Y2hfc3RyaW5nKClgLCBhbmQgc28sIGlu
IG9yZGVyIHRvDQo+IGdvDQo+IHRocm91Z2ggdGhlbSwgdGhlIG5leHQgcGF0Y2hlcyBpbiB0aGUg
c2VyaWVzIHdpbGwgZm9jdXMgb24gZG9pbmcgc29tZQ0KPiBjb3NtZXRpYyBjaGFuZ2VzLCB3aGlj
aCBhcmUgYWltZWQgYXQgZ3JvdXBpbmcgdGhlIHVzZXJzIG9mDQo+IGBtYXRjaF9zdHJpbmcoKWAu
DQo+IA0KDQpUaGlzIGlzIHRoZSBkdXBsaWNhdGUgJiBzaG91bGQgYmUgZHJvcHBlZC4NClNvcnJ5
IGZvciB0aGlzLg0KDQo+IFNpZ25lZC1vZmYtYnk6IEFsZXhhbmRydSBBcmRlbGVhbiA8YWxleGFu
ZHJ1LmFyZGVsZWFuQGFuYWxvZy5jb20+DQo+IC0tLQ0KPiAgbGliL3N0cmluZy5jIHwgNSArKysr
LQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiAN
Cj4gZGlmZiAtLWdpdCBhL2xpYi9zdHJpbmcuYyBiL2xpYi9zdHJpbmcuYw0KPiBpbmRleCAzYWI4
NjFjMWE4NTcuLjc2ZWRiN2JmNzZjYiAxMDA2NDQNCj4gLS0tIGEvbGliL3N0cmluZy5jDQo+ICsr
KyBiL2xpYi9zdHJpbmcuYw0KPiBAQCAtNjQ4LDggKzY0OCwxMSBAQCBpbnQgbWF0Y2hfc3RyaW5n
KGNvbnN0IGNoYXIgKiBjb25zdCAqYXJyYXksIHNpemVfdA0KPiBuLCBjb25zdCBjaGFyICpzdHJp
bmcpDQo+ICANCj4gIAlmb3IgKGluZGV4ID0gMDsgaW5kZXggPCBuOyBpbmRleCsrKSB7DQo+ICAJ
CWl0ZW0gPSBhcnJheVtpbmRleF07DQo+IC0JCWlmICghaXRlbSkNCj4gKwkJaWYgKCFpdGVtKSB7
DQo+ICsJCQlpZiAobiAhPSAoc2l6ZV90KS0xKQ0KPiArCQkJCWNvbnRpbnVlOw0KPiAgCQkJYnJl
YWs7DQo+ICsJCX0NCj4gIAkJaWYgKCFzdHJjbXAoaXRlbSwgc3RyaW5nKSkNCj4gIAkJCXJldHVy
biBpbmRleDsNCj4gIAl9DQo=
