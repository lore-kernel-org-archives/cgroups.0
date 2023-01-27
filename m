From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 04/15] blk-cgroup: pin the gendisk in struct blkcg_gq
Date: Fri, 27 Jan 2023 08:02:50 +0100
Message-ID: <89fc8cdf-1faf-6f67-ff12-78405d434d69@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-5-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674802970; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEqWCahipqJW4d7agZGVcQVF7iiP+fmVIvrNVbtdtTE=;
        b=yyKD+ewTh/51wAJ4yeE2HQ2M5DTaA3gbhHhqbnsHb/L9Rlal6NYix10LxOxtd6iinyZSWW
        vnHv3nF40kfnsK31kZbAYg+dUnp8yD+ysfj8rtRVUUNVH5iuIWNfpt9/6a8Lbkpw4DxXCm
        iybWn1XubVwWl22ItfFlqwH2Qi+Q+Xo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674802970;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pEqWCahipqJW4d7agZGVcQVF7iiP+fmVIvrNVbtdtTE=;
        b=eoYfXxcKKQEY+eclwtBbcr3YwyEin8a6Kfa8woNZG1eSrGhSq4X7zVtR26JoOYoVePRpsE
        V1V4GLplUQ8dXcCQ==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-5-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gQ3VycmVudGx5IGVh
Y2ggYmxrY2dfZ3EgaG9sZHMgYSByZXF1ZXN0X3F1ZXVlIHJlZmVyZW5jZSwgd2hpY2ggaXMgd2hh
dAo+IGlzIHVzZWQgaW4gdGhlIHBvbGljaWVzLiAgQnV0IGEgbG90IG9mIHRoZXNlIGludGVyZmFj
ZSB3aWxsIG1vdmUgb3ZlciB0bwo+IHVzZSBhIGdlbmRpc2ssIHNvIHN0b3JlIGEgZGlzayBpbiBz
dHJ1dCBibGtjZ19ncSBhbmQgaG9sZCBhIHJlZmVyZW5jZSB0bwo+IGl0Lgo+IAo+IFNpZ25lZC1v
ZmYtYnk6IENocmlzdG9waCBIZWxsd2lnIDxoY2gtamNzd0doTVVWOWdAcHVibGljLmdtYW5lLm9y
Zz4KPiAtLS0KPiAgIGJsb2NrL2JmcS1jZ3JvdXAuYyAgICAgICAgfCAgNiArKystLS0KPiAgIGJs
b2NrL2Jsay1jZ3JvdXAtcndzdGF0LmMgfCAgMiArLQo+ICAgYmxvY2svYmxrLWNncm91cC5jICAg
ICAgICB8IDI5ICsrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tCj4gICBibG9jay9ibGstY2dy
b3VwLmggICAgICAgIHwgMTEgKysrKystLS0tLS0KPiAgIGJsb2NrL2Jsay1pb2Nvc3QuYyAgICAg
ICAgfCAgMiArLQo+ICAgYmxvY2svYmxrLWlvbGF0ZW5jeS5jICAgICB8ICA0ICsrLS0KPiAgIGJs
b2NrL2Jsay10aHJvdHRsZS5jICAgICAgfCAgNCArKy0tCj4gICA3IGZpbGVzIGNoYW5nZWQsIDI3
IGluc2VydGlvbnMoKyksIDMxIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1ieTogSGFubmVzIFJl
aW5lY2tlIDxoYXJlLWwzQTVCazd3YUdNQHB1YmxpYy5nbWFuZS5vcmc+CgpDaGVlcnMsCgpIYW5u
ZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2Ug
QXJjaGl0ZWN0CmhhcmUtbDNBNUJrN3dhR01AcHVibGljLmdtYW5lLm9yZyAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25z
IEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJu
YmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3
IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgo=
