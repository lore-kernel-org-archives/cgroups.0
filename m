From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/15] blk-rq-qos: make rq_qos_add and rq_qos_del more
 useful
Date: Fri, 27 Jan 2023 08:08:16 +0100
Message-ID: <f9e03e4f-d23c-0986-1869-b12b590f2626@suse.de>
References: <20230117081257.3089859-1-hch@lst.de>
 <20230117081257.3089859-10-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1674803297; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ExcPerhX7tYt3BlJ7meGQRxIOmEdq2FNRdX7onGlasQ=;
        b=hVYgMFrYuFnahY6OG0m3NPFOehRTPOkMZOS40S2W8hYGL/L0lLqsaqiEM3vD52CKvm5moc
        Lz764CW+k9U3JHUtC1Zbdr8oL87n2fzQW/8P4UzKhD+Ce/Ai2UCpDRWOPZ7gU0NaamL5zz
        jSKoGbe50mOU8wO35Z8vO4PToqPrQHI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1674803297;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ExcPerhX7tYt3BlJ7meGQRxIOmEdq2FNRdX7onGlasQ=;
        b=I9aPHEwGleLbRif0MGahEZsDhN32CUZONiWbpWYd3cbssF5+il2caQ96RKfaRhA0A9XsPa
        GVNRsJ6EKOtlcfCw==
Content-Language: en-US
In-Reply-To: <20230117081257.3089859-10-hch@lst.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="euc-kr"; format="flowed"
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org

T24gMS8xNy8yMyAwOToxMiwgQ2hyaXN0b3BoIEhlbGx3aWcgd3JvdGU6Cj4gU3dpdGNoIHRvIHBh
c3NpbmcgYSBnZW5kaXNrLCBhbmQgbWFrZSBycV9xb3NfYWRkIGluaXRpYWxpemUgYWxsIHJlcXVp
cmVkCj4gZmllbGRzIGFuZCBkcm9wIHRoZSBub3QgcmVxdWlyZWQgcSBhcmd1bWVudCBmcm9tIHJx
X3Fvc19kZWwuICBBbHNvIG1vdmUKPiB0aGUgY29kZSBvdXQgb2YgbGluZSBnaXZlbiBob3cgbGFy
Z2UgaXQgaXMuCj4gCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3Qu
ZGU+Cj4gLS0tCj4gICBibG9jay9ibGstaW9jb3N0LmMgICAgfCAxMyArKy0tLS0tLS0KPiAgIGJs
b2NrL2Jsay1pb2xhdGVuY3kuYyB8IDE0ICsrKy0tLS0tLQo+ICAgYmxvY2svYmxrLXJxLXFvcy5j
ICAgIHwgNjcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwo+ICAg
YmxvY2svYmxrLXJxLXFvcy5oICAgIHwgNjIgKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tCj4gICBibG9jay9ibGstd2J0LmMgICAgICAgfCAgNSArLS0tCj4gICA1IGZpbGVz
IGNoYW5nZWQsIDc4IGluc2VydGlvbnMoKyksIDgzIGRlbGV0aW9ucygtKQo+IApSZXZpZXdlZC1i
eTogSGFubmVzIFJlaW5lY2tlIDxoYXJlQHN1c2UuZGU+CgpDaGVlcnMsCgpIYW5uZXMKLS0gCkRy
LiBIYW5uZXMgUmVpbmVja2UgICAgICAgICAgICAgICAgS2VybmVsIFN0b3JhZ2UgQXJjaGl0ZWN0
CmhhcmVAc3VzZS5kZSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICs0OSA5MTEgNzQwNTMg
Njg4ClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdtYkgsIE1heGZlbGRzdHIuIDUsIDkwNDA5IE7D
vHJuYmVyZwpIUkIgMzY4MDkgKEFHIE7DvHJuYmVyZyksIEdlc2Now6RmdHNmw7xocmVyOiBJdm8g
VG90ZXYsIEFuZHJldwpNeWVycywgQW5kcmV3IE1jRG9uYWxkLCBNYXJ0amUgQm91ZGllbiBNb2Vy
bWFuCgo=
