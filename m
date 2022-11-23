From: Kemeng Shi <shikemeng@huawei.com>
Subject: Re: [PATCH v2 0/5] A few cleanup and bugfix patches for blk-iocost
Date: Wed, 23 Nov 2022 14:09:14 +0800
Message-ID: <5ae7f0a0-8540-bbfe-2fe7-b18fc071ae1c@huawei.com>
References: <20221018121932.10792-1-shikemeng@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20221018121932.10792-1-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

Friendly ping

on 10/18/2022 8:19 PM, Kemeng Shi wrote:
> This series contain a few patch to correct comment, correct trace of
> vtime_rate and so on. More detail can be found in the respective
> changelogs.
> 
> ---
> v2:
>  Thanks Tejun for review and comment!
>  Add Acked-by tag from Tejun.
>  Correct description in patch 3/5 and 4/5.
>  Drop "blk-iocost: Avoid to call current_hweight_max if iocg->inuse
> == iocg->active"
>  Drop "blk-iocost: Remove redundant initialization of struct ioc_gq"
>  Drop "blk-iocost: Get ioc_now inside weight_updated"
> ---
> 
> Kemeng Shi (5):
>   blk-iocost: Fix typo in comment
>   blk-iocost: Reset vtime_base_rate in ioc_refresh_params
>   blk-iocost: Trace vtime_base_rate instead of vtime_rate
>   blk-iocost: Remove vrate member in struct ioc_now
>   blk-iocost: Correct comment in blk_iocost_init
> 
>  block/blk-iocost.c            | 16 +++++++++-------
>  include/trace/events/iocost.h |  4 ++--
>  2 files changed, 11 insertions(+), 9 deletions(-)
> 

-- 
Best wishes
Kemeng Shi
