From: Jens Axboe <axboe@fb.com>
Subject: Re: [PATCH] blkcg: clean up blkg_tryget_closest()
Date: Thu, 20 Dec 2018 17:07:59 +0000
Message-ID: <149cd7b6-a330-2197-6792-b8f0235f02de@fb.com>
References: <20181219224321.32624-1-dennis@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MoSum3lXlafz/ri1eI4VoM0zzraxjJ267tMMn2oqN44=;
 b=qNJBxqORZyrU8qZMjbGx3CrqiTJQLPz1KtqWD8MVDHgjXARX/816/T2GnyRbm+XTleLt
 tYUlehcBOahbABmgJDJ6dG90NKArQZu3a6+/KQ02dBVk/7H2sx4/p7/LImZUTFhFYVHd
 j2BBFUuVNXVxxGuv9wRTj8BtL/DeGU9B7qs= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MoSum3lXlafz/ri1eI4VoM0zzraxjJ267tMMn2oqN44=;
 b=W5TOgPl1y4srW7H5pLtEqYVFjH/fgRo4ZyeiC5Mkm88dFyqXDxyYst7io5mPPZHNsecqBXWDHncHIXXG0wKIn38yEvq4bedKJGCHD+piN4MDl49w5jLXn/epk8ZqODwm9EOQheXIYOX02u2Cip7zKGGFn59aClu1ik4P/72wwIQ=
In-Reply-To: <20181219224321.32624-1-dennis@kernel.org>
Content-Language: en-US
Content-ID: <6DA903CE69BE754E81BDE655E83BCC41@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dennis Zhou <dennis@kernel.org>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>
Cc: Kernel Team <Kernel-team@fb.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

T24gMTIvMTkvMTggMzo0MyBQTSwgRGVubmlzIFpob3Ugd3JvdGU6DQo+IFRoZSBpbXBsZW1lbnRh
dGlvbiBvZiBibGtnX3RyeWdldF9jbG9zZXN0KCkgd2Fzbid0IHN1cGVyIG9idmlvdXMgYW5kDQo+
IGJlY2FtZSBhIHBvaW50IG9mIHN1c3BpY2lvbiB3aGVuIGRlYnVnZ2luZyBbMV0uIFNvIGxldCdz
IGNsZWFuIGl0IHVwIHNvDQo+IGl0J3Mgb2J2aW91c2x5IG5vdCB0aGUgcHJvYmxlbS4NCg0KSSBs
aWtlIHRoZSBjbGVhbnVwIC0gYWRkaW5nIHRvIHRoZSBsYXRlciBwaWxlIGZvciB0aGUgbWVyZ2Ug
d2luZG93LCB0aGFua3MNCkRlbm5pcy4NCg0KLS0gDQpKZW5zIEF4Ym9lDQoNCg==
