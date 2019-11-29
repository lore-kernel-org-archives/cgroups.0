From: Felix Kuehling <felix.kuehling-5C7GfCeVMHo@public.gmane.org>
Subject: Re: [PATCH RFC v4 14/16] drm, cgroup: Introduce lgpu as DRM cgroup
 resource
Date: Fri, 29 Nov 2019 15:10:08 -0500
Message-ID: <1a31dded-b386-0da4-3ff7-d6f4e767de75@amd.com>
References: <20190829060533.32315-1-Kenny.Ho@amd.com>
 <20190829060533.32315-15-Kenny.Ho@amd.com>
 <b3d2b3c1-8854-10ca-3e39-b3bef35bdfa9@amd.com>
 <20191009103153.GU16989@phenom.ffwll.local>
 <ee873e89-48fd-c4c9-1ce0-73965f4ad2ba@amd.com>
 <20191009153429.GI16989@phenom.ffwll.local>
 <c7812af4-7ec4-02bb-ff4c-21dd114cf38e@amd.com>
 <20191009160652.GO16989@phenom.ffwll.local>
 <20191011171247.GC18794@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <20191011171247.GC18794-LpCCV3molIbIZ9tKgghJQw2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
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
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Cc: "Ho, Kenny" <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>, "jsparks-WVYJKLFxKCc@public.gmane.org" <jsparks-WVYJKLFxKCc@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "lkaplan-WVYJKLFxKCc@public.gmane.org" <lkaplan-WVYJKLFxKCc@public.gmane.org>, "y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "Greathouse, Joseph" <Joseph.Greathouse-5C7GfCeVMHo@public.gmane.org>, "Deucher,
 Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Koenig,
 Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>

T24gMjAxOS0xMC0xMSAxOjEyIHAubS4sIHRqQGtlcm5lbC5vcmcgd3JvdGU6Cj4gSGVsbG8sIERh
bmllbC4KPgo+IE9uIFdlZCwgT2N0IDA5LCAyMDE5IGF0IDA2OjA2OjUyUE0gKzAyMDAsIERhbmll
bCBWZXR0ZXIgd3JvdGU6Cj4+IFRoYXQncyBub3QgdGhlIHBvaW50IEkgd2FzIG1ha2luZy4gRm9y
IGNwdSBjZ3JvdXBzIHRoZXJlJ3MgYSB2ZXJ5IHdlbGwKPj4gZGVmaW5lZCBjb25uZWN0aW9uIGJl
dHdlZW4gdGhlIGNwdSBiaXRtYXNrcy9udW1iZXJzIGluIGNncm91cHMgYW5kIHRoZSBjcHUKPj4g
Yml0bWFza3MgeW91IHVzZSBpbiB2YXJpb3VzIHN5c3RlbSBjYWxscyAodGhleSBtYXRjaCkuIEFu
ZCB0aGF0IHN0dWZmCj4+IHdvcmtzIGFjcm9zcyB2ZW5kb3JzLgo+IFBsZWFzZSBub3RlIHRoYXQg
dGhlcmUgYXJlIGEgbG90IG9mIGxpbWl0YXRpb25zIGV2ZW4gdG8gY3B1c2V0Lgo+IEFmZmluaXR5
IGlzIGVhc3kgdG8gaW1wbGVtZW50IGFuZCBzZWVtcyBhdHRyYWN0aXZlIGluIHRlcm1zIG9mCj4g
YWJzb2x1dGUgaXNvbGF0aW9uIGJ1dCBpdCdzIGluaGVyZW50bHkgY3VtYmVyc29tZSBhbmQgbGlt
aXRlZCBpbgo+IGdyYW51bGFyaXR5IGFuZCBjYW4gbGVhZCB0byBzdXJwcmlzaW5nIGZhaWx1cmUg
bW9kZXMgd2hlcmUgY29udGVudGlvbgo+IG9uIG9uZSBjcHUgY2FuJ3QgYmUgcmVzb2x2ZWQgYnkg
dGhlIGxvYWQgYmFsYW5jZXIgYW5kIGxlYWRzIHRvIHN5c3RlbQo+IHdpZGUgc2xvd2Rvd25zIC8g
c3RhbGxzIGNhdXNlZCBieSB0aGUgZGVwZW5kZW5jeSBjaGFpbiBhbmNob3JlZCBhdCB0aGUKPiBh
ZmZpbml0eSBsaW1pdGVkIHRhc2tzLgo+Cj4gTWF5YmUgdGhpcyBpcyBhIGxlc3Mgb2YgYSBwcm9i
bGVtIGZvciBncHUgd29ya2xvYWRzIGJ1dCBpbiBnZW5lcmFsIHRoZQo+IG1vcmUgY29uc3RyYWlu
dHMgYXJlIHB1dCBvbiBzY2hlZHVsaW5nLCB0aGUgbW9yZSBsaWtlbHkgaXMgdGhlIHN5c3RlbQo+
IHRvIGRldmVsb3AgdHdpc3RlZCBkZXBlbmRlbmN5IGNoYWlucyB3aGlsZSBvdGhlciBwYXJ0cyBv
ZiB0aGUgc3lzdGVtCj4gYXJlIHNpdHRpbmcgaWRsZS4KPgo+IEhvdyBkb2VzIHNjaGVkdWxpbmcg
Y3VycmVudGx5IHdvcmsgd2hlbiB0aGVyZSBhcmUgY29tcGV0aW5nIGdwdQo+IHdvcmtsb2Fkcz8g
IFRoZXJlIGdvdHRhIGJlIHNvbWUgZmFpcm5lc3MgcHJvdmlzaW9uIHdoZXRoZXIgdGhhdCdzIHVu
aXQKPiBhbGxvY2F0aW9uIGJhc2VkIG9yIHRpbWUgc2xpY2luZywgcmlnaHQ/CgpUaGUgc2NoZWR1
bGluZyBvZiBjb21wZXRpbmcgd29ya2xvYWRzIG9uIEdQVXMgaXMgaGFuZGxlZCBpbiBoYXJkd2Fy
ZSBhbmQgCmZpcm13YXJlLiBUaGUgTGludXgga2VybmVsIGFuZCBkcml2ZXIgYXJlIG5vdCByZWFs
bHkgaW52b2x2ZWQuIFdlIGhhdmUgCnNvbWUga25vYnMgd2UgY2FuIHR3ZWFrIGluIHRoZSBkcml2
ZXIgKHF1ZXVlIGFuZCBwaXBlIHByaW9yaXRpZXMsIApyZXNvdXJjZSByZXNlcnZhdGlvbnMgZm9y
IGNlcnRhaW4gdHlwZXMgb2Ygd29ya2xvYWRzKSwgYnV0IHRoZXkgYXJlIApwcmV0dHkgSFctc3Bl
Y2lmaWMgYW5kIEkgd291bGRuJ3QgbWFrZSBhbnkgY2xhaW1zIGFib3V0IGZhaXJuZXNzLgoKUmVn
YXJkcywKIMKgIEZlbGl4Cgo+ICAgIElmIHRoYXQncyB0aGUgY2FzZSwgaXQgbWlnaHQKPiBiZSBi
ZXN0IHRvIGltcGxlbWVudCBwcm9wb3J0aW9uYWwgY29udHJvbCBvbiB0b3Agb2YgdGhhdC4KPiBX
b3JrLWNvbnNlcnZpbmcgbWVjaGFuaXNtcyBhcmUgdGhlIG1vc3QgdmVyc2F0aWxlLCBlYXNpZXN0
IHRvIHVzZSBhbmQKPiBsZWFzdCBsaWtlbHkgdG8gY2F1c2UgcmVncmVzc2lvbnMuCj4KPiBUaGFu
a3MuCj4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1k
LWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9s
aXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
