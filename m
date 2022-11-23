From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 04/11] blk-throttle: correct calculation of wait time in
 tg_may_dispatch
Date: Wed, 23 Nov 2022 08:18:56 -1000
Message-ID: <Y35kELlFkI/BtkqC@slm.duckdns.org>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-5-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/+wiUlX+ZzbOJle7HnS1krIiCPjVF1I+A5cD8cm1XM8=;
        b=oZeeBnEeGmvjRkvxpd5dd4v1+nkW1yLWhjB1DNJmqQKV0eIUzEyRNI9KXZBGZL4JO7
         Vp9VbeF+D/aoQ5F2L2rjPMaGOqgiO5HjnnKWNF+YJx2R7+GsbiR4jal2MHBPE6eg+jBN
         wSFp9cv7IbUn5M+i38B6LfWvRvU5V0CvxcTXkubZwuVPzo+uS4c4JlyO0SlhL2zoydzQ
         t5dcixwsUZnz1vGaGwou5EWvGYvjK8brVFpBVEL8Mr15CRiXWX+H81iWY12EPefqUXpO
         4tEYMm7piYEKqHN3IdOto/oo+KvUOXVUXPaMZw+0hzmtFoJZACW3lRySAU7EWmsi5KXB
         slgQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20221123060401.20392-5-shikemeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng@huawei.com>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Nov 23, 2022 at 02:03:54PM +0800, Kemeng Shi wrote:
> If bps and iops both reach limit, we always return bps wait time as
> tg_within_iops_limit is after "tg_within_bps_limit(tg, bio, bps_limit) &&"
> and will not be called if tg_within_bps_limit return true.

Maybe it's obvious but it'd be better to explain "why" this change is being
made.

> @@ -939,8 +926,9 @@ static bool tg_may_dispatch(struct throtl_grp *tg, struct bio *bio,
>  				jiffies + tg->td->throtl_slice);
>  	}
>  
> -	if (tg_within_bps_limit(tg, bio, bps_limit, &bps_wait) &&
> -	    tg_within_iops_limit(tg, bio, iops_limit, &iops_wait)) {
> +	bps_wait = tg_within_bps_limit(tg, bio, bps_limit);
> +	iops_wait = tg_within_iops_limit(tg, bio, iops_limit);
> +	if (bps_wait + iops_wait == 0) {
>  		if (wait)
>  			*wait = 0;
>  		return true;

So, max_wait is supposed to be maximum in the whole traversal path in the
tree, not just the max value in this tg, so after this, the code should be
changed to sth like the following, right?

        max_wait = max(max, max(bps_wait, iops_wait));

Thanks.

-- 
tejun
