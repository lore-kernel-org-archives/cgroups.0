From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 1/5] cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()
Date: Tue, 11 Apr 2023 09:35:57 -0400
Message-ID: <20230411133601.2969636-2-longman@redhat.com>
References: <20230411133601.2969636-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681220182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8knbqgpwDwW2izpddcqO89y+h297sf846uyalSPG3Do=;
        b=Yo0cXe5MdkQ9mzjs7XKfhor7dq3vQNRI0jnhqQcAcOKi98DM9KvXEqUYeq4sDUweeeWp/E
        q6S0g5lbg/CGvfTldGuWk7hjPPnnFmXSDaql8peVwkDfbPumA7xg9cwLpOsu9UldR9JbSY
        5nGTtMyvtxLyrTvntNyGLJ8SU88Dnj4=
In-Reply-To: <20230411133601.2969636-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

QWZ0ZXIgYSBzdWNjZXNzZnVsIGNwdXNldF9jYW5fYXR0YWNoKCkgY2FsbCB3aGljaCBpbmNyZW1l
bnRzIHRoZQphdHRhY2hfaW5fcHJvZ3Jlc3MgZmxhZywgZWl0aGVyIGNwdXNldF9jYW5jZWxfYXR0
YWNoKCkgb3IgY3B1c2V0X2F0dGFjaCgpCndpbGwgYmUgY2FsbGVkIGxhdGVyLiBJbiBjcHVzZXRf
YXR0YWNoKCksIHRhc2tzIGluIGNwdXNldF9hdHRhY2hfd3EsCmlmIHByZXNlbnQsIHdpbGwgYmUg
d29rZW4gdXAgYXQgdGhlIGVuZC4gVGhhdCBpcyBub3QgdGhlIGNhc2UgaW4KY3B1c2V0X2NhbmNl
bF9hdHRhY2goKS4gU28gbWlzc2VkIHdha2V1cCBpcyBwb3NzaWJsZSBpZiB0aGUgYXR0YWNoCm9w
ZXJhdGlvbiBpcyBzb21laG93IGNhbmNlbGxlZC4gRml4IHRoYXQgYnkgZG9pbmcgdGhlIHdha2V1
cCBpbgpjcHVzZXRfY2FuY2VsX2F0dGFjaCgpIGFzIHdlbGwuCgpGaXhlczogZTQ0MTkzZDM5ZThk
ICgiY3B1c2V0OiBsZXQgaG90cGx1ZyBwcm9wYWdhdGlvbiB3b3JrIHdhaXQgZm9yIHRhc2sgYXR0
YWNoaW5nIikKU2lnbmVkLW9mZi1ieTogV2FpbWFuIExvbmcgPGxvbmdtYW4tSCt3WGFIeGY3YUxR
VDBkWlIrQWxmQUBwdWJsaWMuZ21hbmUub3JnPgpSZXZpZXdlZC1ieTogTWljaGFsIEtvdXRuw70g
PG1rb3V0bnktSUJpOVJHL2I2N2tAcHVibGljLmdtYW5lLm9yZz4KLS0tCiBrZXJuZWwvY2dyb3Vw
L2NwdXNldC5jIHwgNiArKysrKy0KIDEgZmlsZSBjaGFuZ2VkLCA1IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvY2dyb3VwL2NwdXNldC5jIGIva2VybmVs
L2Nncm91cC9jcHVzZXQuYwppbmRleCBiYzRkY2ZkN2JlZTUuLjA2NjY4OWE3ZGNjMyAxMDA2NDQK
LS0tIGEva2VybmVsL2Nncm91cC9jcHVzZXQuYworKysgYi9rZXJuZWwvY2dyb3VwL2NwdXNldC5j
CkBAIC0yNTA3LDExICsyNTA3LDE1IEBAIHN0YXRpYyBpbnQgY3B1c2V0X2Nhbl9hdHRhY2goc3Ry
dWN0IGNncm91cF90YXNrc2V0ICp0c2V0KQogc3RhdGljIHZvaWQgY3B1c2V0X2NhbmNlbF9hdHRh
Y2goc3RydWN0IGNncm91cF90YXNrc2V0ICp0c2V0KQogewogCXN0cnVjdCBjZ3JvdXBfc3Vic3lz
X3N0YXRlICpjc3M7CisJc3RydWN0IGNwdXNldCAqY3M7CiAKIAljZ3JvdXBfdGFza3NldF9maXJz
dCh0c2V0LCAmY3NzKTsKKwljcyA9IGNzc19jcyhjc3MpOwogCiAJcGVyY3B1X2Rvd25fd3JpdGUo
JmNwdXNldF9yd3NlbSk7Ci0JY3NzX2NzKGNzcyktPmF0dGFjaF9pbl9wcm9ncmVzcy0tOworCWNz
LT5hdHRhY2hfaW5fcHJvZ3Jlc3MtLTsKKwlpZiAoIWNzLT5hdHRhY2hfaW5fcHJvZ3Jlc3MpCisJ
CXdha2VfdXAoJmNwdXNldF9hdHRhY2hfd3EpOwogCXBlcmNwdV91cF93cml0ZSgmY3B1c2V0X3J3
c2VtKTsKIH0KIAotLSAKMi4zMS4xCgo=
