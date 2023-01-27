From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 13/15] blk-cgroup: pass a gendisk to pd_alloc_fn
Date: Fri, 27 Jan 2023 08:10:53 +0100
Message-ID: <7d96ab9b-757f-6513-73c6-8653c8785839@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-14-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803453; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oAfqBzQqYP3VsTiXRw/uj9hOAmLoJ++UOqGfgLn7TpY=;
        b=kUb1py6wjARTzXHl8KzRUWCF7GzBz9iA6ab/yohm6Veb7MM3qodTV1tXZXmQTbPk0qfN+D
        vlJVd+OuoPNmfnvvoyRv4ztmg9xP02D1Ig2J4//LRe/nDySla75ygrG6k2KGovCPVflqJY
        Qa3KA9lpvDMpoarVAuuIntkaEv0YRNQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803453;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oAfqBzQqYP3VsTiXRw/uj9hOAmLoJ++UOqGfgLn7TpY=;
        b=w4Q+78MF4vvJ2/LWyPvawJV6ny0aEAw6XolMk0IW5ozmLTGtq83aBYl3kD71m9k0/T4v0f
        eCLTRu5T1nrug1AA==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-14-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gTm8gbmVlZCB0byB0
aGUgcmVxdWVzdF9xdWV1ZSBoZXJlLCBwYXNzIGEgZ2VuZGlzayBhbmQgZXh0cmFjdCB0aGUKPiBu
b2RlIGlkcyBmcm9tIHRoYXQuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcg
PGhjaC1qY3N3R2hNVVY5Z0BwdWJsaWMuZ21hbmUub3JnPgo+IC0tLQo+ICAgYmxvY2svYmZxLWNn
cm91cC5jICAgIHwgIDYgKysrLS0tCj4gICBibG9jay9ibGstY2dyb3VwLmMgICAgfCAxMCArKysr
Ky0tLS0tCj4gICBibG9jay9ibGstY2dyb3VwLmggICAgfCAgNCArKy0tCj4gICBibG9jay9ibGst
aW9jb3N0LmMgICAgfCAgNyArKysrLS0tCj4gICBibG9jay9ibGstaW9sYXRlbmN5LmMgfCAgNyAr
KystLS0tCj4gICBibG9jay9ibGstaW9wcmlvLmMgICAgfCAgMiArLQo+ICAgYmxvY2svYmxrLXRo
cm90dGxlLmMgIHwgIDcgKysrLS0tLQo+ICAgNyBmaWxlcyBjaGFuZ2VkLCAyMSBpbnNlcnRpb25z
KCspLCAyMiBkZWxldGlvbnMoLSkKPiBSZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJl
LWwzQTVCazd3YUdNQHB1YmxpYy5nbWFuZS5vcmc+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBI
YW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0Cmhh
cmUtbDNBNUJrN3dhR01AcHVibGljLmdtYW5lLm9yZyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZl
bGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2No
w6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBN
YXJ0amUgQm91ZGllbiBNb2VybWFuCgo=
