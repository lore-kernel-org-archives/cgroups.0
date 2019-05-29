From: "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH v2 4/4] drm/amdkfd: Check against device cgroup
Date: Wed, 29 May 2019 20:45:44 +0000
Message-ID: <d39ec6a7-b30d-404b-c8d1-4e22604e0c8e@amd.com>
References: <20190517161435.14121-1-Harish.Kasiviswanathan@amd.com>
 <20190517161435.14121-5-Harish.Kasiviswanathan@amd.com>
 <e547c0a1-e153-c3a6-79bc-67f59f364c3e@amd.com>
 <20190528190239.GM374014@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190528190239.GM374014-LpCCV3molIbIZ9tKgghJQw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Content-ID: <8BEE5F0ACC2D1740A23D8F3495D41A37-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Deucher, Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kasiviswanathan,
 Harish" <Harish.Kasiviswanathan-5C7GfCeVMHo@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

T24gMjAxOS0wNS0yOCAzOjAyIHAubS4sIFRlanVuIEhlbyB3cm90ZToNCj4gSGVsbG8sDQo+DQo+
IE9uIEZyaSwgTWF5IDE3LCAyMDE5IGF0IDA4OjEyOjE3UE0gKzAwMDAsIEt1ZWhsaW5nLCBGZWxp
eCB3cm90ZToNCj4+IFBhdGNoZXMgMSwyLDQgd2lsbCBiZSBzdWJtaXR0ZWQgdGhyb3VnaCBhbWQt
c3RhZ2luZy1kcm0tbmV4dC4gUGF0Y2ggMw0KPj4gZ29lcyB0aHJvdWdoIHRoZSBjZ3JvdXAgdHJl
ZS4gUGF0Y2ggNCBkZXBlbmRzIG9uIHBhdGNoIDMuIFNvIHN1Ym1pdHRpbmcNCj4+IHBhdGNoIDQg
d2lsbCBuZWVkIHRvIHdhaXQgdW50aWwgd2UgcmViYXNlIGFtZC1zdGFnaW5nLWRybS1uZXh0IG9u
IGEgbmV3DQo+PiBlbm91Z2gga2VybmVsIHJlbGVhc2UgdGhhdCBpbmNsdWRlcyBwYXRjaCAzLg0K
Pj4NCj4+IFBhdGNoIDEgYW5kIDIgY291bGQgYmUgc3VibWl0dGVkIG5vdyBvciB3YWl0IGZvciBw
YXRjaCAzIGFzIHdlbGwgc28gd2UNCj4+IHN1Ym1pdCBhbGwgb3VyIGNncm91cCBzdHVmZiBpbiBh
bWRncHUgYW5kIEtGRCB0b2dldGhlci4gSXQgcHJvYmFibHkNCj4+IG1ha2VzIG1vc3Qgc2Vuc2Ug
dG8gd2FpdCBzaW5jZSB1bnVzZWQgY29kZSB0ZW5kcyB0byByb3QuDQo+Pg0KPj4gUGF0Y2hlcyAx
LDIsNCBhcmUgYWxyZWFkeSByZXZpZXdlZCBieSBtZS4gRmVlbCBmcmVlIHRvIGFkZCBteSBBY2tl
ZC1ieQ0KPj4gdG8gcGF0Y2ggMy4NCj4gUGxlYXNlIGZlZWwgZnJlZSB0byBhZGQgbXkgYWNrZWQt
YnkgYW5kIHRha2UgcGF0Y2ggMyB3aXRoIHRoZSByZXN0IG9mDQo+IHRoZSBwYXRjaHNldC4NCg0K
VGhhbmsgeW91IFRlanVuIQ0KDQpKdXN0IHRvIGNsYXJpZnksIGFyZSB5b3Ugc2F5aW5nIHRoYXQg
d2Ugc2hvdWxkIHVwc3RyZWFtIHRoaXMgY2hhbmdlIA0KdGhyb3VnaCBBbGV4IERldWNoZXIncyBh
bWQtc3RhZ2luZy1kcm0tbmV4dCBhbmQgRGF2ZSBBaXJsaWUncyBkcm0tbmV4dCANCnRyZWVzPw0K
DQpJIGFkZGVkIERhdmUgYW5kIEFsZXggdG8gdGhpcyBlbWFpbCB0byBtYWtlIHN1cmUgd2UncmUg
YWxsIG9uIHRoZSBzYW1lIHBhZ2UuDQoNClJlZ2FyZHMsDQogwqAgRmVsaXgNCg0KPg0KPiBUaGFu
a3MuDQo+DQpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwph
bWQtZ2Z4IG1haWxpbmcgbGlzdAphbWQtZ2Z4QGxpc3RzLmZyZWVkZXNrdG9wLm9yZwpodHRwczov
L2xpc3RzLmZyZWVkZXNrdG9wLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2FtZC1nZng=
