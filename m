From: Yu Kuai <yukuai3@huawei.com>
Subject: Re: [PATCH RESEND v6 0/8] bugfix and cleanup for blk-throttle
Date: Sun, 10 Jul 2022 10:39:36 +0800
Message-ID: <a146b8ff-4287-44b7-00b2-74681963ac49@huawei.com>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220701093441.885741-1-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Yu Kuai <yukuai1@huaweicloud.com>, tj@kernel.org, mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

Hi!

=D4=DA 2022/07/01 17:34, Yu Kuai =D0=B4=B5=C0:
> From: Yu Kuai <yukuai3@huawei.com>
>=20
> Resend v5 by a new mail address(huaweicloud.com) because old
> address(huawei.com)has some problem that emails can end up in spam.
> Please let me know if anyone still see this patchset end up in spam.
>=20
> Changes in v6:
>   - rename parameter in patch 3
>   - add comments and reviewed tag for patch 4
> Changes in v5:
>   - add comments in patch 4
>   - clear bytes/io_skipped in throtl_start_new_slice_with_credit() in
>   patch 4
>   - and cleanup patches 5-8
> Changes in v4:
>   - add reviewed-by tag for patch 1
>   - add patch 2,3
>   - use a different way to fix io hung in patch 4
> Changes in v3:
>   - fix a check in patch 1
>   - fix link err in patch 2 on 32-bit platform
>   - handle overflow in patch 2
> Changes in v2:
>   - use a new solution suggested by Ming
>   - change the title of patch 1
>   - add patch 2
>=20
> Patch 1 fix that blk-throttle can't work if multiple bios are throttle,
> Patch 2 fix overflow while calculating wait time
> Patch 3,4 fix io hung due to configuration updates.
> Patch 5-8 are cleanup patches, there are no functional changes, just
> some places that I think can be optimized during code review.

Jens and Michal,

Can you receive this patchset normally(not end up in spam)?

If so, Tejun, can you take a look? This patchset do fix some problems in
blk-throttle.

BTW, Michal and Ming, it'll be great if you can take a look at other
patches as well.

Thansk,
Kuai
>=20
> Previous version:
> v1: https://lore.kernel.org/all/20220517134909.2910251-1-yukuai3@huawei.c=
om/
> v2: https://lore.kernel.org/all/20220518072751.1188163-1-yukuai3@huawei.c=
om/
> v3: https://lore.kernel.org/all/20220519085811.879097-1-yukuai3@huawei.co=
m/
> v4: https://lore.kernel.org/all/20220523082633.2324980-1-yukuai3@huawei.c=
om/
> v5: https://lore.kernel.org/all/20220528064330.3471000-1-yukuai3@huawei.c=
om/
>=20
> Yu Kuai (8):
>    blk-throttle: fix that io throttle can only work for single bio
>    blk-throttle: prevent overflow while calculating wait time
>    blk-throttle: factor out code to calculate ios/bytes_allowed
>    blk-throttle: fix io hung due to config updates
>    blk-throttle: use 'READ/WRITE' instead of '0/1'
>    blk-throttle: calling throtl_dequeue/enqueue_tg in pairs
>    blk-throttle: cleanup tg_update_disptime()
>    blk-throttle: clean up flag 'THROTL_TG_PENDING'
>=20
>   block/blk-throttle.c | 168 +++++++++++++++++++++++++++++--------------
>   block/blk-throttle.h |  16 +++--
>   2 files changed, 128 insertions(+), 56 deletions(-)
>=20
