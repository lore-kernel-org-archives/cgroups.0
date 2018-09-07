From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 03/12] blkcg: convert blkg_lookup_create to find closest
 blkg
Date: Fri, 7 Sep 2018 10:27:30 -0700
Message-ID: <20180907172730.GB1100574@devbig004.ftw2.facebook.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
 <20180906211045.29055-4-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iqig52G65T1oK5BZ8bJW4GpEe9IWDxjBJiK5Ly/PDlo=;
        b=W3D3ZtpiNJc27H1HB8ioZhJWEiXGPm9/5ONMzbWyxOaj21TqcWhqZpB84JWJsC+CgI
         gS/3Ht110XWa6B5moexvgg3Mp87rwMUaKfoeTcoIjyoHqTq4pyqg37k/6RsPLGi2geYF
         Op314hKbcmqwwAZtA0HQr8ym/TCLiYkVsncFTntIf5Go1ETM6sluyG92UfQZncXkmmPF
         p9F9aBqEUIVqrRK2Xr8SZSrb60XKVuvFwPBX9Zw6zs/R0I5FztandOqBJBpCGo9LMUqb
         6k5TFSynVNhm4UG6lAs5I5UeXjdR2ZWz9o366CNAnHvdkhp2y1PIhacEmP0xL4T2qVg2
         lw/Q==
Content-Disposition: inline
In-Reply-To: <20180906211045.29055-4-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 06, 2018 at 05:10:36PM -0400, Dennis Zhou wrote:
> @@ -2021,9 +2021,7 @@ int bio_associate_blkg(struct bio *bio, struct blkcg_gq *blkg)
>  {
>  	if (unlikely(bio->bi_blkg))
>  		return -EBUSY;
> +	bio->bi_blkg = blkg_try_get_closest(blkg);
>  	return 0;

It prolly would be a good idea to point out that the associated blkg
might not be the same one passed in.  Maybe this gets cleared up later
in the series?

> @@ -298,14 +297,23 @@ struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
>  	while (true) {
>  		struct blkcg *pos = blkcg;
>  		struct blkcg *parent = blkcg_parent(blkcg);
> -
> -		while (parent && !__blkg_lookup(parent, q, false)) {
> +		struct blkcg_gq *ret_blkg = NULL;
> +
> +		while (parent) {
> +			blkg = __blkg_lookup(parent, q, false);
> +			if (blkg) {
> +				/* remember closest blkg */
> +				ret_blkg = blkg;
> +				break;
> +			}
>  			pos = parent;
>  			parent = blkcg_parent(parent);
>  		}
>  
>  		blkg = blkg_create(pos, q, NULL);
> -		if (pos == blkcg || IS_ERR(blkg))
> +		if (IS_ERR(blkg))
> +			return ret_blkg ?: q->root_blkg;

Why not ret_blkg here?

Thanks.

-- 
tejun
