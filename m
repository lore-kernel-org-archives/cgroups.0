From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 10/15] blk-rq-qos: constify rq_qos_ops
Date: Fri, 27 Jan 2023 08:08:52 +0100
Message-ID: <2d493ce0-2e90-4cd3-3dc8-e13346d63627@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-11-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803333; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZLjtTQii+9fOQx3sVy40FoU8CxAO/78qKr6FiJzBQ0=;
        b=1cvguCQvMvYPjaRVBrar+RL50xfm8krDuFJieHzuhugdlGi6cyEyV70j2D2TuMVFECcF8k
        VroinWueH8HKqajpg60NGFjOqlbmGDdGHo+WN9nBidZA6NPEiivU2v01aNZRYPmRhc/9oJ
        5mCabasQIzd2zB5ECHn+HevCdJsxeGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803333;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NZLjtTQii+9fOQx3sVy40FoU8CxAO/78qKr6FiJzBQ0=;
        b=LBmEFBjsjqt/hMpe7Oo7WuIA8+AAg3vBDNjQ8V7d0KpIWXEP+ObiqyfaOVuxTgwxqptIcn
        L9GvbcBHmq2G5MBw==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-11-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gVGhlc2Ugb3AgdmVj
dG9ycyBhcmUgY29uc3RhbnQsIHNvIG1hcmsgdGhlbSBjb25zdC4KPiAKPiBTaWduZWQtb2ZmLWJ5
OiBDaHJpc3RvcGggSGVsbHdpZyA8aGNoLWpjc3dHaE1VVjlnQHB1YmxpYy5nbWFuZS5vcmc+Cj4g
LS0tCj4gICBibG9jay9ibGstaW9jb3N0LmMgICAgfCAyICstCj4gICBibG9jay9ibGstaW9sYXRl
bmN5LmMgfCAyICstCj4gICBibG9jay9ibGstcnEtcW9zLmMgICAgfCAyICstCj4gICBibG9jay9i
bGstcnEtcW9zLmggICAgfCA0ICsrLS0KPiAgIGJsb2NrL2Jsay13YnQuYyAgICAgICB8IDIgKy0K
PiAgIDUgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQo+IApS
ZXZpZXdlZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlLWwzQTVCazd3YUdNQHB1YmxpYy5nbWFu
ZS5vcmc+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAg
ICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmUtbDNBNUJrN3dhR01AcHVibGljLmdt
YW5lLm9yZyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNV
U0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVy
ZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYs
IEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgo=
