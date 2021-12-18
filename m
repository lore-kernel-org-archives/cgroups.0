From: "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v5 0/2] cancel all throttled bios in del_gendisk()
Date: Sat, 18 Dec 2021 17:09:03 +0800
Message-ID: <ca8d39fc-48d3-cfd9-3fa4-a329bb37b91b@huawei.com>
References: <20211210083143.3181535-1-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20211210083143.3181535-1-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: tj@kernel.org, mkoutny@suse.com, hch@infradead.org, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

=D4=DA 2021/12/10 16:31, Yu Kuai =D0=B4=B5=C0:
> If del_gendisk() is done when some io are still throttled, such io
> will not be handled until the throttle is done, which is not
> necessary.
>=20
> Changes in v2:
>   - move WARN_ON_ONCE() from throtl_rb_first() to it's caller
>   - merge some patches into one.
>=20
> Changes in v3:
>   - some code optimization in patch 1
>   - hold queue lock to cancel bios in patch 2
>=20
> Changes in v4:
>   - delete rcu_read_lock() and rcu_read_unlock() in patch 2
>=20
> Changes in v5:
>   - add comment about rcu lock
Friendly ping...
>=20
> Yu Kuai (2):
>    blk-throtl: move WARN_ON_ONCE() from throtl_rb_first() to it's caller
>    block: cancel all throttled bios in del_gendisk()
>=20
>   block/blk-throttle.c | 75 ++++++++++++++++++++++++++++++++++++++++++--
>   block/blk-throttle.h |  2 ++
>   block/genhd.c        |  2 ++
>   3 files changed, 76 insertions(+), 3 deletions(-)
>=20
