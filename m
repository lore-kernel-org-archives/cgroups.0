From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 4/9] blk-throttle: fix io hung due to configuration
 updates
Date: Tue, 16 Aug 2022 10:01:17 -1000
Message-ID: <Yvv3jcycOguuEbA3@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-5-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=K42L4KCO1sgIeNmpAei/7oCMFvHrjQlmlJv8IWh4Cio=;
        b=XTE98oivpUy8raqPHCxrdCxnNP92kcl56buMLJhnV1Nzdxws1MCR/I0ho+oW0z8GqA
         3NLg1YsoiNJWUtZzWkHwXppSRC1bGxvkr0y+8eVo6cEfdSKiBqpQQui9wODshUtzOLDC
         LfD8/zt3wYE746uwdiBXb5gDneEPVmFOUV7udMFPYWSelcypZePSVEJOAseLQ3i0xn+q
         zVe5xhkvCOVnx5U3OFkXqsqZ0DWc6DjTaY5C1+ylvXVfRbw22nQ4TvccawVCJCCsVdvr
         DaFwcmBqIF/Pv/sJI21eIHasrbFfICrgQ/jppdYxMXTZevcn2aJQa2QR3ASqtXP5t4JE
         TMfA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220802140415.2960284-5-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Tue, Aug 02, 2022 at 10:04:10PM +0800, Yu Kuai wrote:
...
> +static void __tg_update_skipped(struct throtl_grp *tg, bool rw)
> +{
> +	unsigned long jiffy_elapsed = jiffies - tg->slice_start[rw];
> +	u64 bps_limit = tg_bps_limit(tg, rw);
> +	u32 iops_limit = tg_iops_limit(tg, rw);
> +
> +	/*
> +	 * If config is updated while bios are still throttled, calculate and
> +	 * accumulate how many bytes/io are waited across changes. And
> +	 * bytes/io_skipped will be used to calculate new wait time under new
> +	 * configuration.
> +	 *
> +	 * Following calculation won't overflow as long as bios that are
> +	 * dispatched later won't preempt already throttled bios. Even if such
> +	 * overflow do happen, there should be no problem because unsigned is
> +	 * used here, and bytes_skipped/io_skipped will be updated correctly.
> +	 */

Would it be easier if the fields were signed? It's fragile and odd to
explain "these are unsigned but if they underflow they behave just like
signed when added" when they can just be signed. Also, I have a hard time
understand what "preempt" means above.

> +	if (bps_limit != U64_MAX)
> +		tg->bytes_skipped[rw] +=
> +			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
> +			tg->bytes_disp[rw];
> +	if (iops_limit != UINT_MAX)
> +		tg->io_skipped[rw] +=
> +			calculate_io_allowed(iops_limit, jiffy_elapsed) -
> +			tg->io_disp[rw];

So, this is calculating the budgets to carry over. Can we name them
accordingly? I don't know what "skipped" means.

> @@ -115,6 +115,17 @@ struct throtl_grp {
>  	uint64_t bytes_disp[2];
>  	/* Number of bio's dispatched in current slice */
>  	unsigned int io_disp[2];
> +	/*
> +	 * The following two fields are updated when new configuration is
> +	 * submitted while some bios are still throttled, they record how many
> +	 * bytes/io are waited already in previous configuration, and they will
> +	 * be used to calculate wait time under new configuration.
> +	 *
> +	 * Number of bytes will be skipped in current slice
> +	 */
> +	uint64_t bytes_skipped[2];
> +	/* Number of bio will be skipped in current slice */
> +	unsigned int io_skipped[2];

So, the code seems to make sense but the field names and comments don't
really, at least to me. I can't find an intuitive understanding of what's
being skipped. Can you please take another stab at making this more
understandable?

Thanks.

-- 
tejun
