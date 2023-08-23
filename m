From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH 0/2] cgroup: Remove pidlist caching from v1 code
Date: Wed, 23 Aug 2023 19:48:02 +0200
Message-ID: <20230823174804.23632-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692812887; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=SsaEssAOEkN2Y0295dMCvJoKexgUN6Qg1vqOmf8AW9E=;
        b=AYslP+2cUEdTAAh558fjOTemjSuurI/WV8WG523wzIy5VERo0FA0FclgkKAVPFWTVjdJoG
        me8WfQKcBFgJdermRJCdAAm6fhI5LZQ9vc5oMLfWbEka9q4fyqGOftlRBiPrSJweIDDK1R
        pO4CQztxUV8cHlnyK1JUW+4D3UTIyhU=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Firo Yang <firo.yang@suse.com>

TW9yZSBkZXRhaWxzIGluIHRoZSBmaXJzdCBjb21taXQgbWVzc2FnZS4KCk1pY2hhbCBLb3V0bsO9
ICgyKToKICBjZ3JvdXA6IFByaW50IHYxIGNncm91cC5wcm9jcyBhbmQgdGFza3Mgd2l0aG91dCBw
aWRsaXN0cwogIGNncm91cDogUmVtb3ZlIHYxIHNwZWNpZmljIHBpZGxpc3QgY29kZQoKIGluY2x1
ZGUvbGludXgvY2dyb3VwLWRlZnMuaCAgICAgfCAgIDcgLQoga2VybmVsL2Nncm91cC9jZ3JvdXAt
aW50ZXJuYWwuaCB8ICAxMiArLQoga2VybmVsL2Nncm91cC9jZ3JvdXAtdjEuYyAgICAgICB8IDM4
NCArKy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQoga2VybmVsL2Nncm91cC9jZ3JvdXAu
YyAgICAgICAgICB8ICAxMSArLQogNCBmaWxlcyBjaGFuZ2VkLCAyNiBpbnNlcnRpb25zKCspLCAz
ODggZGVsZXRpb25zKC0pCgotLSAKMi40MS4wCgo=
