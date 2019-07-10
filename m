From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] blk-throttle: fix zero wait time for iops throttled group
Date: Wed, 10 Jul 2019 13:42:41 +0300
Message-ID: <50aa6400-6128-0344-d7c8-0d73fccff350@yandex-team.ru>
References: <156259979778.2486.6296077059654653057.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1562755362; bh=MuHsnMCLNYQMR7LQcEktY+8kMNp1AKabcUeHAMKR+Lw=;
        h=In-Reply-To:Message-ID:Date:References:To:From:Subject:Cc;
        b=BGZjj8D8y+oFQMhHbtp28s9y8KPUGvHMIb/s6H6Ut3D7K4rDQ3yblRq9KWrkzEY8w
         NYDruSUJfsGJ6x8IyfFvwIrbt+Ymq5XA375GgGcf1DVrVrry/OlFf2RQo2zy37kyRf
         OcDTCr5S3/TY58oAHlb6vbZaxkdzoMP8DCWQCL2U=
In-Reply-To: <156259979778.2486.6296077059654653057.stgit@buzz>
Content-Language: en-CA
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: Liu Bo <bo.liu@linux.alibaba.com>, Stable <stable@vger.kernel.org>, cgroups@vger.kernel.org

On 08.07.2019 18:29, Konstantin Khlebnikov wrote:
> After commit 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops
> limit is enforced") wait time could be zero even if group is throttled and
> cannot issue requests right now. As a result throtl_select_dispatch() turns
> into busy-loop under irq-safe queue spinlock.

To be clear: this almost instantly kills entire machine - other cpus stuck at sending ipi.

> 
> Fix is simple: always round up target time to the next throttle slice.
> 
> Fixes: 991f61fe7e1d ("Blk-throttle: reduce tail io latency when iops limit is enforced")
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: stable@vger.kernel.org # v4.19+
> ---
>   block/blk-throttle.c |    9 +++------
>   1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 9ea7c0ecad10..8ab6c8153223 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -881,13 +881,10 @@ static bool tg_with_in_iops_limit(struct throtl_grp *tg, struct bio *bio,
>   	unsigned long jiffy_elapsed, jiffy_wait, jiffy_elapsed_rnd;
>   	u64 tmp;
>   
> -	jiffy_elapsed = jiffy_elapsed_rnd = jiffies - tg->slice_start[rw];
> -
> -	/* Slice has just started. Consider one slice interval */
> -	if (!jiffy_elapsed)
> -		jiffy_elapsed_rnd = tg->td->throtl_slice;
> +	jiffy_elapsed = jiffies - tg->slice_start[rw];
>   
> -	jiffy_elapsed_rnd = roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
> +	/* Round up to the next throttle slice, wait time must be nonzero */
> +	jiffy_elapsed_rnd = roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
>   
>   	/*
>   	 * jiffy_elapsed_rnd should not be a big value as minimum iops can be
> 
