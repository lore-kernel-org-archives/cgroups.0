From: "Kasiviswanathan, Harish" <Harish.Kasiviswanathan-5C7GfCeVMHo@public.gmane.org>
Subject: AMDKFD (AMD GPU compute) support for device cgroup.
Date: Mon, 16 Sep 2019 18:05:51 +0000
Message-ID: <20190916180523.27341-1-Harish.Kasiviswanathan@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
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
Content-Type: text/plain; charset="us-ascii"
To: "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Deucher, Alexander" <Alexander.Deucher-5C7GfCeVMHo@public.gmane.org>, "airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org" <amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>

SGkgVGVqdW4sCgpTb3JyeS4gUmVzZW5kaW5nIHRoZXNlIHBhdGNoZXMgYXMgSSBnb3QgZGlzdHJh
Y3RlZCB3aXRoIG90aGVyIHN0dWZmIGFuZApjb3VsZG4ndCBmb2xsb3cgdGhyb3VnaC4gQXMgcGVy
IG91ciBwcmV2aW91cyBkaXNjdXNzaW9uIHRoZSBwbGFuIHdhcyB0bwp1cHN0cmVhbSB0aGVzZSBj
aGFuZ2VzIChtYWlubHkgcGF0Y2ggMyAiRXhwb3J0IGRldmNncm91cF9jaGVja19wZXJtaXNzaW9u
IikKdGhyb3VnaCBBbGV4IERldWNoZXIncyBhbWQtc3RhZ2luZy1kcm0tbmV4dCBhbmQgRGF2ZSBB
aXJsaWUncyBkcm0tbmV4dCB0cmVlcy4gSQphbSBwbGFubmluZyB0byB0YWtlIHRoaXMgcm91dGUu
IEkgaGF2ZSByZWJhc2VkIG15IHBhdGNoZXMgdG8KYW1kLXN0YWdpbmctZHJtLW5leHQuCgpZb3Ug
YW5kIFJvbWFuIGFja2VkIHBhdGNoIDMsIGl0IHdpbGwgYmUgZ3JlYXQgaWYgSSBjYW4gUmV2aWV3
ZWQtYnksIHNvIHRoYXQgdGhlCnVwc3RyZWFtIHBhdGggY2FuIGJlIHNtb290aGVyLgoKQmVzdCBS
ZWdhcmRzLApIYXJpc2gKCioqKioqIE9yaWdpbmFsIG5vdGUgYWJvdXQgdGhpcyBwYXRjaCBzZXJp
ZXMgZm9yIHJlZi4gKioqKgoKYW1ka2ZkIChwYXJ0IG9mIGFtZGdwdSkgZHJpdmVyIHN1cHBvcnRz
IHRoZSBBTUQgR1BVIGNvbXB1dGUgc3RhY2suIGFtZGtmZApleHBvc2VzIG9ubHkgYSBzaW5nbGUg
ZGV2aWNlIC9kZXYva2ZkIGV2ZW4gaWYgbXVsdGlwbGUgQU1EIEdQVSAoY29tcHV0ZSkKZGV2aWNl
cyBleGlzdCBpbiBhIHN5c3RlbS4gSG93ZXZlciwgYW1kZ3B1IGRydmllciBleHBvc2VzIGEgc2Vw
YXJhdGUgcmVuZGVyCmRldmljZSBmaWxlIC9kZXYvZHJpL3JlbmRlckROIGZvciBlYWNoIGRldmlj
ZS4gVG8gcGFydGljaXBhdGUgaW4gZGV2aWNlIGNncm91cAphbWRrZmQgZHJpdmVyIHdpbGwgcmVs
eSBvbiB0aGVzZSByZW5kbmVyIGRldmljZSBmaWxlcwoKCl9fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fCmFtZC1nZnggbWFpbGluZyBsaXN0CmFtZC1nZnhAbGlz
dHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4v
bGlzdGluZm8vYW1kLWdmeA==
