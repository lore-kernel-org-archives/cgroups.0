From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [RFC PATCH 0/3] Rework locking when rendering mountinfo cgroup paths
Date: Tue,  2 May 2023 15:38:44 +0200
Message-ID: <20230502133847.14570-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683034729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=crvNNZKHkX0qSv+47z6gi2siVKpNnXpyMa5UXHMzqQg=;
        b=PgbCIBlRsSh3JTLYfKjClKjprcbn9dDOrwzSI48oqzC8Za6rSjZhTcRjbJjhx3G3GcUMkH
        GDsVgc3VXNyAOEWuPPYC5uPNP2NyBoVzTWJS+KMhzu7OfTRSmbGsT1gF66FpRWV4RR5iLx
        0F70pNiNbLtU19jYvzEwRru7w+Zqp9U=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Jiri Wiesner <jwiesner-l3A5Bk7waGM@public.gmane.org>

SWRlYSBmb3IgdGhlc2UgbW9kaWZpY2F0aW9uIGNhbWUgdXAgd2hlbiBjc3Nfc2V0X2xvY2sgc2Vl
bWVkIHVubmVlZGVkIGluCmNncm91cF9zaG93X3BhdGguCkl0J3MgYSBkZWxpY2F0ZSBjaGFuZ2Us
IHNvIHRoZSBkZWNpZGluZyBmYWN0b3Igd2FzIHdoZW4gY2dyb3VwX3Nob3dfcGF0aCBwb3BwZWQK
dXAgYWxzbyBpbiBzb21lIHByb2ZpbGVzIG9mIGZyZXF1ZW50IG1vdW50aW5mbyByZWFkZXJzLgpU
aGUgaWRlYSBpcyB0byB0cmFkZSB0aGUgZXhjbHVzaXZlIGNzc19zZXRfbG9jayBmb3IgdGhlIHNo
YXJlZApuYW1lc3BhY2Vfc2VtIHdoZW4gcmVuZGVyaW5nIGNncm91cCBwYXRocy4gRGV0YWlscyBh
cmUgZGVzY3JpYmVkIG1vcmUgaW4KaW5kaXZpZHVhbCBjb21taXRzLgoKTWljaGFsIEtvdXRuw70g
KDMpOgogIGNncm91cDogRHJvcCB1bnVzZWQgZnVuY3Rpb24gZm9yIGNncm91cF9wYXRoCiAgY2dy
b3VwOiBSZWx5IG9uIG5hbWVzcGFjZV9zZW0gaW4gY3VycmVudF9jZ25zX2Nncm91cF9mcm9tX3Jv
b3QKICAgIGV4cGxpY2l0bHkKICBjZ3JvdXA6IERvIG5vdCB0YWtlIGNzc19zZXRfbG9jayBpbiBj
Z3JvdXBfc2hvd19wYXRoCgogZnMvbmFtZXNwYWNlLmMgICAgICAgICB8ICA1ICsrKy0KIGluY2x1
ZGUvbGludXgvbW91bnQuaCAgfCAgNCArKysKIGtlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgfCA1OCAr
KysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KIDMgZmlsZXMgY2hhbmdl
ZCwgMTggaW5zZXJ0aW9ucygrKSwgNDkgZGVsZXRpb25zKC0pCgotLSAKMi40MC4xCgo=
