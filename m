From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 15/15] blk-cgroup: move the cgroup information to struct
 gendisk
Date: Fri, 27 Jan 2023 08:12:14 +0100
Message-ID: <f202c9ba-23c8-9c1b-be8c-e87c94427669@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-16-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803535; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L9A3/bx1nMGaGFX3IVqLkC1CtqNCMmaJvRrFybXqukk=;
        b=K7BWqnFKP5u322iMRCGIx6Xbfiu06lLuyEVRXFAFd+nQu5R7z5Mu5wVcrtyA5xyMhnj7m4
        PxPZq1VyYXK04ksS9U+558GQPVemo+LigZbKS8Dl92CTUEf97PTsdYZbdnIznCAUIndVMj
        rCUaNflYw76wi6939cxjyCNYeM7j4ck=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803535;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L9A3/bx1nMGaGFX3IVqLkC1CtqNCMmaJvRrFybXqukk=;
        b=o28bV7RyhQiiC9h4XLWSevfMx39INl6AmgYHPykWbnoULdMzagaONbHdbW2SQBAZeiyawN
        fyDsS/E0/gLoNUCw==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-16-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gY2dyb3VwIGluZm9y
bWF0aW9uIG9ubHkgbWFrZXMgc2Vuc2Ugb24gYSBsaXZlIGdlbmRpc2sgdGhhdCBhbGxvd3MKPiBm
aWxlIHN5c3RlbSBJL08gKHdoaWNoIGluY2x1ZGVzIHRoZSByYXcgYmxvY2sgZGV2aWNlKS4gIFNv
IG1vdmUgb3Zlcgo+IHRoZSBjZ3JvdXAgcmVsYXRlZCBtZW1iZXJzLgo+IAo+IFNpZ25lZC1vZmYt
Ynk6IENocmlzdG9waCBIZWxsd2lnIDxoY2gtamNzd0doTVVWOWdAcHVibGljLmdtYW5lLm9yZz4K
PiAtLS0KPiAgIGJsb2NrL2JmcS1jZ3JvdXAuYyAgICAgfCAgNCArKy0tCj4gICBibG9jay9ibGst
Y2dyb3VwLmMgICAgIHwgNDggKysrKysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0t
LS0tCj4gICBibG9jay9ibGstY2dyb3VwLmggICAgIHwgIDIgKy0KPiAgIGJsb2NrL2Jsay1pb2xh
dGVuY3kuYyAgfCAgMiArLQo+ICAgYmxvY2svYmxrLXRocm90dGxlLmMgICB8IDE2ICsrKysrKysr
LS0tLS0tCj4gICBpbmNsdWRlL2xpbnV4L2Jsa2Rldi5oIHwgMTAgKysrKy0tLS0tCj4gICA2IGZp
bGVzIGNoYW5nZWQsIDQzIGluc2VydGlvbnMoKyksIDM5IGRlbGV0aW9ucygtKQo+IApSZXZpZXdl
ZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlLWwzQTVCazd3YUdNQHB1YmxpYy5nbWFuZS5vcmc+
CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAg
S2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmUtbDNBNUJrN3dhR01AcHVibGljLmdtYW5lLm9y
ZyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29m
dHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIg
MzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJl
dwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgo=
