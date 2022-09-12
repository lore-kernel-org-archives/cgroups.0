From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH v2 0/3] blk-throttle cleanups
Date: Mon, 12 Sep 2022 14:15:07 +0800
Message-ID: <7b149545-7a4e-8379-19b6-181d415780fd@huaweicloud.com>
References: <20220827101637.1775111-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220827101637.1775111-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yu Kuai <yukuai1@huaweicloud.com>, tj@kernel.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, jens

Can you apply this patchset?

Thanks,
Kuai

=D4=DA 2022/08/27 18:16, Yu Kuai =D0=B4=B5=C0:
> From: Yu Kuai <yukuai3@huawei.com>
>=20
> Changes in v2:
>   - add tag
>   - remove patch 4
>=20
> There are no functional changes.
>=20
> Yu Kuai (3):
>    blk-throttle: use 'READ/WRITE' instead of '0/1'
>    blk-throttle: calling throtl_dequeue/enqueue_tg in pairs
>    blk-throttle: cleanup tg_update_disptime()
>=20
>   block/blk-throttle.c | 21 ++++++++++++---------
>   1 file changed, 12 insertions(+), 9 deletions(-)
>=20

