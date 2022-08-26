From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH 0/4] Honor cgroup namespace when resolving cgroup id
Date: Fri, 26 Aug 2022 18:52:34 +0200
Message-ID: <20220826165238.30915-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661532778; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Hvh3ocNfi9tDUDY607bUOsG3YfmuEtYhO6IYXUHPG/Y=;
        b=iZPWN9zbTtAeBhE6GPmrISfKZTKDyRDEBt/NCX6jxUD5aOCumahpiZpRRQZJG5sSstyR9V
        /CxenkC8LBSDzl0Q+lWiZZEEKR1HoAnVbCQkvVBEV8A9g9upAyc090FiUXaE4EB5ZKwDUj
        vA1rDztB+5zLeJtfleOJOBR6UpCuVXE=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, bpf@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Aditya Kali <adityakali@google.com>, Serge Hallyn <serge.hallyn@canonical.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yonghong Song <yhs@fb.com>, Muneendra Kumar <muneendra.kumar@broadcom.com>, Yosry Ahmed <yosryahmed@google.com>, Hao Luo <haoluo@google.com>

Q2dyb3VwIGlkIGlzIGJlY29taW5nIGEgbmV3IHdheSBmb3IgdXNlcnNwYWNlIGhvdyB0byByZWZl
ciB0byBjZ3JvdXBzIGl0CndhbnRzIHRvIGFjdCB1cG9uLiBBcyBvcHBvc2VkIHRvIGNncm91cGZz
IChwYXRocywgb3BlbmVkIEZEcyksIHRoZQpjdXJyZW50IGFwcHJvYWNoIGRvZXMgbm90IHJlZmxl
Y3QgbGltaXRlZCB2aWV3IGJ5IChub24taW5pdCkgY2dyb3VwCm5hbWVzcGFjZXMuCgpUaGlzIHBh
dGNoZXMgZG9uJ3QgYWltIHRvIGxpbWl0IHdoYXQgYSB1c2VyIGNhbiBkbyAoY29uc2lkZXIgYW4g
dWlkPTAgaW4KbWVyZSBjZ3JvdXAgbmFtZXNwYWNlKSBidXQgdG8gcHJvdmlkZSBjb25zaXN0ZW50
IHZpZXcgd2l0aGluIGEKbmFtZXNwYWNlLgoKVGhlIHNlcmllcyBpcyBiYXNlZCBvbiBicGYtbmV4
dCB3aXRoIHRoZSBuZXcgY2dyb3VwX2l0ZXIuIEkndmUgb25seQpib290LXRlc3RlZCBpdCAoZXNw
ZWNpYWxseSBJIGRpZG4ndCBydW4gdGhlIEJQRiBzZWxmdGVzdCkuCgpNaWNoYWwgS291dG7DvSAo
NCk6CiAgY2dyb3VwOiBIb25vciBjYWxsZXIncyBjZ3JvdXAgTlMgd2hlbiByZXNvbHZpbmcgcGF0
aAogIGNncm91cDogY2dyb3VwOiBIb25vciBjYWxsZXIncyBjZ3JvdXAgTlMgd2hlbiByZXNvbHZp
bmcgY2dyb3VwIGlkCiAgY2dyb3VwOiBIb21vZ2VuaXplIGNncm91cF9nZXRfZnJvbV9pZCgpIHJl
dHVybiB2YWx1ZQogIGNncm91cC9icGY6IEhvbm9yIGNncm91cCBOUyBpbiBjZ3JvdXBfaXRlciBm
b3IgYW5jZXN0b3JzCgogYmxvY2svYmxrLWNncm91cC1mYy1hcHBpZC5jIHwgIDQgKy0tCiBpbmNs
dWRlL2xpbnV4L2Nncm91cC5oICAgICAgfCAgOCArKystLS0KIGtlcm5lbC9icGYvY2dyb3VwX2l0
ZXIuYyAgICB8ICA5ICsrKystLS0KIGtlcm5lbC9jZ3JvdXAvY2dyb3VwLmMgICAgICB8IDUzICsr
KysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0KIG1tL21lbWNvbnRyb2wuYyAgICAg
ICAgICAgICB8ICA0ICstLQogNSBmaWxlcyBjaGFuZ2VkLCA1NCBpbnNlcnRpb25zKCspLCAyNCBk
ZWxldGlvbnMoLSkKCgpiYXNlLWNvbW1pdDogMzQzOTQ5ZTEwNzk4YTUyYzZkNmExNGVmZmM5NjJl
MDEwZWQ0NzFhZQotLSAKMi4zNy4wCgo=
