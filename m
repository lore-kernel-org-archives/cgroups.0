From: David Laight <David.Laight@ACULAB.COM>
Subject: RE: [PATCH 02/11] x86: tboot: avoid Wstringop-overread-warning
Date: Wed, 24 Mar 2021 09:11:55 +0000
Message-ID: <0aa198a1dd904231bcc29454bf19a812@AcuMS.aculab.com>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-3-arnd@kernel.org>
 <20210322202958.GA1955909@gmail.com>
 <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <b944a853-0e4b-b767-0175-cc2c1edba759@gmail.com>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Martin Sebor' <msebor@gmail.com>, Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Martin Sebor <msebor@gcc.gnu.org>, Ning Sun <ning.sun@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jani Nikula <jani.nikula@linux.intel.com>, Kalle Valo <kvalo@codeaurora.org>, Simon Kelley <simon@thekelleys.org.uk>, James Smart <james.smart@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge@hallyn.com>, Imre Deak <imre.deak@intel.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "tboot-devel@lists.sourceforge.net" <tboot-devel@lists.sourc>

RnJvbTogTWFydGluIFNlYm9yDQo+IFNlbnQ6IDIyIE1hcmNoIDIwMjEgMjI6MDgNCi4uLg0KPiBJ
biBHQ0MgMTEsIGFsbCBhY2Nlc3Mgd2FybmluZ3MgZXhwZWN0IG9iamVjdHMgdG8gYmUgZWl0aGVy
IGRlY2xhcmVkDQo+IG9yIGFsbG9jYXRlZC4gIFBvaW50ZXJzIHdpdGggY29uc3RhbnQgdmFsdWVz
IGFyZSB0YWtlbiB0byBwb2ludCB0bw0KPiBub3RoaW5nIHZhbGlkIChhcyBBcm5kIG1lbnRpb25l
ZCBhYm92ZSwgdGhpcyBpcyB0byBkZXRlY3QgaW52YWxpZA0KPiBhY2Nlc3NlcyB0byBtZW1iZXJz
IG9mIHN0cnVjdHMgYXQgYWRkcmVzcyB6ZXJvKS4NCj4gDQo+IE9uZSBwb3NzaWJsZSBzb2x1dGlv
biB0byB0aGUga25vd24gYWRkcmVzcyBwcm9ibGVtIGlzIHRvIGV4dGVuZCBHQ0MNCj4gYXR0cmli
dXRlcyBhZGRyZXNzIGFuZCBpbyB0aGF0IHBpbiBhbiBvYmplY3QgdG8gYSBoYXJkd2lyZWQgYWRk
cmVzcw0KPiB0byBhbGwgdGFyZ2V0cyAoYXQgdGhlIG1vbWVudCB0aGV5J3JlIHN1cHBvcnRlZCBv
biBqdXN0IG9uZSBvciB0d28NCj4gdGFyZ2V0cykuICBJJ20gbm90IHN1cmUgdGhpcyBjYW4gc3Rp
bGwgaGFwcGVuIGJlZm9yZSBHQ0MgMTEgcmVsZWFzZXMNCj4gc29tZXRpbWUgaW4gQXByaWwgb3Ig
TWF5Lg0KDQpBIGRpZmZlcmVudCBzb2x1dGlvbiBpcyB0byBkZWZpbmUgYSBub3JtYWwgQyBleHRl
cm5hbCBkYXRhIGl0ZW0NCmFuZCB0aGVuIGFzc2lnbiBhIGZpeGVkIGFkZHJlc3Mgd2l0aCBhbiBh
c20gc3RhdGVtZW50IG9yIGluDQp0aGUgbGlua2VyIHNjcmlwdC4NCg0KCURhdmlkDQoNCi0NClJl
Z2lzdGVyZWQgQWRkcmVzcyBMYWtlc2lkZSwgQnJhbWxleSBSb2FkLCBNb3VudCBGYXJtLCBNaWx0
b24gS2V5bmVzLCBNSzEgMVBULCBVSw0KUmVnaXN0cmF0aW9uIE5vOiAxMzk3Mzg2IChXYWxlcykN
Cg==

