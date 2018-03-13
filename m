From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 3/6] cgroup: Introduce cgroup_permission()
Date: Tue, 13 Mar 2018 13:43:35 -0700
Message-ID: <20180313204335.GM2943022@devbig577.frc2.facebook.com>
References: <20180306234700.6562-1-matthew.d.roper@intel.com>
 <20180306234700.6562-4-matthew.d.roper@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=AkT3rj++IjdSXPAb0dCDo2Kg22TFrhyuQTRT0niLbN4=;
 b=i44iPtP0AHJYTjGNn6U6vN8gj5OOz1niJgZr2HeXgphFXVqmVc+bX91mtN524B3eef
 4ECDN8kIXe27QHW2u3+vdruNa1kEjJ2S94Vlm06PtlTLliqzkBHJqOtQPwqQeXSzBa0o
 gKYFVw3r+wL8sV9o+Qxnw+0iRtPGj14QyhOE/SyIUT1nojfB2DmvOo58QoTWrwwGDz0g
 ftzUlLj+j0bsUxN3ZbHf2eIjjgq5qhUCYQzBumiBigSxYhVPR+GtuMedKNFQJqDnxtVE
 o+ddWrt/SIkqisS7brDClm1n1Bi//pjvAlbayBb00NJjwy6gn90hJG1gWzm6R3hacQZ2
 NHIg==
Content-Disposition: inline
In-Reply-To: <20180306234700.6562-4-matthew.d.roper@intel.com>
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

T24gVHVlLCBNYXIgMDYsIDIwMTggYXQgMDM6NDY6NTdQTSAtMDgwMCwgTWF0dCBSb3BlciB3cm90
ZToKPiBOb24tY29udHJvbGxlciBrZXJuZWwgc3Vic3lzdGVtcyBtYXkgYmFzZSBhY2Nlc3MgcmVz
dHJpY3Rpb25zIGZvcgo+IGNncm91cC1yZWxhdGVkIHN5c2NhbGxzL2lvY3RscyBvbiBhIHByb2Nl
c3MnIGFjY2VzcyB0byB0aGUgY2dyb3VwLgo+IExldCdzIG1ha2UgaXQgZWFzeSBmb3Igb3RoZXIg
cGFydHMgb2YgdGhlIGtlcm5lbCB0byBjaGVjayB0aGVzZSBjZ3JvdXAKPiBwZXJtaXNzaW9ucy4K
CkknbSBub3Qgc3VyZSBhYm91dCBwdWxsaW5nIGluIGNncm91cCBwZXJtcyB0aGlzIHdheSBiZWNh
dXNlIGNncm91cAphY2Nlc3MgcGVybXMgaGF2ZSBtb3JlIHRvIGl0IHRoYW4gdGhlIGZpbGUgYW5k
IGRpcmVjdG9yeSBwZXJtaXNzaW9ucy4KQ2FuJ3QgdGhpcyBiZSByZXN0cmljdGVkIHRvIHJvb3Qg
b3Igc29tZSBDQVA/CgpUaGFua3MuCgotLSAKdGVqdW4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhA
bGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxt
YW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==
