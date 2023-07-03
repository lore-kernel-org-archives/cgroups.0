From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v3 0/3] cpuset: Allow setscheduler regardless of manipulated task
Date: Mon,  3 Jul 2023 19:27:38 +0200
Message-ID: <20230703172741.25392-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1688405263; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3aZiNrh37kog6hGn75GFfiY6ypdAuVwYLPGQChJfecA=;
        b=W+iPbXFm3UbXst4AU3cmDUb+AN9TGIlKpii2iWOl4asU0t5GhngfpIo3jJfk/dbwEWRQBx
        ZYsG96/C+2AH3xGG4fwQledsKa0MlY8Nmr0hUTCx+QgMPPt1oN7lsPlGmv1oH1xedK+6t3
        YOaTxUrXE4kC1dYvEbiTYBx2WpRbpnE=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Q2hhbmdlcyBpbiB2MzoKLSBvbmx5IHNraXAgcGVybWlzc2lvbnMgY2hlY2sgd2hlbiBlZmZlY3Rp
dmUgYWZmaW5pdHkgZG9lc24ndCBjaGFuZ2UKLSB1cGRhdGUgY29tbWl0IG1lc3NhZ2UgYWNjb3Jk
aW5nbHkKCkNoYW5nZXMgaW4gdjIgKGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMzA2MzAx
ODM5MDguMzIxNDgtMS1ta291dG55LUlCaTlSRy9iNjdrQHB1YmxpYy5nbWFuZS5vcmcpOgotIHJl
YmFzZWQgb24gbWFpbmxpbmUKLSBkcm9wIGlzX2luX3YyX21vZGUoKQoKQ2hhbmdlcyBpbiB2MSAo
aHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIzMDYyOTA5MTE0Ni4yODgwMS0xLW1rb3V0bnkt
SUJpOVJHL2I2N2tAcHVibGljLmdtYW5lLm9yZyk6Ci0gYWRkZWQgc2VsZnRlc3RzCi0gY29tbWVu
dHMgcmV3b3JkaW5nCgpSRkMgaW4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIyMDYyMzEy
NDk0NC4yNzUzLTEtbWtvdXRueS1JQmk5UkcvYjY3a0BwdWJsaWMuZ21hbmUub3JnCgpNaWNoYWwg
S291dG7DvSAoMyk6CiAgY3B1c2V0OiBBbGxvdyBzZXRzY2hlZHVsZXIgcmVnYXJkbGVzcyBvZiBt
YW5pcHVsYXRlZCB0YXNrCiAgc2VsZnRlc3RzOiBjZ3JvdXA6IE1pbm9yIGNvZGUgcmVvcmdhbml6
YXRpb25zCiAgc2VsZnRlc3RzOiBjZ3JvdXA6IEFkZCBjcHVzZXQgbWlncmF0aW9ucyB0ZXN0Y2Fz
ZQoKIE1BSU5UQUlORVJTICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgMiAr
CiBrZXJuZWwvY2dyb3VwL2NwdXNldC5jICAgICAgICAgICAgICAgICAgICAgICAgfCAgMTkgKy0K
IHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2Nncm91cC8uZ2l0aWdub3JlICAgICB8ICAgMSArCiB0
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9jZ3JvdXAvTWFrZWZpbGUgICAgICAgfCAgIDIgKwogdG9v
bHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL2Nncm91cF91dGlsLmMgIHwgICAyICsKIHRvb2xz
L3Rlc3Rpbmcvc2VsZnRlc3RzL2Nncm91cC9jZ3JvdXBfdXRpbC5oICB8ICAgMiArCiB0b29scy90
ZXN0aW5nL3NlbGZ0ZXN0cy9jZ3JvdXAvdGVzdF9jb3JlLmMgICAgfCAgIDIgKy0KIHRvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2Nncm91cC90ZXN0X2NwdXNldC5jICB8IDI3NSArKysrKysrKysrKysr
KysrKysKIC4uLi9zZWxmdGVzdHMvY2dyb3VwL3Rlc3RfY3B1c2V0X3Bycy5zaCAgICAgICB8ICAg
MiArLQogOSBmaWxlcyBjaGFuZ2VkLCAzMDIgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkK
IGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9jZ3JvdXAvdGVzdF9j
cHVzZXQuYwoKCmJhc2UtY29tbWl0OiBlNTVlNWRmMTkzZDI0N2EzOGE1ZTFhYzY1YTUzMTZhMGFk
Y2MyMmZhCi0tIAoyLjQxLjAKCg==
