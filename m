From: "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
Subject: Re: [PATCH 03/16] lib,treewide: add new match_string() helper/macro
Date: Mon, 13 May 2019 07:00:18 +0000
Message-ID: <146ba7b61998d1e26cf2312fdaa01525d7c7d8de.camel@analog.com>
References: <20190508112842.11654-1-alexandru.ardelean@analog.com>
         <20190508112842.11654-5-alexandru.ardelean@analog.com>
         <20190508131128.GL9224@smile.fi.intel.com>
         <20190508131856.GB10138@kroah.com>
         <b2440bc9485456a7a90a488c528997587b22088b.camel@analog.com>
         <4df165bc4247e60aa4952fd55cb0c77e60712767.camel@analog.com>
         <20190510143407.GA9224@smile.fi.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector1-analog-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYMxlTU42U8IEHuaefeXBUDbrbbRBESKyCojAVqw4Hs=;
 b=gDL7Mqp4cjHd9tnfv2Oc1qnpYT4Fac8j07kqzHoMV4t4fblqqvc/VaI9b3eW64VcLXIB/IIy6eJ2zPrMIPgV3ZayvIayU+ziMWE4G1SNhTClihPWWYWJfxAonZzDgMbLjip70cWFf6cVkIyteBkWBVFGb865vhK+yAGxY5lk4K0=
In-Reply-To: <20190510143407.GA9224@smile.fi.intel.com>
Content-Language: en-US
Content-ID: <FDDE4955D460DC40AB641BB9139D6ABF@analog.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>, "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, devel@driverdev.osu

T24gRnJpLCAyMDE5LTA1LTEwIGF0IDE3OjM0ICswMzAwLCBhbmRyaXkuc2hldmNoZW5rb0BsaW51
eC5pbnRlbC5jb20gd3JvdGU6DQo+IFtFeHRlcm5hbF0NCj4gDQo+IA0KPiBPbiBGcmksIE1heSAx
MCwgMjAxOSBhdCAwOToxNToyN0FNICswMDAwLCBBcmRlbGVhbiwgQWxleGFuZHJ1IHdyb3RlOg0K
PiA+IE9uIFdlZCwgMjAxOS0wNS0wOCBhdCAxNjoyMiArMDMwMCwgQWxleGFuZHJ1IEFyZGVsZWFu
IHdyb3RlOg0KPiA+ID4gT24gV2VkLCAyMDE5LTA1LTA4IGF0IDE1OjE4ICswMjAwLCBHcmVnIEtI
IHdyb3RlOg0KPiA+ID4gPiBPbiBXZWQsIE1heSAwOCwgMjAxOSBhdCAwNDoxMToyOFBNICswMzAw
LCBBbmR5IFNoZXZjaGVua28gd3JvdGU6DQo+ID4gPiA+ID4gT24gV2VkLCBNYXkgMDgsIDIwMTkg
YXQgMDI6Mjg6MjlQTSArMDMwMCwgQWxleGFuZHJ1IEFyZGVsZWFuDQo+ID4gPiA+ID4gd3JvdGU6
DQo+ID4gPiA+ID4gQ2FuIHlvdSBzcGxpdCBpbmNsdWRlL2xpbnV4LyBjaGFuZ2UgZnJvbSB0aGUg
cmVzdD8NCj4gPiA+ID4gDQo+ID4gPiA+IFRoYXQgd291bGQgYnJlYWsgdGhlIGJ1aWxkLCB3aHkg
ZG8geW91IHdhbnQgaXQgc3BsaXQgb3V0PyAgVGhpcw0KPiA+ID4gPiBtYWtlcw0KPiA+ID4gPiBz
ZW5zZSBhbGwgYXMgYSBzaW5nbGUgcGF0Y2ggdG8gbWUuDQo+ID4gPiA+IA0KPiA+ID4gDQo+ID4g
PiBOb3QgcmVhbGx5Lg0KPiA+ID4gSXQgd291bGQgYmUganVzdCBiZSB0aGUgbmV3IG1hdGNoX3N0
cmluZygpIGhlbHBlci9tYWNybyBpbiBhIG5ldw0KPiA+ID4gY29tbWl0Lg0KPiA+ID4gQW5kIHRo
ZSBjb252ZXJzaW9ucyBvZiB0aGUgc2ltcGxlIHVzZXJzIG9mIG1hdGNoX3N0cmluZygpICh0aGUg
b25lcw0KPiA+ID4gdXNpbmcNCj4gPiA+IEFSUkFZX1NJWkUoKSkgaW4gYW5vdGhlciBjb21taXQu
DQo+ID4gPiANCj4gPiANCj4gPiBJIHNob3VsZCBoYXZlIGFza2VkIGluIG15IHByZXZpb3VzIHJl
cGx5Lg0KPiA+IExlYXZlIHRoaXMgYXMtaXMgb3IgcmUtZm9ybXVsYXRlIGluIDIgcGF0Y2hlcyA/
DQo+IA0KPiBEZXBlbmRzIG9uIG9uIHdoYXQgeW91IHdvdWxkIGxpa2UgdG8gc3BlbmQgeW91ciB0
aW1lOiBjb2xsZWN0aW5nIEFja3MgZm9yDQo+IGFsbA0KPiBwaWVjZXMgaW4gdHJlZXdpZGUgcGF0
Y2ggb3Igc2VuZCBuZXcgQVBJIGZpcnN0IGZvbGxvd2VkIHVwIGJ5IHBlciBkcml2ZXINCj4gLw0K
PiBtb2R1bGUgdXBkYXRlIGluIG5leHQgY3ljbGUuDQoNCkkgYWN0dWFsbHkgd291bGQgaGF2ZSBw
cmVmZXJyZWQgbmV3IEFQSSBmaXJzdCwgd2l0aCB0aGUgY3VycmVudA0KYG1hdGNoX3N0cmluZygp
YCAtPiBgX19tYXRjaF9zdHJpbmcoKWAgcmVuYW1lIGZyb20gdGhlIHN0YXJ0LCBidXQgSSB3YXNu
J3QNCnN1cmUuIEkgYW0gc3RpbGwgbmF2aWdhdGluZyB0aHJvdWdoIGhvdyBmZWVkYmFja3MgYXJl
IHdvcmtpbmcgaW4gdGhpcw0KcmVhbG0uDQoNCkknbGwgc2VuZCBhIFYyIHdpdGggdGhlIEFQSSBj
aGFuZ2UtZmlyc3Qvb25seTsgc2hvdWxkIGJlIGEgc21hbGxlciBsaXN0Lg0KVGhlbiBzZWUgYWJv
dXQgZm9sbG93LXVwcy9jaGFuZ2VzIHBlciBzdWJzeXN0ZW1zLg0KDQo+IA0KPiBJIGFsc28gaGF2
ZSBubyBzdHJvbmcgcHJlZmVyZW5jZS4NCj4gQW5kIEkgdGhpbmsgaXQncyBnb29kIHRvIGFkZCBI
ZWlra2kgS3JvZ2VydXMgdG8gQ2MgbGlzdCBmb3IgYm90aCBwYXRjaA0KPiBzZXJpZXMsDQo+IHNp
bmNlIGhlIGlzIHRoZSBhdXRob3Igb2Ygc3lzZnMgdmFyaWFudCBhbmQgbWF5IGhhdmUgc29tZXRo
aW5nIHRvIGNvbW1lbnQNCj4gb24NCj4gdGhlIHJlc3QuDQoNClRoYW5rcyBmb3IgdGhlIHJlZmVy
ZW5jZS4NCg0KPiANCj4gLS0NCj4gV2l0aCBCZXN0IFJlZ2FyZHMsDQo+IEFuZHkgU2hldmNoZW5r
bw0KPiANCj4gDQo=
