From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH -next] blk-throttle: enable io throttle for root in cgroup
 v2
Date: Wed, 9 Feb 2022 09:22:30 +0800
Message-ID: <34ae7d06-4f6b-73f7-7299-65cb8859aad8@huawei.com>
References: <20220114093000.3323470-1-yukuai3@huawei.com>
 <YfGE9L4i7DtNTo08@slm.duckdns.org>
 <235b0757-d322-2b6e-3ab6-ecc8c82f8f1e@huawei.com>
 <Yflr4FzUTWsiLTC/@slm.duckdns.org>
 <32b6949d-60b1-82ce-ae44-1cf089a78276@huawei.com>
 <YgK7J8TFyFvp/rv1@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <YgK7J8TFyFvp/rv1@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2022/02/09 2:49, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Tue, Feb 08, 2022 at 09:38:33AM +0800, yukuai (C) wrote:
>> 3) If we limit iops to 8 for each client from server, client should work
>> fine, however, server can receive 64 x 8 =3D 512 io at most at the same
>> time, which might cause too much pressure on the server.(maybe bps is
>> more appropriate to explain the high pressure).
>=20
> I don't follow this part. Why can't the server control however it wanna
> control?

Hi,

Do you agree that the server can't control how many io it can receives
from one client if we limit from server? I think the difference is that
limit from client can control it...

Thanks,
Kuai
>=20
> Thanks.
>=20
