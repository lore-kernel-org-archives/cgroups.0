From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] blk-throtl: optimize IOPS throttle for large IO
 scenarios
Date: Thu, 29 Jul 2021 07:11:34 -1000
Message-ID: <YQLhRrkZrmKTzfbP@mtj.duckdns.org>
References: <40915233274d31bb0659ff9f3be8900a5a0e81ba.1627462548.git.brookxu@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vwili5Ap3pl5QTQqz8bc1S7CjPVAgBWQMamZ9XQVdO4=;
        b=iT/gDga4Q09cV3tRMXD5HCdMqu54krFqAdGOn3IVbHrIUuIJKufh/9zsc2S76ZQQXR
         HFcSP8MMW8c2pLGKGrkHNFGTjmT6XcvFk7Ydam8QwwSxmGc2uUAUOBc7vgV94yksLCbm
         5g6jBi3tmExqgi5PtPz1If7SVyGOKnDFb7ShBegl1TRFWjUyJiz187mcVe9FGcEthtWE
         fio7y7AZ+6HJ4Xge03I++TWhDsyCynxfLIvLFd2Mw3Vyq2nR7/NdjdsOFtol/k9QcFP6
         WVWF8GQjsJtJB5gVq+KytIjw5niqWi7/Eh8F6QlDnTawp+qhc9z1hd6TqBvGzKCtUAAr
         1cVw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <40915233274d31bb0659ff9f3be8900a5a0e81ba.1627462548.git.brookxu-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Jul 28, 2021 at 05:01:41PM +0800, brookxu wrote:
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index a11b3b5..86ff943 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -348,6 +348,8 @@ void __blk_queue_split(struct bio **bio, unsigned int *nr_segs)
>  		trace_block_split(split, (*bio)->bi_iter.bi_sector);
>  		submit_bio_noacct(*bio);
>  		*bio = split;
> +
> +		blk_throtl_recharge_bio(*bio);

Can you rename this blk_throtl_charge_bio_split()?

> @@ -524,6 +537,11 @@ static struct blkg_policy_data *throtl_pd_alloc(gfp_t gfp,
>  	tg->idletime_threshold = DFL_IDLE_THRESHOLD;
>  	tg->idletime_threshold_conf = DFL_IDLE_THRESHOLD;
>  
> +	atomic_set(&tg->io_split_cnt[0], 0);
> +	atomic_set(&tg->io_split_cnt[1], 0);
> +	atomic_set(&tg->last_io_split_cnt[0], 0);
> +	atomic_set(&tg->last_io_split_cnt[1], 0);

We likely don't need these. pd's zeroed on allocation.

> @@ -877,10 +900,19 @@ static inline void throtl_trim_slice(struct throtl_grp *tg, bool rw)
>  	else
>  		tg->bytes_disp[rw] = 0;
>  
> -	if (tg->io_disp[rw] >= io_trim)
> +	if (tg_io_disp(tg, rw) >= io_trim) {

Instead of checking this in multiple places, would it be simpler to transfer
the atomic counters to the existing counters whenever we enter blk-throtl
and leave the rest of the code as-is?

Thanks.

-- 
tejun
