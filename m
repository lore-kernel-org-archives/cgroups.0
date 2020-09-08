From: "Julius Hemanth Pitti (jpitti)" <jpitti@cisco.com>
Subject: Re: [PATCH] mm: memcg: yield cpu when we fail to charge pages
Date: Tue, 8 Sep 2020 19:28:51 +0000
Message-ID: <38c678cac5794cb647ba73799bcaf6df5ff6dc3e.camel@cisco.com>
References: <20200908185051.62420-1-jpitti@cisco.com>
         <20200908192159.GB567128@carbon.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2748; q=dns/txt; s=iport;
  t=1599593337; x=1600802937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BTJKt78EdgO0ivA536SV09mU6sGZ7cdyg15qZByn8W0=;
  b=bJMAz+KA0vemHfcrLJV2JffpQFIVyrq2edxK3HR2c2x/GN2arTgQz2z5
   dalydJFn0Y47OOfaDy8dtyd1wtH6KRpEU1TDF3YEEjDMS/0/EnzCmwiLD
   mCadTSxWSIhTrLi1buIn4m58JcnXdvAZ07CyzqGrMz1AFlwFfrh1lAzMT
   0=;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BTJKt78EdgO0ivA536SV09mU6sGZ7cdyg15qZByn8W0=;
 b=AhLEyyJEpDXk8F8Qm7k7MysDmIgRDYoqznOqyt326+kE7hHTeyl+BG0ylCLKN2XzSU3uJCUxtOym+SRCR/1H2Toss7+RcObdkFRBt7f61fFo3abyx4HUTPjVCoATUSA+8p86bj1docfRpBxiEUM1YDi2LTzFQ604gdMM2/EWAgg=
In-Reply-To: <20200908192159.GB567128@carbon.DHCP.thefacebook.com>
Content-Language: en-US
Content-ID: <305EB9137EE72C40BBD18F012D23A2FB@namprd11.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "guro@fb.com" <guro@fb.com>
Cc: "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mhocko@kernel.org" <mhocko@kernel.org>

T24gVHVlLCAyMDIwLTA5LTA4IGF0IDEyOjIxIC0wNzAwLCBSb21hbiBHdXNoY2hpbiB3cm90ZToN
Cj4gT24gVHVlLCBTZXAgMDgsIDIwMjAgYXQgMTE6NTA6NTFBTSAtMDcwMCwgSnVsaXVzIEhlbWFu
dGggUGl0dGkgd3JvdGU6DQo+ID4gRm9yIG5vbiByb290IENHLCBpbiB0cnlfY2hhcmdlKCksIHdl
IGtlZXAgdHJ5aW5nDQo+ID4gdG8gY2hhcmdlIHVudGlsIHdlIHN1Y2NlZWQuIE9uIG5vbi1wcmVl
bXB0aXZlDQo+ID4ga2VybmVsLCB3aGVuIHdlIGFyZSBPT00sIHRoaXMgcmVzdWx0cyBpbiBob2xk
aW5nDQo+ID4gQ1BVIGZvcmV2ZXIuDQo+ID4gDQo+ID4gT24gU01QIHN5c3RlbXMsIHRoaXMgZG9l
c24ndCBjcmVhdGUgYSBiaWcgcHJvYmxlbQ0KPiA+IGJlY2F1c2Ugb29tX3JlYXBlciBnZXQgYSBj
aGFuZ2UgdG8ga2lsbCB2aWN0aW0NCj4gPiBhbmQgbWFrZSBzb21lIGZyZWUgcGFnZXMuIEhvd2V2
ZXIgb24gYSBzaW5nbGUtY29yZQ0KPiA+IENQVSAob3IgY2FzZXMgd2hlcmUgb29tX3JlYXBlciBw
aW5uZWQgdG8gc2FtZSBDUFUNCj4gPiB3aGVyZSB0cnlfY2hhcmdlIGlzIGV4ZWN1dGluZyksIG9v
bV9yZWFwZXIgc2hhbGwNCj4gPiBuZXZlciBnZXQgc2NoZWR1bGVkIGFuZCB3ZSBzdGF5IGluIHRy
eV9jaGFyZ2UgZm9yZXZlci4NCj4gPiANCj4gPiBTdGVwcyB0byByZXBvIHRoaXMgb24gbm9uLXNt
cDoNCj4gPiAxLiBtb3VudCAtdCB0bXBmcyBub25lIC9zeXMvZnMvY2dyb3VwDQo+ID4gMi4gbWtk
aXIgL3N5cy9mcy9jZ3JvdXAvbWVtb3J5DQo+ID4gMy4gbW91bnQgLXQgY2dyb3VwIG5vbmUgL3N5
cy9mcy9jZ3JvdXAvbWVtb3J5IC1vIG1lbW9yeQ0KPiA+IDQuIG1rZGlyIC9zeXMvZnMvY2dyb3Vw
L21lbW9yeS8wDQo+ID4gNS4gZWNobyA0ME0gPiAvc3lzL2ZzL2Nncm91cC9tZW1vcnkvMC9tZW1v
cnkubGltaXRfaW5fYnl0ZXMNCj4gPiA2LiBlY2hvICQkID4gL3N5cy9mcy9jZ3JvdXAvbWVtb3J5
LzAvdGFza3MNCj4gPiA3LiBzdHJlc3MgLW0gNSAtLXZtLWJ5dGVzIDEwTSAtLXZtLWhhbmcgMA0K
PiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEp1bGl1cyBIZW1hbnRoIFBpdHRpIDxqcGl0dGlAY2lz
Y28uY29tPg0KPiA+IC0tLQ0KPiA+ICBtbS9tZW1jb250cm9sLmMgfCAyICsrDQo+ID4gIDEgZmls
ZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKykNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvbW0vbWVt
Y29udHJvbC5jIGIvbW0vbWVtY29udHJvbC5jDQo+ID4gaW5kZXggMGQ2ZjNlYTg2NzM4Li40NjIw
ZDcwMjY3Y2IgMTAwNjQ0DQo+ID4gLS0tIGEvbW0vbWVtY29udHJvbC5jDQo+ID4gKysrIGIvbW0v
bWVtY29udHJvbC5jDQo+ID4gQEAgLTI2NTIsNiArMjY1Miw4IEBAIHN0YXRpYyBpbnQgdHJ5X2No
YXJnZShzdHJ1Y3QgbWVtX2Nncm91cA0KPiA+ICptZW1jZywgZ2ZwX3QgZ2ZwX21hc2ssDQo+ID4g
IAlpZiAoZmF0YWxfc2lnbmFsX3BlbmRpbmcoY3VycmVudCkpDQo+ID4gIAkJZ290byBmb3JjZTsN
Cj4gPiAgDQo+ID4gKwljb25kX3Jlc2NoZWQoKTsNCj4gPiArDQo+IA0KPiBDYW4geW91LCBwbGVh
c2UsIGFkZCBhIHNob3J0IGNvbW1lbnQgaGVyZT8NCj4gU29tZXRoaW5nIGxpa2UgImdpdmUgb29t
X3JlYXBlciBhIGNoYW5jZSBvbiBhIG5vbi1TTVAgc3lzdGVtIj8NClN1cmUuDQoNCj4gDQo+ID4g
IAkvKg0KPiA+ICAJICoga2VlcCByZXRyeWluZyBhcyBsb25nIGFzIHRoZSBtZW1jZyBvb20ga2ls
bGVyIGlzIGFibGUgdG8NCj4gPiBtYWtlDQo+ID4gIAkgKiBhIGZvcndhcmQgcHJvZ3Jlc3Mgb3Ig
YnlwYXNzIHRoZSBjaGFyZ2UgaWYgdGhlIG9vbSBraWxsZXINCj4gPiAtLSANCj4gPiAyLjE3LjEN
Cj4gPiANCj4gDQo+IFRoZSBwYXRjaCBtYWtlcyB0b3RhbCBzZW5zZSB0byBtZS4gUGxlYXNlLCBm
ZWVsIGZyZWUgdG8gYWRkDQo+IEFja2VkLWJ5OiBSb21hbiBHdXNoY2hpbiA8Z3Vyb0BmYi5jb20+
IGFmdGVyIGFkZGluZyBhIGNvbW1lbnQuDQpUaGFua3MsIEkgc2hhbGwgYWRkLg0KDQo+IA0KPiBU
aGFuayB5b3UhDQo=
