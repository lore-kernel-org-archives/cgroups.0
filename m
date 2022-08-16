From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 1/9] blk-throttle: fix that io throttle can only work
 for single bio
Date: Tue, 16 Aug 2022 09:37:31 -1000
Message-ID: <Yvvx+/d2+OMROUOe@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=l9EfUPaDR5fFqr7tvdGkZgxoolNNscld0M245NvUy6E=;
        b=nLp/aBgVt6VuoaORbTZKRwiuvBImcBAxXyGu2K+SxaOMk8qEYRA8xkNY3sj70X1RDT
         zeOOFAq4s20bplLlj+c1ruWj+YW3QsXioDyQ7USvt9SV7SSnIZY32mS7JY5J4qkkoujz
         MK5NVG81SXWZT8hbQ35Z58bLNbv6+zJujodwgSHgIqQ2rJ3uo23d2MFALWygo2WeoKPD
         kT1vzc3g9I3YfET7baxKhGGlpekI8gPTtfNNSRlBcxLjzXiYRHJ4COGSQNlMoovNZIzT
         lGKCU3ZLSBmTCfZPyMy+iofWEtJAxg1cMeU1QUcGbGComtJTA3/fWvaAh2aSPgeiLkbE
         NlIg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220802140415.2960284-2-yukuai1@huaweicloud.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mkoutny@suse.com, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com

On Tue, Aug 02, 2022 at 10:04:07PM +0800, Yu Kuai wrote:
...
> commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
> support to count splited bios for iops limit, thus it adds flaged bio
                                                             ^
                                                             flagged

> checking in tg_with_in_bps_limit() so that splited bios will only count
                                             ^
                                             split

> once for bps limit, however, it introduce a new problem that io throttle
> won't work if multiple bios are throttled.
> 
> In order to fix the problem, at first, don't skip flaged bio in
> tg_with_in_bps_limit(), however, this will break that splited bios should
> only count once for bps limit. And this patch tries to avoid
> over-accounting by decrementing it first in __blk_throtl_bio(), and
> then counting it again while dispatching it.
> 
> Fixes: 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Reviewed-by: Ming Lei <ming.lei@redhat.com>

Please cc stable w/ version tag.

> ---
>  block/blk-throttle.c | 26 ++++++++++++++++++++------
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 9f5fe62afff9..2957e2c643f4 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -811,7 +811,7 @@ static bool tg_with_in_bps_limit(struct throtl_grp *tg, struct bio *bio,
>  	unsigned int bio_size = throtl_bio_data_size(bio);
>  
>  	/* no need to throttle if this bio's bytes have been accounted */
> -	if (bps_limit == U64_MAX || bio_flagged(bio, BIO_THROTTLED)) {
> +	if (bps_limit == U64_MAX) {
>  		if (wait)
>  			*wait = 0;
>  		return true;
> @@ -921,11 +921,8 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
>  	unsigned int bio_size = throtl_bio_data_size(bio);
>  
>  	/* Charge the bio to the group */
> -	if (!bio_flagged(bio, BIO_THROTTLED)) {
> -		tg->bytes_disp[rw] += bio_size;
> -		tg->last_bytes_disp[rw] += bio_size;
> -	}
> -
> +	tg->bytes_disp[rw] += bio_size;
> +	tg->last_bytes_disp[rw] += bio_size;
>  	tg->io_disp[rw]++;
>  	tg->last_io_disp[rw]++;
>  
> @@ -2121,6 +2118,23 @@ bool __blk_throtl_bio(struct bio *bio)
>  			tg->last_low_overflow_time[rw] = jiffies;
>  		throtl_downgrade_check(tg);
>  		throtl_upgrade_check(tg);
> +
> +		/*
> +		 * Splited bios can be re-entered because iops limit should be
                   ^                ^^^^^^^^^^^^^
                   Split            re-enter

> +		 * counted again, however, bps limit should not. Since bps limit
> +		 * will be counted again while dispatching it, compensate the
> +		 * over-accounting here. Noted that compensation can fail if
> +		 * new slice is started.

I can't really follow the comment. Please improve the explanation.

> +		 */
> +		if (bio_flagged(bio, BIO_THROTTLED)) {
> +			unsigned int bio_size = throtl_bio_data_size(bio);
> +
> +			if (tg->bytes_disp[rw] >= bio_size)
> +				tg->bytes_disp[rw] -= bio_size;
> +			if (tg->last_bytes_disp[rw] >= bio_size)
> +				tg->last_bytes_disp[rw] -= bio_size;
> +		}

So, as a fix for the immediate problem, I guess this might do but this feels
really fragile. How can we be certain that re-entering only happens because
of splitting? What if future core development changes that? It seems to be
solving the problem in the wrong place. Shouldn't we flag the bio indicating
that it's split when we're splitting the bio so that we only limit them for
iops in the first place?

Thanks.

-- 
tejun
