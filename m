From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RESEND v6 1/8] blk-throttle: fix that io throttle can
 only work for single bio
Date: Fri, 29 Jul 2022 08:04:42 -1000
Message-ID: <YuQhOjo02RX7uZ0K@slm.duckdns.org>
References: <20220701093441.885741-1-yukuai1@huaweicloud.com>
 <20220701093441.885741-2-yukuai1@huaweicloud.com>
 <YuGDjFkxDSsVrcRw@slm.duckdns.org>
 <7f01aba1-43ab-38ab-5755-7ac22d0a78d5@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=b3I3Wd5uoU2mw0WjpZItI4QYfcDbHg7o2KRFjsrrXS4=;
        b=MFZhFPxWjQT/AD66vBooRiM7DvdG0EMVeb1MZqQW1gnlohBjG0tG6G4gFQ8y5MQHHt
         wKJQh2aI7ESROLlHeYoPDqfSS2I9hYM9FOZu8veptRvbOb1WxOHAJKQLIGJITK0/WqYZ
         pMic5o6McoHyopQ6RFVu6maQc8DQYD9TeIINQcGLryUKh4ylJRS+EpYjSobPJtbqA9vv
         ZeP0t9Vvmg2sNBxzFVWUz05TEcIeskcViZqCXseCwuaJZJtIabY3zg4jGjbF39rHTQh5
         C6lQEDlokzoDRtPCiuPGArFalZgQe2y7s4kD0STJ14/qKc8/uQ/Jty84ioLsmPdNV/Uz
         IspQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <7f01aba1-43ab-38ab-5755-7ac22d0a78d5-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Hello,

On Fri, Jul 29, 2022 at 02:32:36PM +0800, Yu Kuai wrote:
> We need to make sure following conditions is always hold:
> 
> 1) If a bio is splited, iops limits should count multiple times, while
> bps limits should only count once.
> 2) If a bio is issued while some bios are already throttled, bps limits
> should not be ignored.
> 
> commit 9f5ede3c01f9 ("block: throttle split bio in case of iops limit")
> fixes that 1) is not hold, while it breaks 2). Root cause is that such
> bio will be flaged in __blk_throtl_bio(), and later
> tg_with_in_bps_limit() will skip flaged bio.
> 
> In order to fix this problem, at first, I change that flaged bio won't
> be skipped in tg_with_in_bps_limit():
> 
> -	if (!bio_flagged(bio, BIO_THROTTLED)) {
> -		tg->bytes_disp[rw] += bio_size;
> -		tg->last_bytes_disp[rw] += bio_size;
> -	}
> -
> +	tg->bytes_disp[rw] += bio_size;
> +	tg->last_bytes_disp[rw] += bio_size;
> 
> However, this will break that bps limits should only count once. Thus I
> try to restore the overaccounting in __blk_throtl_bio() in such case:
> 
> +		if (bio_flagged(bio, BIO_THROTTLED)) {
> +			unsigned int bio_size = throtl_bio_data_size(bio);
> +
> +			if (tg->bytes_disp[rw] >= bio_size)
> +				tg->bytes_disp[rw] -= bio_size;
> +			if (tg->last_bytes_disp[rw] >= bio_size)
> +				tg->last_bytes_disp[rw] -= bio_size;
> +		}
> 
> If new slice is not started, then the decrement should make sure this
> bio won't be counted again. However, if new slice is started and the
> condition 'bytes_disp >= bio_size' doesn't hold, this bio will end up
> accounting twice.
> 
> Pleas let me know if you think this suituation is problematic, I'll try
> to figure out a new way...

While a bit tricky, I think it's fine but please add comments in the code
explaining what's going on and why. Also, can you please explain why
__blk_throtl_bio() being skipped when iops limit is not set doesn't skew the
result?

Thanks.

-- 
tejun
