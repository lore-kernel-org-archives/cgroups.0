From: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH 08/15] blk-wbt: open code wbt_queue_depth_changed in
 wbt_update_limits
Date: Fri, 27 Jan 2023 08:07:26 +0100
Message-ID: <7d70d816-ffce-2196-1de2-b30be4215ee3@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-9-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803246; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6RGdD0dbpYfwJsZsZUvRLD7D/Kc7PVnGQWv53OgY25s=;
        b=EcYo8HUR67SO+Xc2VS5Ep1l/PIjKiG+x/JDyLbYgoIKYlkyuBb6St8tZGXvpc8vSR2Pick
        U/54zdrUfyEuzYrol8mSp5axGX49bfcL9FzHkVKpkZPJlhEGMBEAaI1EM8MR5Bp+H9tiJd
        CzUarE1q/jKOOaXfzUqxEq3ysutanJE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803246;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6RGdD0dbpYfwJsZsZUvRLD7D/Kc7PVnGQWv53OgY25s=;
        b=hFIs69ZKgDgDIX7GpxB7uKo2ot5TJpzCWPdyQySp/jrb1xbdhSBhpIqFpYwLUEaiO5irhy
        bEkyQaUUB+Juu0CA==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-9-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gTm8gcmVhbCBuZWVk
IHRvIGFsbCB0aGUgbWV0aG9kIGhlcmUsIHNvIG9wZW4gY29kZSB0byBpdCB0byBwcmVwYXJlCj4g
Zm9yIHNvbWUgcGFyYW10ZXIgcGFzc2luZyBjaGFuZ2VzLgo+IAo+IFNpZ25lZC1vZmYtYnk6IENo
cmlzdG9waCBIZWxsd2lnIDxoY2gtamNzd0doTVVWOWdAcHVibGljLmdtYW5lLm9yZz4KPiAtLS0K
PiAgIGJsb2NrL2Jsay13YnQuYyB8IDQgKystLQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEvYmxvY2svYmxrLXdidC5j
IGIvYmxvY2svYmxrLXdidC5jCj4gaW5kZXggNTQyMjcxZmE5OWU4ZjcuLjQ3M2FlNzJiZWZhZjFh
IDEwMDY0NAo+IC0tLSBhL2Jsb2NrL2Jsay13YnQuYwo+ICsrKyBiL2Jsb2NrL2Jsay13YnQuYwo+
IEBAIC04NjMsOSArODYzLDkgQEAgaW50IHdidF9pbml0KHN0cnVjdCBnZW5kaXNrICpkaXNrKQo+
ICAgCXJ3Yi0+ZW5hYmxlX3N0YXRlID0gV0JUX1NUQVRFX09OX0RFRkFVTFQ7Cj4gICAJcndiLT53
YyA9IHRlc3RfYml0KFFVRVVFX0ZMQUdfV0MsICZxLT5xdWV1ZV9mbGFncyk7Cj4gICAJcndiLT5y
cV9kZXB0aC5kZWZhdWx0X2RlcHRoID0gUldCX0RFRl9ERVBUSDsKPiArCXJ3Yi0+cnFfZGVwdGgu
cXVldWVfZGVwdGggPSBibGtfcXVldWVfZGVwdGgocSk7Cj4gICAJcndiLT5taW5fbGF0X25zZWMg
PSB3YnRfZGVmYXVsdF9sYXRlbmN5X25zZWMocSk7Cj4gLQo+IC0Jd2J0X3F1ZXVlX2RlcHRoX2No
YW5nZWQoJnJ3Yi0+cnFvcyk7Cj4gKwl3YnRfdXBkYXRlX2xpbWl0cyhyd2IpOwo+ICAgCj4gICAJ
LyoKPiAgIAkgKiBBc3NpZ24gcndiIGFuZCBhZGQgdGhlIHN0YXRzIGNhbGxiYWNrLgpSZXZpZXdl
ZC1ieTogSGFubmVzIFJlaW5lY2tlIDxoYXJlLWwzQTVCazd3YUdNQHB1YmxpYy5nbWFuZS5vcmc+
CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRyLiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAg
S2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0CmhhcmUtbDNBNUJrN3dhR01AcHVibGljLmdtYW5lLm9y
ZyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMgNjg4ClNVU0UgU29m
dHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZwpIUkIg
MzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYsIEFuZHJl
dwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2VybWFuCgo=
