From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH 0/4] memcontrol selftests fixups
Date: Fri, 13 May 2022 19:18:07 +0200
Message-ID: <20220513171811.730-1-mkoutny@suse.com>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652462320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lUuJK4eL9+OrReBYOWwXyTY//4zqDis40btPse6/uis=;
        b=ZfFAq7QzVD1bjBp+hkF5Z3fIv8AxgN0GzCRe9/I5WP8uaXdZ+RPtceXWSsm6MUZFQnXRSC
        2oKg8kF5CJh4K3Mi+mNb8k/06l/ppvpwpWERxZqevlMKpjNhxXkNBOSwii9lXxf/7qjD+u
        vNfpJWgXzl11DC15sWKmZHQbjp4oyFE=
In-Reply-To: <20220512174452.tr34tuh4k5jm6qjs-2sxDN0k4oOr/D8ZFBB3Vemm1Eemhq0z/AL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Richard Palethorpe <rpalethorpe-l3A5Bk7waGM@public.gmane.org>

SGVsbG8uCgpJJ20ganVzdCBmbHVzaGluZyB0aGUgc2ltcGxlIHBhdGNoZXMgdG8gbWFrZSBtZW1j
b250cm9sIHNlbGZ0ZXN0cyBjaGVjayB0aGUKZXZlbnRzIGJlaGF2aW9yIHdlIGhhZCBjb25zZW5z
dXMgYWJvdXQgKHRlc3RfbWVtY2dfbG93IGZhaWxzKS4gKEkndmUgZHJvcHBlZCB0bwpnb3RvIG1h
Y3JvcyBmb3Igbm93LikKCih0ZXN0X21lbWNnX3JlY2xhaW0sIHRlc3RfbWVtY2dfc3dhcF9tYXgg
ZmFpbCBmb3IgbWUgbm93IGJ1dCBpdCdzIHByZXNlbnQKZXZlbiBiZWZvcmUgdGhlIHJlZmFjdG9y
aW5nLikKClRoZSBvbmx5IGJpZ2dlciBjaGFuZ2UgaXMgYWRqdXN0bWVudCBvZiB0aGUgcHJvdGVj
dGVkIHZhbHVlcyB0byBtYWtlIHRlc3RzCnN1Y2NlZWQgd2l0aCB0aGUgZ2l2ZW4gdG9sZXJhbmNl
LgoKSXQncyBiYXNlZCBvbiBtbS1zdGFibGUgWzFdIGNvbW1pdCBlMjQwYWM1MmY3ZGEuIEFGQUlD
LCB0aGUgZml4dXAgYW5kIHBhcnRpYWwKcmV2ZXJ0cyBtYXkgYmUgZm9sZGVkIGludG8gcmVzcGVj
dGl2ZSBjb21taXRzLgpMZXQgbWUga25vdyBpZiBpdCBzaG91bGQgYmUgKHJlKWJhc2VkIG9uIHNv
bWV0aGluZyBlbHNlLgoKVGhhbmtzLApNaWNoYWwKClsxXSBodHRwczovL2dpdC5rZXJuZWwub3Jn
L3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9ha3BtL21tLmdpdC9sb2cvdG9vbHMvdGVzdGluZy9z
ZWxmdGVzdHMvY2dyb3VwP2g9bW0tc3RhYmxlCgpNaWNoYWwgS291dG7DvSAoNCk6CiAgc2VsZnRl
c3RzOiBtZW1jZzogRml4IGNvbXBpbGF0aW9uCiAgc2VsZnRlc3RzOiBtZW1jZzogRXhwZWN0IG5v
IGxvdyBldmVudHMgaW4gdW5wcm90ZWN0ZWQgc2libGluZwogIHNlbGZ0ZXN0czogbWVtY2c6IEFk
anVzdCBleHBlY3RlZCByZWNsYWltIHZhbHVlcyBvZiBwcm90ZWN0ZWQgY2dyb3VwcwogIHNlbGZ0
ZXN0czogbWVtY2c6IFJlbW92ZSBwcm90ZWN0aW9uIGZyb20gdG9wIGxldmVsIG1lbWNnCgogLi4u
L3NlbGZ0ZXN0cy9jZ3JvdXAvdGVzdF9tZW1jb250cm9sLmMgICAgICAgIHwgNTkgKysrKysrKysr
LS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKyksIDMwIGRlbGV0aW9u
cygtKQoKLS0gCjIuMzUuMwoK
