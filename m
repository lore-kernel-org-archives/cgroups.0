From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v7 9/9] blk-throttle: clean up flag 'THROTL_TG_PENDING'
Date: Thu, 18 Aug 2022 17:29:39 +0800
Message-ID: <841b7b5a-b908-649a-c09d-32c8de5f1c14@huaweicloud.com>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-10-yukuai1@huaweicloud.com>
 <Yvv6kk/RD5LT+3dk@slm.duckdns.org>
 <65d93ec6-2465-35f1-314f-f092ce631100@huaweicloud.com>
 <Yv0rR9gBL0qbYeXp@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Yv0rR9gBL0qbYeXp@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Tejun!

=D4=DA 2022/08/18 1:54, Tejun Heo =D0=B4=B5=C0:
> Hello,
>=20
> On Wed, Aug 17, 2022 at 09:45:13AM +0800, Yu Kuai wrote:
>>> I don't know whether this is better or not. It's minutely less lines of=
 code
>>> but also makes the code a bit more fragile. I'm ambivalent. At any rate,
>>> please move these trivial patches to the head of the series or post them
>>> separately.
>>
>> Can I ask why do you think this patch makes the code a bit more fragile?
>=20
> It's just one step further removed. Before, the flag was trivially in sync
> with the on queue status. After, the relationship is more indirect and
> easier to break accidentally. Not that it's a major problem. Just not sure
> what the benefit of the change is.

If you are worried about that, I can keep the flag, then the last two
patches will cleanup:

Before, the flag will be set and cleared frequently when each each bio
is handled.

After, the flag will only set then the first bio is throttled, and
it's cleared when last bio is dispatched.

Of course, if you think this cleanup is not necessary, I'll drop the
last two patches.

Thanks,
Kuai
>=20
>> By the way, I'll post these trivial patches separately.
>=20
> Sounds great.
>=20
> Thanks.
>=20

