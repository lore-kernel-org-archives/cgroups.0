From: "Kasiviswanathan, Harish" <Harish.Kasiviswanathan-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH 3/4] device_cgroup: Export __devcgroup_check_permission
Date: Mon, 13 May 2019 21:47:26 +0000
Message-ID: <2ceffd10-c3d0-86bb-b010-ed1eae655f85@amd.com>
References: <20190501145904.27505-1-Harish.Kasiviswanathan@amd.com>
 <20190501145904.27505-4-Harish.Kasiviswanathan@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20190501145904.27505-4-Harish.Kasiviswanathan-5C7GfCeVMHo@public.gmane.org>
Content-Language: en-US
Content-ID: <242F64A8B4C32E4BB3A78FA5C525BC18-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"
To: "aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "guro-b10kYP2dOMg@public.gmane.org" <guro-b10kYP2dOMg@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

SGVsbG8gRXZlcnlvbmUsDQoNCkNvdWxkIHlvdSBwbGVhc2UgcmV2aWV3IHRoaXMgcGF0Y2g/DQoN
CkJlc3QgUmVnYXJkcywNCg0KSGFyaXNoDQoNCg0KDQpPbiAyMDE5LTA1LTAxIDEwOjU5IGEubS4s
IEthc2l2aXN3YW5hdGhhbiwgSGFyaXNoIHdyb3RlOg0KPiBGb3IgQU1EIGNvbXB1dGUgKGFtZGtm
ZCkgZHJpdmVyLg0KPg0KPiBBbGwgQU1EIGNvbXB1dGUgZGV2aWNlcyBhcmUgZXhwb3J0ZWQgdmlh
IHNpbmdsZSBkZXZpY2Ugbm9kZSAvZGV2L2tmZC4gQXMNCj4gYSByZXN1bHQgZGV2aWNlcyBjYW5u
b3QgYmUgY29udHJvbGxlZCBpbmRpdmlkdWFsbHkgdXNpbmcgZGV2aWNlIGNncm91cC4NCj4NCj4g
QU1EIGNvbXB1dGUgZGV2aWNlcyB3aWxsIHJlbHkgb24gaXRzIGdyYXBoaWNzIGNvdW50ZXJwYXJ0
IHRoYXQgZXhwb3Nlcw0KPiAvZGV2L2RyaS9yZW5kZXJOIG5vZGUgZm9yIGVhY2ggZGV2aWNlLiBG
b3IgZWFjaCB0YXNrIChiYXNlZCBvbiBpdHMNCj4gY2dyb3VwKSwgS0ZEIGRyaXZlciB3aWxsIGNo
ZWNrIGlmIC9kZXYvZHJpL3JlbmRlck4gbm9kZSBpcyBhY2Nlc3NpYmxlDQo+IGJlZm9yZSBleHBv
c2luZyBpdC4NCj4NCj4gU2lnbmVkLW9mZi1ieTogSGFyaXNoIEthc2l2aXN3YW5hdGhhbiA8SGFy
aXNoLkthc2l2aXN3YW5hdGhhbkBhbWQuY29tPg0KPiBSZXZpZXdlZC1ieTogRmVsaXggS3VlaGxp
bmcgPEZlbGl4Lkt1ZWhsaW5nQGFtZC5jb20+DQo+IC0tLQ0KPiAgc2VjdXJpdHkvZGV2aWNlX2Nn
cm91cC5jIHwgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4NCj4gZGlm
ZiAtLWdpdCBhL3NlY3VyaXR5L2RldmljZV9jZ3JvdXAuYyBiL3NlY3VyaXR5L2RldmljZV9jZ3Jv
dXAuYw0KPiBpbmRleCBjZDk3OTI5ZmFjNjYuLmUzYTlhZDVkYjVhMCAxMDA2NDQNCj4gLS0tIGEv
c2VjdXJpdHkvZGV2aWNlX2Nncm91cC5jDQo+ICsrKyBiL3NlY3VyaXR5L2RldmljZV9jZ3JvdXAu
Yw0KPiBAQCAtODI0LDMgKzgyNCw0IEBAIGludCBfX2RldmNncm91cF9jaGVja19wZXJtaXNzaW9u
KHNob3J0IHR5cGUsIHUzMiBtYWpvciwgdTMyIG1pbm9yLA0KPiAgDQo+ICAJcmV0dXJuIDA7DQo+
ICB9DQo+ICtFWFBPUlRfU1lNQk9MKF9fZGV2Y2dyb3VwX2NoZWNrX3Blcm1pc3Npb24pOw0KX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1kLWdmeCBtYWls
aW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVl
ZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
