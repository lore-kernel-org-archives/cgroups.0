From: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH v2 00/10] A few bugfix and cleancode patch for bfq
Date: Tue, 27 Dec 2022 15:26:35 +0800
Message-ID: <9bd43295-95f1-f3e0-8703-3cf4d0e46dbd@huaweicloud.com>
References: <20221216111230.3638832-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221216111230.3638832-1-shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Friendly ping...

on 12/16/2022 7:12 PM, Kemeng Shi wrote:
> Hi, this series contain two patches to fix bug in request injection
> mechanism and some random cleancode patches.
> Thanks!
> 
> ---
> v2:
>  -improve git log.
> ---
> 
> Kemeng Shi (10):
>   block, bfq: correctly raise inject limit in
>     bfq_choose_bfqq_for_injection
>   block, bfq: remove unsed parameter reason in bfq_bfqq_is_slow
>   block, bfq: initialize bfqq->decrease_time_jif correctly
>   block, bfq: use helper macro RQ_BFQQ to get bfqq of request
>   block, bfq: remove unnecessary dereference to get async_bfqq
>   block, bfq: remove redundant bfqd->rq_in_driver > 0 check in
>     bfq_add_request
>   block, bfq: remove redundant check in bfq_put_cooperator
>   block, bfq: remove unnecessary goto tag in bfq_dispatch_rq_from_bfqq
>   block, bfq: remove unused bfq_wr_max_time in struct bfq_data
>   block, bfq: remove check of bfq_wr_max_softrt_rate which is always
>     greater than 0
> 
>  block/bfq-iosched.c | 49 +++++++++++++++++----------------------------
>  block/bfq-iosched.h |  2 --
>  2 files changed, 18 insertions(+), 33 deletions(-)
> 

-- 
Best wishes
Kemeng Shi

