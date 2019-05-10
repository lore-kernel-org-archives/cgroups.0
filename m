From: "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Subject: Re: [PATCH 03/16] lib,treewide: add new match_string() helper/macro
Date: Fri, 10 May 2019 09:15:27 +0000
Message-ID: <4df165bc4247e60aa4952fd55cb0c77e60712767.camel@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
         <20190508112842.11654-5-alexandru.ardelean@analog.com>
         <20190508131128.GL9224@smile.fi.intel.com>
         <20190508131856.GB10138@kroah.com>
         <b2440bc9485456a7a90a488c528997587b22088b.camel@analog.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wSA47lRaD47gVkjnR4QZVVI1SlFOWw1QUqW5W1oYeBg=;
 b=P6j9qkyh/W9HoJNWlkiVn/q6miOnRfxuL4pYK6RankU/nkLaNOXsosVR+gcsuu3XAwFd6cCTRB1MoJlA6P/+7hwoSPcs/v94ubYmmHkZsEjQZMDFPXRh598iyCuxRg3vxxT0+p7oYdCqVHV63UCp9RKgx9ZRCph3+zfILCQVp14=
In-Reply-To: <b2440bc9485456a7a90a488c528997587b22088b.camel@analog.com>
Content-Language: en-US
Content-ID: <BE5857B429D5854D8FB2F6D2ED721097@analog.com>
Sender: netdev-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, devel@driverdev.osu

T24gV2VkLCAyMDE5LTA1LTA4IGF0IDE2OjIyICswMzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3Jv
dGU6DQo+IE9uIFdlZCwgMjAxOS0wNS0wOCBhdCAxNToxOCArMDIwMCwgR3JlZyBLSCB3cm90ZToN
Cj4gPiANCj4gPiANCj4gPiBPbiBXZWQsIE1heSAwOCwgMjAxOSBhdCAwNDoxMToyOFBNICswMzAw
LCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+ID4gPiBPbiBXZWQsIE1heSAwOCwgMjAxOSBhdCAw
MjoyODoyOVBNICswMzAwLCBBbGV4YW5kcnUgQXJkZWxlYW4gd3JvdGU6DQo+ID4gPiA+IFRoaXMg
Y2hhbmdlIHJlLWludHJvZHVjZXMgYG1hdGNoX3N0cmluZygpYCBhcyBhIG1hY3JvIHRoYXQgdXNl
cw0KPiA+ID4gPiBBUlJBWV9TSVpFKCkgdG8gY29tcHV0ZSB0aGUgc2l6ZSBvZiB0aGUgYXJyYXku
DQo+ID4gPiA+IFRoZSBtYWNybyBpcyBhZGRlZCBpbiBhbGwgdGhlIHBsYWNlcyB0aGF0IGRvDQo+
ID4gPiA+IGBtYXRjaF9zdHJpbmcoX2EsIEFSUkFZX1NJWkUoX2EpLCBzKWAsIHNpbmNlIHRoZSBj
aGFuZ2UgaXMgcHJldHR5DQo+ID4gPiA+IHN0cmFpZ2h0Zm9yd2FyZC4NCj4gPiA+IA0KPiA+ID4g
Q2FuIHlvdSBzcGxpdCBpbmNsdWRlL2xpbnV4LyBjaGFuZ2UgZnJvbSB0aGUgcmVzdD8NCj4gPiAN
Cj4gPiBUaGF0IHdvdWxkIGJyZWFrIHRoZSBidWlsZCwgd2h5IGRvIHlvdSB3YW50IGl0IHNwbGl0
IG91dD8gIFRoaXMgbWFrZXMNCj4gPiBzZW5zZSBhbGwgYXMgYSBzaW5nbGUgcGF0Y2ggdG8gbWUu
DQo+ID4gDQo+IA0KPiBOb3QgcmVhbGx5Lg0KPiBJdCB3b3VsZCBiZSBqdXN0IGJlIHRoZSBuZXcg
bWF0Y2hfc3RyaW5nKCkgaGVscGVyL21hY3JvIGluIGEgbmV3IGNvbW1pdC4NCj4gQW5kIHRoZSBj
b252ZXJzaW9ucyBvZiB0aGUgc2ltcGxlIHVzZXJzIG9mIG1hdGNoX3N0cmluZygpICh0aGUgb25l
cyB1c2luZw0KPiBBUlJBWV9TSVpFKCkpIGluIGFub3RoZXIgY29tbWl0Lg0KPiANCg0KSSBzaG91
bGQgaGF2ZSBhc2tlZCBpbiBteSBwcmV2aW91cyByZXBseS4NCkxlYXZlIHRoaXMgYXMtaXMgb3Ig
cmUtZm9ybXVsYXRlIGluIDIgcGF0Y2hlcyA/DQoNCk5vIHN0cm9uZyBwcmVmZXJlbmNlIGZyb20g
bXkgc2lkZS4NCg0KVGhhbmtzDQpBbGV4DQoNCj4gVGhhbmtzDQo+IEFsZXgNCj4gDQo+ID4gdGhh
bmtzLA0KPiA+IA0KPiA+IGdyZWcgay1oDQo=
