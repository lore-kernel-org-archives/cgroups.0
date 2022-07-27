From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RESEND v6 4/8] blk-throttle: fix io hung due to config
 updates
Date: Wed, 27 Jul 2022 08:39:19 -1000
Message-ID: <YuGGVxdlOVk/eF2l@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=Ue/qng0G6/T7z25ofGVIpnj/GBz8+9KlthmZo7Y7nzA=;
        b=lVjgOWA3Yt4/zF583HvCtBgZmEUdV7jQ8kpUvthCo7bGHXr+5QzLvWBhq3vezRTzxP
         hmvEZlHshegK9r0H8gAnvU1NsNkHldzSXvPTOIxB26eK/pdbzXDWFOW16prZVrDQc8XL
         Oxz4Dd0r3vlqcyIpIOBv4ui19CHW8Hg5J2K+B291qp/KjvXSehj7yJQyAdVgfF5yV3pE
         grV7L/3XK1giJ7hK/HuymByfPovtngc1rLvxC2tyghK3y0eTt19URLbpzOOkPbCA6IIJ
         nOUUPL9ibblope8STVvu7gfCY5dmL20SOO3heSGj/3TV60qDwDG/7UAKF+/Ei5OiOR1b
         5EXA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220701093441.885741-5-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

Hello,

On Fri, Jul 01, 2022 at 05:34:37PM +0800, Yu Kuai wrote:
> +static void __tg_update_skipped(struct throtl_grp *tg, bool rw)
> +{
> +	unsigned long jiffy_elapsed = jiffies - tg->slice_start[rw];
> +	u64 bps_limit = tg_bps_limit(tg, rw);
> +	u32 iops_limit = tg_iops_limit(tg, rw);
> +
> +	/*
> +	 * Following calculation won't overflow as long as bios that are
> +	 * dispatched later won't preempt already throttled bios. Even if such
> +	 * overflow do happen, there should be no problem because we are using
> +	 * unsigned here, and bytes_skipped/io_skipped will be updated
> +	 * correctly.
> +	 */
> +	if (bps_limit != U64_MAX)
> +		tg->bytes_skipped[rw] +=
> +			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
> +			tg->bytes_disp[rw];
> +	if (iops_limit != UINT_MAX)
> +		tg->io_skipped[rw] +=
> +			calculate_io_allowed(iops_limit, jiffy_elapsed) -
> +			tg->io_disp[rw];

I'm not quiet sure this is correct. What if the limit keeps changing across
different values? Then we'd be calculating the skipped amount based on the
last configuration only which would be incorrect.

It's probably more straight-forward if the code keeps track of the total
budget allowed in the period somewhere and keeps adding to it whenever it
wanna calculates the current budget - sth like:

  tg->bytes_budget[rw] += calculate_bytes_allowed(limit, jiffies - tg->last_budget_at);
  tg->last_budget_at = jiffies;

then, you'd always know the correct budget.

> +}
> +
> +static void tg_update_skipped(struct throtl_grp *tg)
> +{
> +	if (tg->service_queue.nr_queued[READ])
> +		__tg_update_skipped(tg, READ);
> +	if (tg->service_queue.nr_queued[WRITE])
> +		__tg_update_skipped(tg, WRITE);
> +
> +	throtl_log(&tg->service_queue, "%s: %llu %llu %u %u\n", __func__,
> +		   tg->bytes_skipped[READ], tg->bytes_skipped[WRITE],
> +		   tg->io_skipped[READ], tg->io_skipped[WRITE]);
> +}

Also, please add a comment explaining what this is all about. What is the
code trying to achieve, why and how?

Thanks.

-- 
tejun
