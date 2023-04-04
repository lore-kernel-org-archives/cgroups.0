From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 4/4] cgroup/cpuset: Make cpuset_attach_task() skip subpartitions CPUs for top_cpuset
Date: Tue,  4 Apr 2023 13:05:46 -0400
Message-ID: <20230404170546.2585050-5-longman@redhat.com>
References: <20230404170546.2585050-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680627989;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kw9bOB+w9RaCMC/2ecbxmrC9gMAMXWH6G3Pa3TXU2lQ=;
        b=fJLzgCKT+ZOBBzfTlUv9IeiPY8lvCuhsS0ll2JLWtR9QERYuRhhH97zNDs+UznZ3khg8EB
        82DqVi+PA27YEQd66PIh6WMImF+9WeKqrKkvJ7VuTZ9NLY4ZeOQCuO81fwLa9sCHodcBcG
        8939uHiJUPUdRIUaM9uRfxID3pbWh7s=
In-Reply-To: <20230404170546.2585050-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

SXQgaXMgZm91bmQgdGhhdCBhdHRhY2hpbmcgYSB0YXNrIHRvIHRoZSB0b3BfY3B1c2V0IGRvZXMg
bm90IGN1cnJlbnRseQppZ25vcmUgQ1BVcyBhbGxvY2F0ZWQgdG8gc3VicGFydGl0aW9ucyBpbiBj
cHVzZXRfYXR0YWNoX3Rhc2soKS4gU28gdGhlCmNvZGUgaXMgY2hhbmdlZCB0byBmaXggdGhhdC4K
ClNpZ25lZC1vZmYtYnk6IFdhaW1hbiBMb25nIDxsb25nbWFuLUgrd1hhSHhmN2FMUVQwZFpSK0Fs
ZkFAcHVibGljLmdtYW5lLm9yZz4KUmV2aWV3ZWQtYnk6IE1pY2hhbCBLb3V0bsO9IDxta291dG55
LUlCaTlSRy9iNjdrQHB1YmxpYy5nbWFuZS5vcmc+Ci0tLQoga2VybmVsL2Nncm91cC9jcHVzZXQu
YyB8IDMgKystCiAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0p
CgpkaWZmIC0tZ2l0IGEva2VybmVsL2Nncm91cC9jcHVzZXQuYyBiL2tlcm5lbC9jZ3JvdXAvY3B1
c2V0LmMKaW5kZXggZGIxZmNhNWNiYTA2Li4wNTZlYzdkYmZhM2MgMTAwNjQ0Ci0tLSBhL2tlcm5l
bC9jZ3JvdXAvY3B1c2V0LmMKKysrIGIva2VybmVsL2Nncm91cC9jcHVzZXQuYwpAQCAtMjU0MCw3
ICsyNTQwLDggQEAgc3RhdGljIHZvaWQgY3B1c2V0X2F0dGFjaF90YXNrKHN0cnVjdCBjcHVzZXQg
KmNzLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2spCiAJaWYgKGNzICE9ICZ0b3BfY3B1c2V0KQog
CQlndWFyYW50ZWVfb25saW5lX2NwdXModGFzaywgY3B1c19hdHRhY2gpOwogCWVsc2UKLQkJY3B1
bWFza19jb3B5KGNwdXNfYXR0YWNoLCB0YXNrX2NwdV9wb3NzaWJsZV9tYXNrKHRhc2spKTsKKwkJ
Y3B1bWFza19hbmRub3QoY3B1c19hdHRhY2gsIHRhc2tfY3B1X3Bvc3NpYmxlX21hc2sodGFzayks
CisJCQkgICAgICAgY3MtPnN1YnBhcnRzX2NwdXMpOwogCS8qCiAJICogY2FuX2F0dGFjaCBiZWZv
cmVoYW5kIHNob3VsZCBndWFyYW50ZWUgdGhhdCB0aGlzIGRvZXNuJ3QKIAkgKiBmYWlsLiAgVE9E
TzogaGF2ZSBhIGJldHRlciB3YXkgdG8gaGFuZGxlIGZhaWx1cmUgaGVyZQotLSAKMi4zMS4xCgo=
