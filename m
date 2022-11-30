From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 05/10] blk-throttle: simpfy low limit reached check in
 throtl_tg_can_upgrade
Date: Wed, 30 Nov 2022 12:09:27 -1000
Message-ID: <Y4fUl4TqytaVr+AO@slm.duckdns.org>
References: <20221129030147.27400-1-shikemeng@huawei.com>
 <20221129030147.27400-6-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qxW+Li1mM9gHdSWlfqtls8nKzLIjof0cqidN7UoYqU0=;
        b=NWc6uop42OgKejMGQT3EspBEhZcXTQ7FK2Noq6/8b7yTj8CkSfYcgDd9JLohuT3TXU
         CufaXDg3re4A0xGQl3j4VQnEnl6wZwSfRCiit5a9CNBZAeAqDiPBf+oXkoyI8Jhg5iUW
         QD9L+FQp4OQpqJne8x1P2I0qJKqHIWnnioLvfWA2v+q+lAp4Fu0Z4uQYJbSAvzbtOTNS
         K6NLHWSQ2NdM6w8ZtL+eFG8vfDWE0gpgEyb3pZoa5mS2tFNPFExyD9qjLXY2tLeU613y
         84oat5moY8gtj6B1UwqUN1618Z78Fp5nG7AAFQsWXYOT61cIjFdWdDfcxUtfmn1Q9tR2
         mChA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221129030147.27400-6-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 29, 2022 at 11:01:42AM +0800, Kemeng Shi wrote:
> Commit c79892c557616 ("blk-throttle: add upgrade logic for LIMIT_LOW
> state") added upgrade logic for low limit and methioned that
> 1. "To determine if a cgroup exceeds its limitation, we check if the cgroup
> has pending request. Since cgroup is throttled according to the limit,
> pending request means the cgroup reaches the limit."
> 2. "If a cgroup has limit set for both read and write, we consider the
> combination of them for upgrade. The reason is read IO and write IO can
> interfere with each other. If we do the upgrade based in one direction IO,
> the other direction IO could be severly harmed."
> Besides, we also determine that cgroup reaches low limit if low limit is 0,
> see comment in throtl_tg_can_upgrade.
> 
> Collect the information above, the desgin of upgrade check is as following:
> 1.The low limit is reached if limit is zero or io is already queued.
> 2.Cgroup will pass upgrade check if low limits of READ and WRITE are both
> reached.
> 
> Simpfy the check code described above to removce repeat check and improve
> readability. There is no functional change.
> 
> Detail equivalence proof is as following:
> All replaced conditions to return true are as following:
> condition 1
> (!read_limit && !write_limit)
> condition 2
> read_limit && sq->nr_queued[READ] && (!write_limit || sq->nr_queued[WRITE])
> condition 3
> write_limit && sq->nr_queued[WRITE] && (!read_limit || sq->nr_queued[READ])
> 
> Transferring condition 2 as following:
> read_limit && sq->nr_queued[READ] && (!write_limit || sq->nr_queued[WRITE])
> is equivalent to
> (read_limit && sq->nr_queued[READ]) &&
> (!write_limit || (write_limit && sq->nr_queued[WRITE]))
> is equivalent to
> condition 2.1
> (read_limit && sq->nr_queued[READ] && !write_limit) ||
> condition 2.2
> (read_limit && sq->nr_queued[READ] &&
> (write_limit && sq->nr_queued[WRITE]))
> 
> Transferring condition 3 as following:
> write_limit && sq->nr_queued[WRITE] && (!read_limit || sq->nr_queued[READ])
> is equivalent to
> (write_limit && sq->nr_queued[WRITE]) &&
> (!read_limit || (read_limit && sq->nr_queued[READ]))
> is equivalent to
> condition 3.1
> ((write_limit && sq->nr_queued[WRITE]) && !read_limit) ||
> condition 3.2
> ((write_limit && sq->nr_queued[WRITE]) &&
> (read_limit && sq->nr_queued[READ]))
> 
> Condition 3.2 is the same as condition 2.2, so all conditions we get to
> return are as following:
> (!read_limit && !write_limit) (1)
> (!read_limit && (write_limit && sq->nr_queued[WRITE])) (3.1)
> ((read_limit && sq->nr_queued[READ]) && !write_limit) (2.1)
> ((write_limit && sq->nr_queued[WRITE]) &&
> (read_limit && sq->nr_queued[READ])) (2.2)
> 
> As we can extract conditions "(a1 || a2) && (b1 || b2)" to:
> a1 && b1
> a1 && b2
> a2 && b1
> ab && b2
> 
> Considering that:
> a1 = !read_limit
> a2 = read_limit && sq->nr_queued[READ]
> b1 = !write_limit
> b2 = write_limit && sq->nr_queued[WRITE]
> 
> We can pack replaced conditions to
> (!read_limint || (read_limit && sq->nr_queued[READ])) &&
> (!write_limit || (write_limit && sq->nr_queued[WRITE])
> which is equivalent to
> (!read_limint || sq->nr_queued[READ]) &&
             ^
             typo
> (!write_limit || sq->nr_queued[WRITE])

Can you indent the whole thing a bit so that it's more readable?

> -static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
> +static bool throtl_tg_reach_low_limit(struct throtl_grp *tg, int rw)
>  {
>  	struct throtl_service_queue *sq = &tg->service_queue;
> -	bool read_limit, write_limit;
> +	bool limit = tg->bps[rw][LIMIT_LOW] || tg->iops[rw][LIMIT_LOW];
>  
>  	/*
> -	 * if cgroup reaches low limit (if low limit is 0, the cgroup always
> -	 * reaches), it's ok to upgrade to next limit
> +	 * if low limit is zero, low limit is always reached.
> +	 * if low limit is non-zero, we can check if there is any request
> +	 * is queued to determine if low limit is reached as we throttle
> +	 * request according to limit.
>  	 */
> -	read_limit = tg->bps[READ][LIMIT_LOW] || tg->iops[READ][LIMIT_LOW];
> -	write_limit = tg->bps[WRITE][LIMIT_LOW] || tg->iops[WRITE][LIMIT_LOW];
> -	if (!read_limit && !write_limit)
> -		return true;
> -	if (read_limit && sq->nr_queued[READ] &&
> -	    (!write_limit || sq->nr_queued[WRITE]))
> -		return true;
> -	if (write_limit && sq->nr_queued[WRITE] &&
> -	    (!read_limit || sq->nr_queued[READ]))
> +	return !limit || sq->nr_queued[rw];
> +}
> +
> +static bool throtl_tg_can_upgrade(struct throtl_grp *tg)
> +{
> +	/*
> +	 * cgroup reaches low limit when low limit of READ and WRITE are
> +	 * both reached, it's ok to upgrade to next limit if cgroup reaches
> +	 * low limit
> +	 */
> +	if (throtl_tg_reach_low_limit(tg, READ) &&
> +	    throtl_tg_reach_low_limit(tg, WRITE))

Can you please name it throtl_low_limit_reached()? Other than that,

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
