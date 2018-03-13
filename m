From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 1/6] cgroup: Allow registration and
 lookup of cgroup private data
Date: Tue, 13 Mar 2018 15:13:14 -0700
Message-ID: <20180313221314.GR2943022@devbig577.frc2.facebook.com>
References: <20180306234700.6562-1-matthew.d.roper@intel.com>
 <20180306234700.6562-2-matthew.d.roper@intel.com>
 <20180313205035.GN2943022@devbig577.frc2.facebook.com>
 <4bc02913-7250-ed88-fac0-6b19957ca07b@fb.com>
 <20180313213658.GA12498@castle>
 <36e459e1-dd65-8153-7ac4-1629550cce92@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=sender:date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to:user-agent;
 bh=Md3/LMvzzAcciAGYkZ7OrHvEAT5AdNXbqE1SMsYrAgo=;
 b=aG4g6IHJXzn5BCjrVBYCkDYw0J1CRO8VwLfh1qpBVVZjYXbIRAp/05fDoNazDkCgax
 HMdBXtMWJEw9bqg751RYkeqgm1LLfSoIBOLT/QaBmQI9rwUSkvmYiRCO9HDaSBTJWcFZ
 1bldtL5PzwdioixKdAs1P/1+2FFc2ZrFN2b/UUKVOkQxsUvNs03K3v+IZuyxPcUy+qhr
 jNZbtAxdCOa3iDH8FHIajTaOklP6M4USXsnyxIupqakWcNyTIvP46mzwvcjuJUj6zB7y
 ENj/VjXmu4AWOnZoICyHBSw5B6K+2F/9E2rgj6k3gUHOq8Z46aCKhiOnRvn5wM6l1rWX
 Q1fw==
Content-Disposition: inline
In-Reply-To: <36e459e1-dd65-8153-7ac4-1629550cce92@fb.com>
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
To: Alexei Starovoitov <ast@fb.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, intel-gfx@lists.freedesktop.org, Alexei Starovoitov <alexei.starovoitov@gmail.com>, cgroups@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

SGVsbG8sCgpPbiBUdWUsIE1hciAxMywgMjAxOCBhdCAwMjo0Nzo0NVBNIC0wNzAwLCBBbGV4ZWkg
U3Rhcm92b2l0b3Ygd3JvdGU6Cj4gaXQgaGFzIHRvIGJlIHplcm8gbG9va3Vwcy4gSWYgaWRyIGxv
b2t1cCBpcyBpbnZvbHZlZCwgaXQncyBjbGVhbmVyCj4gdG8gYWRkIGlkciBhcyBuZXcgYnBmIG1h
cCB0eXBlIGFuZCB1c2UgY2dyb3VwIGlubyBhcyBhbiBpZC4KCk9oLCBpZHIgKG9yIHJhdGhlciBp
ZGEpIGlzIGp1c3QgdG8gYWxsb2NhdGUgdGhlIGtleSwgb25jZSB0aGUga2V5IGlzCnRoZXJlIGl0
IHByZXR0eSBtdWNoIHNob3VsZCBib2lsIGRvd24gdG8gc3RoIGxpa2UKCglyY3VfcmVhZF9sb2Nr
KCk7Cgl0YWJsZSA9IHJjdV9kZXJlZihjZ3JwLT50YWJsZSk7CglpZiAoa2V5IDwgdGFibGUtPmxl
bikKCQlyZXQgPSB0YWJsZVtrZXldOwoJZWxzZQoJCXJldCA9IE5VTEw7CglyY3VfcmVhZF91bmxv
Y2soKTsKCkRlcGVuZGluZyBvbiB0aGUgcmVxdWlyZW1lbnRzLCB3ZSBjYW4gZ2V0IHJpZCBvZiB0
aGUgdGFibGUtPmxlbiBjaGVjawpieSBtYWtpbmcga2V5IGFsbG9jIHBhdGggbW9yZSBleHBlbnNp
dmUgKGllLiBnaXZlIG91dCBrZXkgb25seSBhZnRlcgp0YWJsZSBleHRlbnNpb24gaXMgZnVsbHkg
ZG9uZSBhbmQgcHJvcGFnYXRlZCkuCgpUaGFua3MuCgotLSAKdGVqdW4KX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJ
bnRlbC1nZnhAbGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Au
b3JnL21haWxtYW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==
