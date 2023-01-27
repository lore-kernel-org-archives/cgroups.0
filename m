From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 03/15] blk-cgroup: delay blk-cgroup initialization until
 add_disk
Date: Fri, 27 Jan 2023 08:01:36 +0100
Message-ID: <f90b6ac5-4dc9-2919-f69c-a6247ca76c59@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-4-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674802896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+JKblaROLgQo6QRcA221IEs6cRRlMefbbAcPtnIP9GI=;
        b=ogchSG6X3wP8jn6k+SIBbsdT6tKWaGp6BzSFjQLv2bZ3h9nE8GTWZZTZ+NpLrDgr27ulGT
        vQHc/4yn53UnQ2UMjGZOCsi2gSA+Sa80OjM/2DgInOarrJ2Opd702XIKY73GSCRpz1Vtnb
        H8mWArHNWfyKqVHKPD+or0Kkfoe5dsY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674802896;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+JKblaROLgQo6QRcA221IEs6cRRlMefbbAcPtnIP9GI=;
        b=noVGeRd8wo92i5RkZNz5YjEAotOlD9hGeCy9t5rknkUedNL2bK2hHq7LF0eh0EYyKYAk8e
        kXbCLmMHZiwSA+DQ==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-4-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVGhlcmUgaXMgbm8g
bmVlZCB0byBpbml0aWFsaXplIHRoZSBncm91cCBjb2RlIGJlZm9yZSB0aGUgZGlzayBpcyBtYXJr
ZWQKPiBsaXZlLiAgTW92aW5nIHRoZSBjZ3JvdXAgaW5pdGlhbGl6YXRpb24gZWFybGllciB3aWxs
IGhlbHAgdG8gaGF2ZSBhCj4gZnVsbHkgaW5pdGlhbGl6ZWQgc3RydWN0IGRldmljZSBpbiB0aGUg
Z2VuZGlzayBmb3IgdGhlIGNncm91cCBjb2RlIHRvCj4gdXNlIGluIHRoZSBmdXR1cmUuICBTaW1p
bGFybHkgdGVhciB0aGUgY2dyb3VwIGluZm9ybWF0aW9uIGRvd24gaW4KPiBkZWxfZ2VuZGlzayB0
byBiZSBzeW1tZXRyaWMgYW5kIGJlY2F1c2Ugbm9uZSBvZiB0aGUgY2dyb3VwIHRyYWNraW5nIGlz
Cj4gbmVlZGVkIG9uY2Ugbm9uLXBhc3N0aHJvdWdoIEkvTyBzdG9wcy4KPiAKPiBTaWduZWQtb2Zm
LWJ5OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoLWpjc3dHaE1VVjlnQHB1YmxpYy5nbWFuZS5vcmc+
Cj4gLS0tCj4gICBibG9jay9nZW5oZC5jIHwgMTcgKysrKysrKysrLS0tLS0tLS0KPiAgIDEgZmls
ZSBjaGFuZ2VkLCA5IGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pCj4gClJldmlld2VkLWJ5
OiBIYW5uZXMgUmVpbmVja2UgPGhhcmUtbDNBNUJrN3dhR01AcHVibGljLmdtYW5lLm9yZz4KCkNo
ZWVycywKCkhhbm5lcwotLSAKRHIuIEhhbm5lcyBSZWluZWNrZSAgICAgICAgICAgICAgICBLZXJu
ZWwgU3RvcmFnZSBBcmNoaXRlY3QKaGFyZS1sM0E1Qms3d2FHTUBwdWJsaWMuZ21hbmUub3JnICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgKzQ5IDkxMSA3NDA1MyA2ODgKU1VTRSBTb2Z0d2Fy
ZSBTb2x1dGlvbnMgR21iSCwgTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnCkhSQiAzNjgw
OSAoQUcgTsO8cm5iZXJnKSwgR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3RldiwgQW5kcmV3Ck15
ZXJzLCBBbmRyZXcgTWNEb25hbGQsIE1hcnRqZSBCb3VkaWVuIE1vZXJtYW4KCg==
