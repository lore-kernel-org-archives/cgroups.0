From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 0/2] cgroup_subsys_state lifecycle fixups
Date: Wed, 25 May 2022 17:15:15 +0200
Message-ID: <20220525151517.8430-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653491727; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4a7cwmdTvdlgEFSejjSvX4/8ts7XavMCpiK8LNYnCOA=;
        b=S764p8MSC4ECPdB9CovFD1ktd/0hVWDcubdEvvK8aSmY0UJpusRO6HHKQSsTNcMgWuyCql
        eBLZQrbPK0PC1oKOoUneaQ6fM2bdgxjIUAxHIpVWqwEAtMxZnfNueDfxUhaB6+kkOGb1xW
        DRX0/paoMi8hgAvuAuVI1kPl8BHSJv0=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

VHdvIGNvcm5lciBjYXNlcyB3ZXJlIGhhbmdpbmcgYXJvdW5kIFsyXVszXSByZWxhdGVkIHRvIGNz
cyBsaWZlY3ljbGVzLApzaW5jZSB0aGV5J3JlIGxvb3NlbHkgcmVsYXRlZCBJJ20gc2VuZGluZyB0
aGVtIHRvZ2V0aGVyLgoKVGhlIDJuZCBwYXRjaCBmaXhlcyBwcm9ibGVtcyBlbmNvdW50ZXJlZCBp
biBzeXpib3QgdGVzdHMgb25seS4KQWx0ZXJuYXRpdmUgc29sdXRpb25zIGNvdWxkIGJlOgotIGRh
aXN5LWNoYWluIGNzc19yZWxlYXNlX3dvcmtfZm4gZnJvbSB0aGUgb2ZmZW5kaW5nIGNzc19raWxs
ZWRfd29ya19mbiBjYWxsLAotIHJld29yayBraWxsX2NzcygpIG5vdCB0byByZWx5IG9uIG11bHRp
LXN0YWdlIGNzc19raWxsZWRfd29ya19mbigpIFsxXS4KClRoZSBzaW1wbGVzdCBhcHByb2FjaCB3
YXMgY2hvc2VuLgoKVGhlIG90aGVyIGV4aXN0aW5nIHVzZXJzIG9mIHBlcmNwdV9yZWZfa2lsbF9h
bmRfY29uZmlybSBhcmUgbm90IGFmZmVjdGVkIGJ5CnNpbWlsYXIgaXNzdWVzLgoKWzFdIFJvdWdo
IGlkZWEgaXMgdG8gb25seSBzeW5jaHJvbml6ZSB2aWEgYSBjb21wbGV0aW9uIGxpa2UgZS5nLgpu
dm1ldF9zcV9kZXN0cm95KCkgZG9lcyBhbmQgbW92ZSBtb3N0IG9mIGNzc19raWxsZWRfd29ya19m
bigpIGF0IHRoZSBlbmQgb2YKa2lsbF9jc3MoKS4ga2lsbF9jc3MoKSBpcyBvbmx5IHVzZWQgaW4g
cHJvY2VzcyBjb250ZXh0IHdoZW4gZGUtY29uZmlndXJpbmcKY29udHJvbGxlcnMgb3Igcm1kaXJp
bmcgYSBjZ3JvdXAuCgpbMl0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIyMDQwNDE0
MjUzNS4xNDU5NzUtMS1taW5ocXVhbmdidWk5OS1SZTVKUUVlUXFlOEF2eHRpdU13eDN3QHB1Ymxp
Yy5nbWFuZS5vcmcvClszXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIwMjIwNDEyMTky
NDU5LjIyNzc0MC0xLXRhZGV1c3ouc3RydWstUVNFajVGWVFobTRkbm0reVJPZkUwQUBwdWJsaWMu
Z21hbmUub3JnLwoKTWljaGFsIEtvdXRuw70gKDIpOgogIGNncm91cDogV2FpdCBmb3IgY2dyb3Vw
X3N1YnN5c19zdGF0ZSBvZmZsaW5pbmcgb24gdW5tb3VudAogIGNncm91cDogVXNlIHNlcGFyYXRl
IHdvcmsgc3RydWN0cyBvbiBjc3MgcmVsZWFzZSBwYXRoCgogaW5jbHVkZS9saW51eC9jZ3JvdXAt
ZGVmcy5oIHwgIDUgKysrLS0KIGtlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgICAgICB8IDE5ICsrKysr
KysrKysrLS0tLS0tLS0KIDIgZmlsZXMgY2hhbmdlZCwgMTQgaW5zZXJ0aW9ucygrKSwgMTAgZGVs
ZXRpb25zKC0pCgotLSAKMi4zNS4zCgo=
