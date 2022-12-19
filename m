From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Mon, 19 Dec 2022 11:22:32 -1000
Message-ID: <Y6DWGBQSP/DA7apC@slm.duckdns.org>
References: <20221218111314.55525-1-hanjinke.666@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LZ6E54gQso9A3AZTU5M12wLSIgrxkuCsiZqbTjl9O+k=;
        b=l3qDTyq/WO1/cjtxD3IaspFo1xRvEv77I/YPtlYY0faD0+9e55S301Keu5ZRn2BOAJ
         /06AfNo/vBoHZij1MSCG6Uv5+1+IiiBAgy2JIhC7QTpbMY0cZlMcpdNFXzr6mc4GHd2n
         d2rHms6UaQeM/CfhVjMj5K5PTDHw9ItNUw8UjI+cv9LXwbrIi5iIogfGJOkiUHCkBSxG
         3wkE9PfNcCfJoosdjppXgb4kwVXjOvgse+8quW9q5UjKI65S7hmjNgYCLObocfy4UJdu
         Y76S2/ind4Za8KgctFd1vblXIyRGQOhfNIEqIcwMDe9VPC82QSRH+yLCio90FvmxMza4
         auhw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221218111314.55525-1-hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org

Hello,

This looks generally fine to me. Some nits below.

> +static inline struct bio *throtl_qnode_bio_peek(struct throtl_qnode *qn)
> +{
> +	struct bio *bio1, *bio2;
> +
> +	/* qn for read ios */
> +	if (qn->dispatch_sync_cnt == UINT_MAX)
> +		return bio_list_peek(&qn->bios[SYNC]);
> +
> +	/* qn for write ios */
> +	bio1 = bio_list_peek(&qn->bios[SYNC]);
> +	bio2 = bio_list_peek(&qn->bios[ASYNC]);
> +
> +	if (bio1 && bio2) {
> +		if (qn->dispatch_sync_cnt == THROTL_SYNC_FACTOR)
> +			return bio2;
> +		return bio1;
> +	}
> +
> +	return bio1 ?: bio2;
> +}

Wouldn't it be simpler to write:

        if (qn->dispatch_sync_count < THROTL_SYNC_FACTOR)
                return bio1 ?: bio2;
        else
                return bio2 ?: bio1;

> +/**
> + * throtl_qnode_bio_pop: pop a bio from a qnode
> + * @qn: the qnode to pop a bio from
> + *
> + * For read io qn, just pop bio from sync queu and return.
> + * For write io qn, the target queue to pop was determined by the dispatch_sync_cnt.
> + * Try to pop bio from target queue, fetch the bio and return when it is not empty.
> + * If the target queue empty, pop bio from other queue instead.
> + */
> +static inline struct bio *throtl_qnode_bio_pop(struct throtl_qnode *qn)
> +{
> +	struct bio *bio;
> +
> +	/* qn for read ios */
> +	if (qn->dispatch_sync_cnt == UINT_MAX)
> +		return bio_list_pop(&qn->bios[SYNC]);
> +
> +	/* try to dispatch sync io */
> +	if (qn->dispatch_sync_cnt < THROTL_SYNC_FACTOR) {
> +		bio = bio_list_pop(&qn->bios[SYNC]);
> +		if (bio) {
> +			qn->dispatch_sync_cnt++;
> +			return bio;
> +		}
> +		bio = bio_list_pop(&qn->bios[ASYNC]);
> +		qn->dispatch_sync_cnt = 0;
> +		return bio;
> +	}
> +
> +	/* try to dispatch async io */
> +	bio = bio_list_pop(&qn->bios[ASYNC]);
> +	if (bio) {
> +		qn->dispatch_sync_cnt = 0;
> +		return bio;
> +	}
> +	bio = bio_list_pop(&qn->bios[SYNC]);
> +
> +	return bio;
> +}

This also seems like it can be simplified a bit.

Thanks.

-- 
tejun
