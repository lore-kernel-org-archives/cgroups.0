From: Alexei Starovoitov <ast@fb.com>
Subject: Re: [PATCH v3 1/6] cgroup: Allow registration and
 lookup of cgroup private data
Date: Tue, 13 Mar 2018 15:42:20 -0700
Message-ID: <d0314e4c-b1cb-8270-b39f-14a66eeedfd3@fb.com>
References: <20180306234700.6562-1-matthew.d.roper@intel.com>
 <20180306234700.6562-2-matthew.d.roper@intel.com>
 <20180313205035.GN2943022@devbig577.frc2.facebook.com>
 <4bc02913-7250-ed88-fac0-6b19957ca07b@fb.com> <20180313213658.GA12498@castle>
 <36e459e1-dd65-8153-7ac4-1629550cce92@fb.com>
 <20180313221314.GR2943022@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com;
 h=subject : to : references
 : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=facebook;
 bh=coaNQiimhpEEVaXq8kdD8iL/mFKpgeei5leSPOP9jeY=;
 b=Ye7AS0MBwT8/8TGwoECO9OnelbyiSyYwZq+EtRgVxp24voVd0EEw7AmJpwTM6o3ljdUh
 rPQGQDaUK0zU9xOpsWHU8nXEOi9Mfj2J16PtirydL/DRb/XDfdSIzv6UJsqRyc5GJ50j
 5b0gJmx63YwEE1zhU6UNbw55q2lVlMBhOVA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version; 
 bh=coaNQiimhpEEVaXq8kdD8iL/mFKpgeei5leSPOP9jeY=;
 b=SoYesQ9lUc286by55MltgFFGSM51LhjaqnNVqWEvnGYukSOS48Bj1MAsaUfoJQh40TB+oifXz4zzko/PImD4MrGP0lBjhaoD909coyfZst7NslTfISXaHhMHCsFOGPRFebCNUT3VlNNVlZPX735vQc43V/E1jnFUwfxuKNgmCRw=
In-Reply-To: <20180313221314.GR2943022@devbig577.frc2.facebook.com>
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
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>, intel-gfx@lists.freedesktop.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>, cgroups@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

T24gMy8xMy8xOCAzOjEzIFBNLCBUZWp1biBIZW8gd3JvdGU6Cj4gSGVsbG8sCj4KPiBPbiBUdWUs
IE1hciAxMywgMjAxOCBhdCAwMjo0Nzo0NVBNIC0wNzAwLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3Jv
dGU6Cj4+IGl0IGhhcyB0byBiZSB6ZXJvIGxvb2t1cHMuIElmIGlkciBsb29rdXAgaXMgaW52b2x2
ZWQsIGl0J3MgY2xlYW5lcgo+PiB0byBhZGQgaWRyIGFzIG5ldyBicGYgbWFwIHR5cGUgYW5kIHVz
ZSBjZ3JvdXAgaW5vIGFzIGFuIGlkLgo+Cj4gT2gsIGlkciAob3IgcmF0aGVyIGlkYSkgaXMganVz
dCB0byBhbGxvY2F0ZSB0aGUga2V5LCBvbmNlIHRoZSBrZXkgaXMKPiB0aGVyZSBpdCBwcmV0dHkg
bXVjaCBzaG91bGQgYm9pbCBkb3duIHRvIHN0aCBsaWtlCj4KPiAJcmN1X3JlYWRfbG9jaygpOwo+
IAl0YWJsZSA9IHJjdV9kZXJlZihjZ3JwLT50YWJsZSk7Cj4gCWlmIChrZXkgPCB0YWJsZS0+bGVu
KQo+IAkJcmV0ID0gdGFibGVba2V5XTsKPiAJZWxzZQo+IAkJcmV0ID0gTlVMTDsKPiAJcmN1X3Jl
YWRfdW5sb2NrKCk7Cj4KPiBEZXBlbmRpbmcgb24gdGhlIHJlcXVpcmVtZW50cywgd2UgY2FuIGdl
dCByaWQgb2YgdGhlIHRhYmxlLT5sZW4gY2hlY2sKPiBieSBtYWtpbmcga2V5IGFsbG9jIHBhdGgg
bW9yZSBleHBlbnNpdmUgKGllLiBnaXZlIG91dCBrZXkgb25seSBhZnRlcgo+IHRhYmxlIGV4dGVu
c2lvbiBpcyBmdWxseSBkb25lIGFuZCBwcm9wYWdhdGVkKS4KCmp1c3QgbGlrZSB0d28gYnBmIHBy
b2dzIGNhbiBiZSBhdHRhY2hlZCB0byB0aGUgc2FtZSBjZ3JvdXAKdGhlIHNhbWUgYnBmIHByb2cg
Y2FuIGJlIGF0dGFjaGVkIHRvIG11bHRpcGxlIGNncm91cHMuCklmIHdlIHVzZSBpZGEgdG8gYWxs
b2NhdGUgYW4gaWQgYW5kIHN0b3JlIGl0IGJwZi0+YXV4LT5jZ3JvdXBfdGFibGVfa2V5CnRvIGxh
dGVyIGRvOiBjZ3JwLT50YWJsZVticGYtPmF1eC0+Y2dyb3VwX3RhYmxlX2tleV0KdGhpcyBpZD09
a2V5IHdvdWxkIG5lZWQgdG8gdmFsaWQgYWNyb3NzIG11bHRpcGxlIGNncm91cHMgd2hpY2gKY29t
cGxpY2F0ZXMgdGhpbmdzIGEgbG90LgoKSXQgZmVlbHMgdGhhdCB3ZSBuZWVkIHNvbWV0aGluZyBz
aW1pbGFyIHRvIGNvbXB1dGVfZWZmZWN0aXZlX3Byb2dzKCkKYnV0IGZvciB0aGlzIHNjcmF0Y2gg
YnVmZmVycy4KVGhlbiBhdCB0aGUgdGltZSBvZiBCUEZfUFJPR19SVU5fQVJSQVkgc3VwcGx5IGNv
cnJlc3BvbmRpbmcKc2NyYXRjaCBidWZmZXIgZm9yIGV2ZXJ5IHByb2dyYW0uCk5leHQgdG8gY2dy
cC0+YnBmLmVmZmVjdGl2ZVt0eXBlXSBoYXZlIHNpbWlsYXIgYXJyYXkgb2YgcG9pbnRlcnMKdG8g
c2NyYXRjaCBidWZmZXJzLgoKV2UgcHJvYmFibHkgbmVlZCB0byB0aGluayB0aHJvdWdoIGhvdyB0
aGUgc2FtZSBtZWNoYW5pc20gY2FuIGJlCnVzZWQgZm9yIHBlci1zb2NrZXQgc2NyYXRjaCBidWZm
ZXJzLgoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50
ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBz
Oi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==
