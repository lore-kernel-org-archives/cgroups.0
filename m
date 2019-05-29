From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/4] drm/amdkfd: Check against device cgroup
Date: Wed, 29 May 2019 14:15:29 -0700
Message-ID: <20190529211529.GQ374014@devbig004.ftw2.facebook.com>
References: <20190517161435.14121-1-Harish.Kasiviswanathan@amd.com>
 <20190517161435.14121-5-Harish.Kasiviswanathan@amd.com>
 <e547c0a1-e153-c3a6-79bc-67f59f364c3e@amd.com>
 <20190528190239.GM374014@devbig004.ftw2.facebook.com>
 <d39ec6a7-b30d-404b-c8d1-4e22604e0c8e@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d39ec6a7-b30d-404b-c8d1-4e22604e0c8e-5C7GfCeVMHo@public.gmane.org>
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
To: "Kuehling, Felix" <Felix.Kuehling-5C7GfCeVMHo@public.gmane.org>
Cc: "Deucher, Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kasiviswanathan,
 Harish" <Harish.Kasiviswanathan-5C7GfCeVMHo@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

T24gV2VkLCBNYXkgMjksIDIwMTkgYXQgMDg6NDU6NDRQTSArMDAwMCwgS3VlaGxpbmcsIEZlbGl4
IHdyb3RlOgo+IEp1c3QgdG8gY2xhcmlmeSwgYXJlIHlvdSBzYXlpbmcgdGhhdCB3ZSBzaG91bGQg
dXBzdHJlYW0gdGhpcyBjaGFuZ2UgCj4gdGhyb3VnaCBBbGV4IERldWNoZXIncyBhbWQtc3RhZ2lu
Zy1kcm0tbmV4dCBhbmQgRGF2ZSBBaXJsaWUncyBkcm0tbmV4dCAKPiB0cmVlcz8KClllYWgsIHN1
cmUsIHdoaWNoZXZlciB0cmVlIGlzIHRoZSBtb3N0IGNvbnZlbmllbnQuCgpUaGFua3MuCgotLSAK
dGVqdW4KX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KYW1k
LWdmeCBtYWlsaW5nIGxpc3QKYW1kLWdmeEBsaXN0cy5mcmVlZGVza3RvcC5vcmcKaHR0cHM6Ly9s
aXN0cy5mcmVlZGVza3RvcC5vcmcvbWFpbG1hbi9saXN0aW5mby9hbWQtZ2Z4
