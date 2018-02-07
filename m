From: Tejun Heo <tj@kernel.org>
Subject: Re: [IGT PATCH RFC] tools: Introduce intel_cgroup tool
Date: Wed, 7 Feb 2018 13:54:58 -0800
Message-ID: <20180207215458.GI695913@devbig577.frc2.facebook.com>
References: <20180201195315.4956-1-matthew.d.roper@intel.com>
 <20180201195615.5124-1-matthew.d.roper@intel.com>
 <151751685381.28099.5351495854502256843@mail.alporthouse.com>
 <20180201231437.GJ31510@mdroper-desk.amr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=rmrUeIOaGEaP660cEO5FS/heTDwHk+3vHlxmZRASKV4=;
 b=cKp0caPkaq9IYR52/kgqzTfBKcZn+ZcRPshHzyvLkkT1tT6g3P22B5BupHIZPpQXxI
 GDNeHCF01KK4JxXvJgflBWe+ICR+8E1bWWnFNsAkymvCOXGaN9S9vNiLTl+uyk+/9MuZ
 VLrQIT37ALbYkfBPiaGQJZEb+9hU8z+U62vqyOWLmvAt6Dz4iOku+32xpqZoFPzkWq5Z
 E6vnc6mdam1vOBBkeZYqyz8Y5iUi0YS2z3145pVdsLVTK/YUk/OwoSTiUlDjw/iJLYJe
 HdP+IjwytMMtrKx+6KuR5AKBYhzltX/023hK33c2nJHvAop54ARYNw8yONj3INHmQ8am
 V/Gg==
Content-Disposition: inline
In-Reply-To: <20180201231437.GJ31510@mdroper-desk.amr.corp.intel.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: Matt Roper <matthew.d.roper@intel.com>
Cc: cgroups@vger.kernel.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org

SGVsbG8sCgpGb3Jnb3QgdG8gcmVzcG9uZCB0byBvbmUgcG9pbnQuCgpPbiBUaHUsIEZlYiAwMSwg
MjAxOCBhdCAwMzoxNDozOFBNIC0wODAwLCBNYXR0IFJvcGVyIHdyb3RlOgo+ICAqIFRoZSBkcml2
ZXJzIHRoYXQgd2FudCB0byBtYWtlIHVzZSBvZiB0aGlzIGZ1bmN0aW9uYWxpdHkgbWF5IGJlIGJ1
aWx0Cj4gICAgYXMgbW9kdWxlcyByYXRoZXIgdGhhbiBjb21waWxlZCBkaXJlY3RseSBpbnRvIHRo
ZSBrZXJuZWwuICBUaGlzIGlzCj4gICAgaW1wb3J0YW50IGJlY2F1c2UgdGhlIGNncm91cHMgc3Vi
c3lzdGVtIHJlbW92ZWQgdGhlIGFiaWxpdHkgdG8gaGF2ZQo+ICAgIGNncm91cCBjb250cm9sbGVy
cyBpbiBtb2R1bGVzIGEgZmV3IHllYXJzIGFnby4gIFdoaWxlIGl0IG1pZ2h0IGJlCj4gICAgcG9z
c2libGUgdG8gcmVzdXJyZWN0IG1vZHVsZS1iYXNlZCBjZ3JvdXAgY29udHJvbGxlciBzdXBwb3J0
LCBteQo+ICAgIGltcHJlc3Npb24gaXMgdGhhdCB0aGUgY2dyb3VwcyBjb21tdW5pdHkgd291bGQg
cHJlZmVyIGEgc2VwYXJhdGUKPiAgICBub24tY29udHJvbGxlciBtZWNoYW5pc20gZm9yIGRvaW5n
IHdoYXQgd2Ugd2FudCB0byBkby4gIEUuZy4sIHNlZQo+ICAgIGh0dHBzOi8vd3d3LnNwaW5pY3Mu
bmV0L2xpc3RzL2Nncm91cHMvbXNnMTg2NzQuaHRtbCBmb3Igc29tZSBicmllZgo+ICAgIGRpc2N1
c3Npb24gb24gdGhpcyB0b3BpYy4KClNvLCB0aGlzIGlzbid0IGEgY29uY2Vybi4gIElmIHdlIG5l
ZWQgdG8gaGF2ZSBtb2R1bGFyIGNvbnRyb2xsZXJzLCB3ZQpjYW4gcmVzdXJyZWN0IG1vZHVsZSBz
dXBwb3J0LCBob3BlZnVsbHkgaW4gYSBzaW1wbGVyIHdheSwgb3IgY291bGQgZG8Kc29tZXRoaW5n
IHNpbWlsYXIgdG8gd2hhdCByZG1hIGNvbnRyb2xsZXIgZGlkLiAgV2Ugc2hvdWxkbid0IG1ha2UK
dXNlcmxhbmQgaW50ZXJmYWNlIGRlY2lzaW9ucyBiYXNlZCBvbiB0aGlzIHNvcnQgb2YgaW1wbGVt
ZW50YXRpb24KZGV0YWlscy4KClRoYW5rcy4KCi0tIAp0ZWp1bgpfX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fXwpJbnRlbC1nZnggbWFpbGluZyBsaXN0CkludGVs
LWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9saXN0cy5mcmVlZGVza3RvcC5vcmcv
bWFpbG1hbi9saXN0aW5mby9pbnRlbC1nZngK
