From: "Linux regression tracking (Thorsten Leemhuis)" 
        <regressions-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>
Subject: Re: [PATCH -next v2 0/6] blk-wbt: minor fix and cleanup
Date: Mon, 22 May 2023 14:00:51 +0200
Message-ID: <5d53e634-33c2-e040-3c34-6c36e32eed81@leemhuis.info>
References: <20230512093554.911753-1-yukuai1@huaweicloud.com>
 <2b18e6ed-bce0-44f5-5ec4-8903f3c85cfe@kernel.dk>
Reply-To: Linux regressions mailing list <regressions-cunTk1MwBs/YUNznpcFYbw@public.gmane.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US, de-DE
In-Reply-To: <2b18e6ed-bce0-44f5-5ec4-8903f3c85cfe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, hch-jcswGhMUV9g@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: lukas.bulwahn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 12.05.23 16:58, Jens Axboe wrote:
> On 5/12/23 3:35=E2=80=AFAM, Yu Kuai wrote:
>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>
>> Changes in v2:
>>  - make the code more readable for patch 1
>>  - add a new attr_group that is only visible for rq based device
>>  - explain in detail for patch 4
>>  - add review tag for patch 2,3,5
>>
>> Yu Kuai (6):
>>   blk-wbt: fix that wbt can't be disabled by default
>>   blk-wbt: don't create wbt sysfs entry if CONFIG_BLK_WBT is disabled
>>   blk-wbt: remove dead code to handle wbt enable/disable with io
>>     inflight
>>   blk-wbt: cleanup rwb_enabled() and wbt_disabled()
>>   blk-iocost: move wbt_enable/disable_default() out of spinlock
>>   blk-sysfs: add a new attr_group for blk_mq
>>
>>  block/blk-iocost.c |   7 +-
>>  block/blk-sysfs.c  | 181 ++++++++++++++++++++++++++-------------------
>>  block/blk-wbt.c    |  33 +++------
>>  block/blk-wbt.h    |  19 -----
>>  4 files changed, 117 insertions(+), 123 deletions(-)
>=20
> We need a 6.4 version of the fix to get rid of the regression. If you
> want to do cleanups on top of that, then that's fine and that can go into
> 6.5. But don't mix them up.

Hmm, it seems nothing has happened here since ten days to fix this
regression that likely is still present in 6.3. Yu Kuai, did it fall
through the cracks, or is what Jens asked for more complicated than it
sounds?

Or was progress made and I just missed it?

Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
