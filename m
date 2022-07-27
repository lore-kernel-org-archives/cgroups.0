From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v6 1/8] blk-throttle: fix that io throttle can
 only work for single bio
Date: Wed, 27 Jul 2022 08:27:24 -1000
Message-ID: <YuGDjFkxDSsVrcRw@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=epPjtN4wCIaFRIOaZPdFKvlDUTQEZpKeGhh4HLykvnw=;
        b=VdemlUi3yoDyBLRyuRAKSV/EqdNPyL80KIWvp5r0gjhfr2t+20gST0YEokL+zm8RIg
         iUfMskLvEBSnrC+fr0V4fF/4zKbnTbPDECt038Z8tWHKq/vxUIHkR5bBCnKGE1osHK+S
         Jbaqo8cVOqbSDuYjODlyVe+bMQ5WCiwyaNH7bhuTHpFHU00fLlhK/Wn4TYO+foGqIWLw
         D/dONyACF7EvEbyI0QbQyqpan3kQ77LaeKlKAgvwEXxLbEiTIzuNwmWbyzr7zWkGSVFK
         Ssd9IkY/ZDcyuQvTti3OT6Mt+aeOwUyGqoxzmWVWraMzcMBzNkqVEBpi0InPVbwdcCAl
         Fn7Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220701093441.885741-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Sorry about the long delay.

So, the code looks nice but I have a difficult time following the logic.

On Fri, Jul 01, 2022 at 05:34:34PM +0800, Yu Kuai wrote:
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

So, we're charging and controlling whether it has already been throttled or
not.

> @@ -2121,6 +2118,21 @@ bool __blk_throtl_bio(struct bio *bio)
>  			tg->last_low_overflow_time[rw] = jiffies;
>  		throtl_downgrade_check(tg);
>  		throtl_upgrade_check(tg);
> +
> +		/*
> +		 * re-entered bio has accounted bytes already, so try to
> +		 * compensate previous over-accounting. However, if new
> +		 * slice is started, just forget it.
> +		 */
> +		if (bio_flagged(bio, BIO_THROTTLED)) {
> +			unsigned int bio_size = throtl_bio_data_size(bio);
> +
> +			if (tg->bytes_disp[rw] >= bio_size)
> +				tg->bytes_disp[rw] -= bio_size;
> +			if (tg->last_bytes_disp[rw] >= bio_size)
> +				tg->last_bytes_disp[rw] -= bio_size;
> +		}

and trying to restore the overaccounting. However, it's not clear why this
helps with the problem you're describing. The comment should be clearly
spelling out why it's done this way and how this works.

Also, blk_throttl_bio() doesn't call into __blk_throtl_bio() at all if
THROTTLED is set and HAS_IOPS_LIMIT is not, so if there are only bw limits,
we end up accounting these IOs twice?

Thanks.

-- 
tejun
