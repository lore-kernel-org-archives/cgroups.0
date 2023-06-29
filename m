From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 0/3] cpuset: Allow setscheduler regardless of manipulated task
Date: Thu, 29 Jun 2023 11:11:43 +0200
Message-ID: <20230629091146.28801-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1688029913; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=eakZ9Lwqp66DOPYDD7y7VLeLOLV3zqoUBYGx3Z4WOnY=;
        b=eLEATQF/QD87CNPxQL0qRd1yPM+gwm4aUtlPjCwxI47+fW7Z9tuLJHE7ks451dK4laL3pI
        8zEvCnCS3XrXPZVxZw5oQgqEbXxyuLUXAi4fXxLJX5nTejhVbG5jLbIqoquhY5LWEHNgTk
        id7Hkm0ccym9GKAtLhyiRko4959cZdY=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Q2hhbmdlcyBpbiB2MToKLSBhZGRlZCBzZWxmdGVzdHMKLSBjb21tZW50cyByZXdvcmRpbmcKClJG
QyBpbiBodHRwczovL2xvcmUua2VybmVsLm9yZy9yLzIwMjIwNjIzMTI0OTQ0LjI3NTMtMS1ta291
dG55LUlCaTlSRy9iNjdrQHB1YmxpYy5nbWFuZS5vcmcKCk1pY2hhbCBLb3V0bsO9ICgzKToKICBj
cHVzZXQ6IEFsbG93IHNldHNjaGVkdWxlciByZWdhcmRsZXNzIG9mIG1hbmlwdWxhdGVkIHRhc2sK
ICBzZWxmdGVzdHM6IGNncm91cDogTWlub3IgY29kZSByZW9yZ2FuaXphdGlvbnMKICBzZWxmdGVz
dHM6IGNncm91cDogQWRkIGNwdXNldCBtaWdyYXRpb25zIHRlc3RjYXNlCgogTUFJTlRBSU5FUlMg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgICAyICsKIGtlcm5lbC9jZ3JvdXAv
Y3B1c2V0LmMgICAgICAgICAgICAgICAgICAgICAgICB8ICAgNyArCiB0b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9jZ3JvdXAvLmdpdGlnbm9yZSAgICAgfCAgIDEgKwogdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvY2dyb3VwL01ha2VmaWxlICAgICAgIHwgICAyICsKIHRvb2xzL3Rlc3Rpbmcvc2VsZnRl
c3RzL2Nncm91cC9jZ3JvdXBfdXRpbC5jICB8ICAgMiArCiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9jZ3JvdXAvY2dyb3VwX3V0aWwuaCAgfCAgIDIgKwogdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMv
Y2dyb3VwL3Rlc3RfY29yZS5jICAgIHwgICAyICstCiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9j
Z3JvdXAvdGVzdF9jcHVzZXQuYyAgfCAyNzIgKysrKysrKysrKysrKysrKysrCiAuLi4vc2VsZnRl
c3RzL2Nncm91cC90ZXN0X2NwdXNldF9wcnMuc2ggICAgICAgfCAgIDIgKy0KIDkgZmlsZXMgY2hh
bmdlZCwgMjkwIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2
NDQgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL3Rlc3RfY3B1c2V0LmMKCgpiYXNlLWNv
bW1pdDogNjk5NWUyZGU2ODkxYzcyNGJmZWIyZGIzM2Q3Yjg3Nzc1ZjkxM2FkMQotLSAKMi40MS4w
Cgo=
