From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 02/11] blk-throttle: Fix that bps of child could exceed
 bps limited in parent
Date: Wed, 23 Nov 2022 08:09:57 -1000
Message-ID: <Y35h9SmFeEJtBNgM@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-3-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=42jiVvL+Ts2qh8Knn9mc2OntlNZr+ruehTRXIYJtsgE=;
        b=kGEGxym2YsPDl+okJR+jAn9W99iCg2L5fctazVNfEVJQ6iw7n7XVcxJnKnNmYjd6g6
         u6u6XnwbjVrt0w8j72DAle4dZGDdtfBW8X9zTc81l5maOtamqMfUIaUQwafb8lOvrWGO
         qINUff3Ku+XIthIeKcEVc7busmkpJoMzZYZYaogshvbYljNoFzNiXCuVjwBalmvJcrBT
         RIfqC8i+i1MU6as4+/8XsNCXD8L1AVZJFkyLTtmZ81dFQjtaSLreuez9uTMsF/jZZw3n
         QQ7uwWxo01UW971auvwjUE1twN8Qs0LmIOAV+H8FsQetN7TJ3taVuownfeYPwHTjHQqC
         G7kw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-3-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 23, 2022 at 02:03:52PM +0800, Kemeng Shi wrote:
> @@ -964,10 +963,8 @@ static void throtl_charge_bio(struct throtl_grp *tg, struct bio *bio)
>  	unsigned int bio_size = throtl_bio_data_size(bio);
>  
>  	/* Charge the bio to the group */
> -	if (!bio_flagged(bio, BIO_BPS_THROTTLED)) {
> -		tg->bytes_disp[rw] += bio_size;
> -		tg->last_bytes_disp[rw] += bio_size;
> -	}
> +	tg->bytes_disp[rw] += bio_size;
> +	tg->last_bytes_disp[rw] += bio_size;

Are you sure this isn't gonna lead to double accounting? IIRC, the primary
purpose of this flag is avoiding duplicate accounting of bios which end up
going through the throttling path multiple times for whatever reason and
we've had numerous breakages around it.

To address the problem you're describing in this patch, wouldn't it make
more sense to set the flag only when the bio traversed the entire tree
rather than after each tg?

Thanks.

-- 
tejun
