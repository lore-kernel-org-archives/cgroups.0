From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v9 0/4] blk-throttle bugfix
Date: Wed, 31 Aug 2022 19:31:58 +0800
Message-ID: <eb7246b4-2cfe-a110-1e45-39f970e5441e@huaweicloud.com>
References: <20220829022240.3348319-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220829022240.3348319-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hi, Jens!

在 2022/08/29 10:22, Yu Kuai 写道:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Changes in v9:
>   - renaming the flag BIO_THROTTLED to BIO_BPS_THROTTLED, and always
>   apply iops limit in path 1;
>   - add tag for patch 4
> Changes in v8:
>   - use a new solution in patch 1
>   - move cleanups to a separate patchset
>   - rename bytes/io_skipped to carryover_bytes/ios in patch 4
> Changes in v7:
>   - add patch 5 to improve handling of re-entered bio for bps limit
>   - as suggested by Tejun, add some comments
>   - sdd some Acked tag by Tejun
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
> 
> Patch 1 fix that blk-throttle can't work if multiple bios are throttle.
> Patch 2 fix overflow while calculating wait time.
> Patch 3,4 fix io hung due to configuration updates.
> 
> Previous version:
> v1: https://lore.kernel.org/all/20220517134909.2910251-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v2: https://lore.kernel.org/all/20220518072751.1188163-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v3: https://lore.kernel.org/all/20220519085811.879097-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v4: https://lore.kernel.org/all/20220523082633.2324980-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v5: https://lore.kernel.org/all/20220528064330.3471000-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org/
> v6: https://lore.kernel.org/all/20220701093441.885741-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org/
> v7: https://lore.kernel.org/all/20220802140415.2960284-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org/
> v8: https://lore.kernel.org/all/20220823033130.874230-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org/
> 
> Yu Kuai (4):
>    blk-throttle: fix that io throttle can only work for single bio
>    blk-throttle: prevent overflow while calculating wait time
>    blk-throttle: factor out code to calculate ios/bytes_allowed
>    blk-throttle: fix io hung due to configuration updates

Can you apply this patchset now?

Thanks,
Kuai
> 
>   block/bio.c               |   2 -
>   block/blk-throttle.c      | 137 +++++++++++++++++++++++++-------------
>   block/blk-throttle.h      |  11 ++-
>   include/linux/bio.h       |   2 +-
>   include/linux/blk_types.h |   2 +-
>   5 files changed, 104 insertions(+), 50 deletions(-)
> 

