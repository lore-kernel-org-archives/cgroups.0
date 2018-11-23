From: "Ho, Kenny" <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: RE: [PATCH RFC 4/5] drm/amdgpu: Add accounting of command submission
 via DRM cgroup
Date: Fri, 23 Nov 2018 19:09:38 +0000
Message-ID: <DM5PR12MB122621462A0D79F04FF4034783D40@DM5PR12MB1226.namprd12.prod.outlook.com>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20181120185814.13362-5-Kenny.Ho@amd.com> <87r2ff79he.fsf@anholt.net>
 <56833f60-1636-d149-c9b0-c021a6ad99d1@gmail.com> <871s7b7l2b.fsf@anholt.net>
 <095e010c-e3b8-ec79-c87b-a05ce1d95e10@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
In-Reply-To: <095e010c-e3b8-ec79-c87b-a05ce1d95e10-5C7GfCeVMHo@public.gmane.org>
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
Content-Type: text/plain; charset="iso-8859-1"
To: "Koenig, Christian" <Christian.Koenig-5C7GfCeVMHo@public.gmane.org>, Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, "y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

T24gRnJpLCBOb3YgMjMsIDIwMTggYXQgMToxMyBQTSBLb2VuaWcsIENocmlzdGlhbiA8Q2hyaXN0
aWFuLktvZW5pZ0BhbWQuY29tPiB3cm90ZToNCj4gQW0gMjMuMTEuMTggdW0gMTg6MzYgc2Nocmll
YiBFcmljIEFuaG9sdDoNCj4gPiBDaHJpc3RpYW4gS8O2bmlnIDxja29lbmlnLmxlaWNodHp1bWVy
a2VuQGdtYWlsLmNvbT4gd3JpdGVzOg0KPiA+PiBBbSAyMC4xMS4xOCB1bSAyMTo1NyBzY2hyaWVi
IEVyaWMgQW5ob2x0Og0KPiA+Pj4gS2VubnkgSG8gPEtlbm55LkhvQGFtZC5jb20+IHdyaXRlczoN
Cj4gPj4+PiBBY2NvdW50IGZvciB0aGUgbnVtYmVyIG9mIGNvbW1hbmQgc3VibWl0dGVkIHRvIGFt
ZGdwdSBieSB0eXBlIG9uIGEgcGVyDQo+ID4+Pj4gY2dyb3VwIGJhc2lzLCBmb3IgdGhlIHB1cnBv
c2Ugb2YgcHJvZmlsaW5nL21vbml0b3JpbmcgYXBwbGljYXRpb25zLg0KPiA+Pj4gRm9yIHByb2Zp
bGluZyBvdGhlciBkcml2ZXJzLCBJJ3ZlIHVzZWQgcGVyZiB0cmFjZXBvaW50cywgd2hpY2ggbGV0
IHlvdQ0KPiA+Pj4gZ2V0IHVzZWZ1bCB0aW1lbGluZXMgb2YgbXVsdGlwbGUgZXZlbnRzIGluIHRo
ZSBkcml2ZXIuICBIYXZlIHlvdSBtYWRlDQo+ID4+PiB1c2Ugb2YgdGhpcyBzdGF0IGZvciBwcm9k
dWN0aXZlIHByb2ZpbGluZz8NCj4gPj4gWWVzLCBidXQgdGhpcyBpcyBub3QgcmVsYXRlZCB0byBw
cm9maWxpbmcgYXQgYWxsLg0KPiA+Pg0KPiA+PiBXaGF0IHdlIHdhbnQgdG8gZG8gaXMgdG8gbGlt
aXQgdGhlIHJlc291cmNlIHVzYWdlIG9mIHByb2Nlc3Nlcy4NCj4gPiBUaGF0IHNvdW5kcyBncmVh
dCwgYW5kIHNvbWV0aGluZyBJJ2QgYmUgaW50ZXJlc3RlZCBpbiBmb3IgdmM0LiAgSG93ZXZlciwN
Cj4gPiBhcyBmYXIgYXMgSSBzYXcgZXhwbGFpbmVkIGhlcmUsIHRoaXMgcGF0Y2ggZG9lc24ndCBs
ZXQgeW91IGxpbWl0DQo+ID4gcmVzb3VyY2UgdXNhZ2Ugb2YgYSBwcm9jZXNzIGFuZCBpcyBvbmx5
IHVzZWZ1bCBmb3INCj4gPiAicHJvZmlsaW5nL21vbml0b3JpbmciIHNvIEknbSB3b25kZXJpbmcg
aG93IGl0IGlzIHVzZWZ1bCBmb3IgdGhhdA0KPiA+IHB1cnBvc2UuDQo+DQo+IE9rLCBnb29kIHRv
IGtub3cuIEkgaGF2ZW4ndCBsb29rZWQgYXQgdGhpcyBpbiBkZWVwLCBidXQgaWYgdGhpcyBpcyBq
dXN0DQo+IGZvciBhY2NvdW50aW5nIHRoYXQgd291bGQgY2VydGFpbmx5IGJlIG1pc3NpbmcgdGhl
IGdvYWwuDQpUaGUgZW5kIGdvYWwgaXMgdG8gaGF2ZSBsaW1pdCBpbiBwbGFjZS4gIFRoZSBjdXJy
ZW50IHBhdGNoIGlzIG1vc3RseSB0byBpbGx1c3RyYXRlIHRoZSBzdHJ1Y3R1cmUgb2YgdGhlIGNv
bnRyb2xsZXIgYW5kIGdldCBzb21lIGVhcmx5IGZlZWRiYWNrLiAgSSB3aWxsIGhhdmUgbW9yZSBz
b29uLg0KDQpSZWdhcmRzLA0KS2VubnkNCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlzdHMuZnJlZWRl
c2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8v
YW1kLWdmeAo=
