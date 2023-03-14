From: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Subject: [PATCH] io_uring/sqpoll: Do not set PF_NO_SETAFFINITY on sqpoll threads
Date: Tue, 14 Mar 2023 19:33:32 +0100
Message-ID: <20230314183332.25834-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1678818814; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0qGPjCdAtXC+XqD66XjuAi/v8OGi5D90eB+FdMZqJF4=;
        b=JdhULJXkXMyNdDlyilRH5mWTjuWX8W63xoL7ZQRJJGxCcOiqkiWRdleW8GnbHAm050pPe7
        mCTMJyTgkDYeCfpDOE4fv8w5FYUT+1xIsBateWg6K3b8YfoBgXr2sTO/Clhq+v7NRWWGWV
        8Aq2YbcMiefG9VpKpNOGaRKbfhHXzu8=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: io-uring@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Daniel Dao <dqminh@cloudflare.com>, Waiman Long <longman@redhat.com>

VXNlcnMgbWF5IHNwZWNpZnkgYSBDUFUgd2hlcmUgdGhlIHNxcG9sbCB0aHJlYWQgd291bGQgcnVu
LiBUaGlzIG1heQpjb25mbGljdCB3aXRoIGNwdXNldCBvcGVyYXRpb25zIGJlY2F1c2Ugb2Ygc3Ry
aWN0IFBGX05PX1NFVEFGRklOSVRZCnJlcXVpcmVtZW50LiBUaGF0IGZsYWcgaXMgdW5uZWNlc3Nh
cnkgZm9yIHBvbGxpbmcgImtlcm5lbCIgdGhyZWFkcywgc2VlCnRoZSByZWFzb25pbmcgaW4gY29t
bWl0IDAxZTY4Y2UwOGEzMCAoImlvX3VyaW5nL2lvLXdxOiBzdG9wIHNldHRpbmcKUEZfTk9fU0VU
QUZGSU5JVFkgb24gaW8td3Egd29ya2VycyIpLiBEcm9wIHRoZSBmbGFnIG9uIHBvbGwgdGhyZWFk
cyB0b28uCgpGaXhlczogMDFlNjhjZTA4YTMwICgiaW9fdXJpbmcvaW8td3E6IHN0b3Agc2V0dGlu
ZyBQRl9OT19TRVRBRkZJTklUWSBvbiBpby13cSB3b3JrZXJzIikKTGluazogaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvYWxsLzIwMjMwMzE0MTYyNTU5LnBueXhkbGx6Z3c3am96Z3hAYmxhY2twYWQv
ClNpZ25lZC1vZmYtYnk6IE1pY2hhbCBLb3V0bsO9IDxta291dG55QHN1c2UuY29tPgotLS0KIGlv
X3VyaW5nL3NxcG9sbC5jIHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQoKZGlm
ZiAtLWdpdCBhL2lvX3VyaW5nL3NxcG9sbC5jIGIvaW9fdXJpbmcvc3Fwb2xsLmMKaW5kZXggMDEx
OWQzZjFhNTU2Li45ZGI0YmMxZjUyMWEgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL3NxcG9sbC5jCisr
KyBiL2lvX3VyaW5nL3NxcG9sbC5jCkBAIC0yMzMsNyArMjMzLDYgQEAgc3RhdGljIGludCBpb19z
cV90aHJlYWQodm9pZCAqZGF0YSkKIAkJc2V0X2NwdXNfYWxsb3dlZF9wdHIoY3VycmVudCwgY3B1
bWFza19vZihzcWQtPnNxX2NwdSkpOwogCWVsc2UKIAkJc2V0X2NwdXNfYWxsb3dlZF9wdHIoY3Vy
cmVudCwgY3B1X29ubGluZV9tYXNrKTsKLQljdXJyZW50LT5mbGFncyB8PSBQRl9OT19TRVRBRkZJ
TklUWTsKIAogCW11dGV4X2xvY2soJnNxZC0+bG9jayk7CiAJd2hpbGUgKDEpIHsKLS0gCjIuMzku
MgoK
