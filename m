From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 2/5] cgroup: Add mechanism to register vendor
 specific DRM devices
Date: Tue, 20 Nov 2018 12:21:41 -0800
Message-ID: <20181120202141.GA2509588@devbig004.ftw2.facebook.com>
References: <20181120185814.13362-1-Kenny.Ho@amd.com>
 <20181120185814.13362-3-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20181120185814.13362-3-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
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
To: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org

SGVsbG8sCgpPbiBUdWUsIE5vdiAyMCwgMjAxOCBhdCAwMTo1ODoxMVBNIC0wNTAwLCBLZW5ueSBI
byB3cm90ZToKPiBTaW5jZSBtYW55IHBhcnRzIG9mIHRoZSBEUk0gc3Vic3lzdGVtIGhhcyB2ZW5k
b3Itc3BlY2lmaWMKPiBpbXBsZW1lbnRhdGlvbnMsIHdlIGludHJvZHVjZSBtZWNoYW5pc21zIGZv
ciB2ZW5kb3IgdG8gcmVnaXN0ZXIgdGhlaXIKPiBzcGVjaWZpYyByZXNvdXJjZXMgYW5kIGNvbnRy
b2wgZmlsZXMgdG8gdGhlIERSTSBjZ3JvdXAgc3Vic3lzdGVtLiAgQQo+IHZlbmRvciB3aWxsIHJl
Z2lzdGVyIGl0c2VsZiB3aXRoIHRoZSBEUk0gY2dyb3VwIHN1YnN5c3RlbSBmaXJzdCBiZWZvcmUK
PiByZWdpc3RlcmluZyBpbmRpdmlkdWFsIERSTSBkZXZpY2VzIHRvIHRoZSBjZ3JvdXAgc3Vic3lz
dGVtLgo+IAo+IEluIGFkZGl0aW9uIHRvIHRoZSBjZ3JvdXBfc3Vic3lzX3N0YXRlIHRoYXQgaXMg
Y29tbW9uIHRvIGFsbCBEUk0KPiBkZXZpY2VzLCBhIGRldmljZS1zcGVjaWZpYyBzdGF0ZSBpcyBp
bnRyb2R1Y2VkIGFuZCBpdCBpcyBhbGxvY2F0ZWQKPiBhY2NvcmRpbmcgdG8gdGhlIHZlbmRvciBv
ZiB0aGUgZGV2aWNlLgoKU28sIEknbSBzdGlsbCBwcmV0dHkgbmVnYXRpdmUgYWJvdXQgYWRkaW5n
IGRybSBjb250cm9sbGVyIGF0IHRoaXMKcG9pbnQuICBUaGVyZSBpc24ndCBlbm91Z2ggb2YgY29t
bW9uIHJlc291cmNlIG1vZGVsIGRlZmluZWQgeWV0IGFuZAp1bnRpbCB0aGF0IGdldHMgc29ydGVk
IG91dCBJIHRoaW5rIGl0J3MgaW4gdGhlIGJlc3QgaW50ZXJlc3Qgb2YKZXZlcnlvbmUgaW52b2x2
ZWQgdG8ga2VlcCBpdCBpbnNpZGUgZHJtIG9yIHNwZWNpZmljIGRyaXZlciBwcm9wZXIuCgpUaGFu
a3MuCgotLSAKdGVqdW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX18KYW1kLWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcK
aHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4Cg==
