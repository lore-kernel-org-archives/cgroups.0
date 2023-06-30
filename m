From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2 0/3] cpuset: Allow setscheduler regardless of manipulated task
Date: Fri, 30 Jun 2023 20:39:05 +0200
Message-ID: <20230630183908.32148-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1688150350; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=6BmQ7Ou90mXrw1i1JySDLRPRos1xC6XTC4e8yECyu7A=;
        b=oqniinXgT77kTbeEaOEktWtFChIjGDREnpNG4pBy9q4Nchv1U5gZO/7A9LUWxXlqwZtOq3
        DDhdTxIxAIxg/+9HUouoJwmHmVK8Nt6kpYbBiLrXzWhKLES+69pnTcUvoLPRNluDJoZ4jP
        TWkIEUyFplzTdPayKyBil4MFWgOkh7I=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Q2hhbmdlcyBpbiB2MjoKLSByZWJhc2VkIG9uIG1haW5saW5lCi0gZHJvcCBpc19pbl92Ml9tb2Rl
KCkKCkNoYW5nZXMgaW4gdjEgKGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMzA2MjkwOTEx
NDYuMjg4MDEtMS1ta291dG55LUlCaTlSRy9iNjdrQHB1YmxpYy5nbWFuZS5vcmcpOgotIGFkZGVk
IHNlbGZ0ZXN0cwotIGNvbW1lbnRzIHJld29yZGluZwoKUkZDIGluIGh0dHBzOi8vbG9yZS5rZXJu
ZWwub3JnL3IvMjAyMjA2MjMxMjQ5NDQuMjc1My0xLW1rb3V0bnktSUJpOVJHL2I2N2tAcHVibGlj
LmdtYW5lLm9yZwoKTWljaGFsIEtvdXRuw70gKDMpOgogIGNwdXNldDogQWxsb3cgc2V0c2NoZWR1
bGVyIHJlZ2FyZGxlc3Mgb2YgbWFuaXB1bGF0ZWQgdGFzawogIHNlbGZ0ZXN0czogY2dyb3VwOiBN
aW5vciBjb2RlIHJlb3JnYW5pemF0aW9ucwogIHNlbGZ0ZXN0czogY2dyb3VwOiBBZGQgY3B1c2V0
IG1pZ3JhdGlvbnMgdGVzdGNhc2UKCiBNQUlOVEFJTkVSUyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfCAgIDIgKwoga2VybmVsL2Nncm91cC9jcHVzZXQuYyAgICAgICAgICAgICAg
ICAgICAgICAgIHwgIDEzICstCiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9jZ3JvdXAvLmdpdGln
bm9yZSAgICAgfCAgIDEgKwogdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL01ha2VmaWxl
ICAgICAgIHwgICAyICsKIHRvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2Nncm91cC9jZ3JvdXBfdXRp
bC5jICB8ICAgMiArCiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9jZ3JvdXAvY2dyb3VwX3V0aWwu
aCAgfCAgIDIgKwogdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvY2dyb3VwL3Rlc3RfY29yZS5jICAg
IHwgICAyICstCiB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9jZ3JvdXAvdGVzdF9jcHVzZXQuYyAg
fCAyNzIgKysrKysrKysrKysrKysrKysrCiAuLi4vc2VsZnRlc3RzL2Nncm91cC90ZXN0X2NwdXNl
dF9wcnMuc2ggICAgICAgfCAgIDIgKy0KIDkgZmlsZXMgY2hhbmdlZCwgMjkzIGluc2VydGlvbnMo
KyksIDUgZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgdG9vbHMvdGVzdGluZy9zZWxm
dGVzdHMvY2dyb3VwL3Rlc3RfY3B1c2V0LmMKCgpiYXNlLWNvbW1pdDogZTU1ZTVkZjE5M2QyNDdh
MzhhNWUxYWM2NWE1MzE2YTBhZGNjMjJmYQotLSAKMi40MS4wCgo=
