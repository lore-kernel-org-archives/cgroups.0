From: "Koenig, Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH RFC 4/5] drm/amdgpu: Add accounting of command submission
 via DRM cgroup
Date: Fri, 23 Nov 2018 18:13:32 +0000
Message-ID: <095e010c-e3b8-ec79-c87b-a05ce1d95e10@amd.com>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20181120185814.13362-5-Kenny.Ho@amd.com> <87r2ff79he.fsf@anholt.net>
 <56833f60-1636-d149-c9b0-c021a6ad99d1@gmail.com> <871s7b7l2b.fsf@anholt.net>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <871s7b7l2b.fsf-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>
Content-Language: en-US
Content-ID: <C5A09E2F2F87E4479F3AC2B8EBA62877-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
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
To: Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, "Ho, Kenny" <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

QW0gMjMuMTEuMTggdW0gMTg6MzYgc2NocmllYiBFcmljIEFuaG9sdDoNCj4gQ2hyaXN0aWFuIEvD
tm5pZyA8Y2tvZW5pZy5sZWljaHR6dW1lcmtlbkBnbWFpbC5jb20+IHdyaXRlczoNCj4NCj4+IEFt
IDIwLjExLjE4IHVtIDIxOjU3IHNjaHJpZWIgRXJpYyBBbmhvbHQ6DQo+Pj4gS2VubnkgSG8gPEtl
bm55LkhvQGFtZC5jb20+IHdyaXRlczoNCj4+Pg0KPj4+PiBBY2NvdW50IGZvciB0aGUgbnVtYmVy
IG9mIGNvbW1hbmQgc3VibWl0dGVkIHRvIGFtZGdwdSBieSB0eXBlIG9uIGEgcGVyDQo+Pj4+IGNn
cm91cCBiYXNpcywgZm9yIHRoZSBwdXJwb3NlIG9mIHByb2ZpbGluZy9tb25pdG9yaW5nIGFwcGxp
Y2F0aW9ucy4NCj4+PiBGb3IgcHJvZmlsaW5nIG90aGVyIGRyaXZlcnMsIEkndmUgdXNlZCBwZXJm
IHRyYWNlcG9pbnRzLCB3aGljaCBsZXQgeW91DQo+Pj4gZ2V0IHVzZWZ1bCB0aW1lbGluZXMgb2Yg
bXVsdGlwbGUgZXZlbnRzIGluIHRoZSBkcml2ZXIuICBIYXZlIHlvdSBtYWRlDQo+Pj4gdXNlIG9m
IHRoaXMgc3RhdCBmb3IgcHJvZHVjdGl2ZSBwcm9maWxpbmc/DQo+PiBZZXMsIGJ1dCB0aGlzIGlz
IG5vdCByZWxhdGVkIHRvIHByb2ZpbGluZyBhdCBhbGwuDQo+Pg0KPj4gV2hhdCB3ZSB3YW50IHRv
IGRvIGlzIHRvIGxpbWl0IHRoZSByZXNvdXJjZSB1c2FnZSBvZiBwcm9jZXNzZXMuDQo+IFRoYXQg
c291bmRzIGdyZWF0LCBhbmQgc29tZXRoaW5nIEknZCBiZSBpbnRlcmVzdGVkIGluIGZvciB2YzQu
ICBIb3dldmVyLA0KPiBhcyBmYXIgYXMgSSBzYXcgZXhwbGFpbmVkIGhlcmUsIHRoaXMgcGF0Y2gg
ZG9lc24ndCBsZXQgeW91IGxpbWl0DQo+IHJlc291cmNlIHVzYWdlIG9mIGEgcHJvY2VzcyBhbmQg
aXMgb25seSB1c2VmdWwgZm9yDQo+ICJwcm9maWxpbmcvbW9uaXRvcmluZyIgc28gSSdtIHdvbmRl
cmluZyBob3cgaXQgaXMgdXNlZnVsIGZvciB0aGF0DQo+IHB1cnBvc2UuDQoNCk9rLCBnb29kIHRv
IGtub3cuIEkgaGF2ZW4ndCBsb29rZWQgYXQgdGhpcyBpbiBkZWVwLCBidXQgaWYgdGhpcyBpcyBq
dXN0IA0KZm9yIGFjY291bnRpbmcgdGhhdCB3b3VsZCBjZXJ0YWlubHkgYmUgbWlzc2luZyB0aGUg
Z29hbC4NCg0KQ2hyaXN0aWFuLg0KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3Rv
cC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQt
Z2Z4Cg==
