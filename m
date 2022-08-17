From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v7 4/9] blk-throttle: fix io hung due to configuration
 updates
Date: Wed, 17 Aug 2022 07:52:45 -1000
Message-ID: <Yv0q7T5Eg6MzOIuU@slm.duckdns.org>
References: <20220802140415.2960284-1-yukuai1@huaweicloud.com>
 <20220802140415.2960284-5-yukuai1@huaweicloud.com>
 <Yvv3jcycOguuEbA3@slm.duckdns.org>
 <215b4842-c09f-d622-7127-c8b1d9ce3aa9@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=OSADlFbIj2e9HqyRVtp14PL1Xr6rNvJVCrKar0E+Zk8=;
        b=Zo40/TjPDHiWeNSjJknVi5F5cx4JHD2EGWguUAk4iAmlDsu/4A7LpbnUsr/85DnZrg
         cNVsm3cOlYXqTW8jVChsuOr7xhFKyi+9lk2ZNwU09JWHWHIb/oKc0DoVmlV0NZvYUHnm
         Qymufs9T4X3vDGdiuoeLG0Bo/vBqVPBJ607NDNvmv90r2CrohZAKj2yfXaB39sDXC7q4
         YKNIfKMkeu/DQx5fq4gB+ou1zizz/7DxAYUADn+38nUmQvvl1SZx7VJCseh6RNsRoYY+
         jr0SD74JXBFmuez17lcEPwJZTwYvN4rq++uouH/sBEsaA0sYYyZ7xD7gAIhOAm89OD7w
         hoYw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <215b4842-c09f-d622-7127-c8b1d9ce3aa9-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Wed, Aug 17, 2022 at 09:30:30AM +0800, Yu Kuai wrote:
> > Would it be easier if the fields were signed? It's fragile and odd to
> > explain "these are unsigned but if they underflow they behave just like
> > signed when added" when they can just be signed. Also, I have a hard time
> > understand what "preempt" means above.
> 
> I think preempt shound never happen based on current FIFO
> implementation, perhaps

Can you elaborate what "preempt" is?

> > > +	if (bps_limit != U64_MAX)
> > > +		tg->bytes_skipped[rw] +=
> > > +			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
> > > +			tg->bytes_disp[rw];
> > > +	if (iops_limit != UINT_MAX)
> > > +		tg->io_skipped[rw] +=
> > > +			calculate_io_allowed(iops_limit, jiffy_elapsed) -
> > > +			tg->io_disp[rw];
> > 
> > So, this is calculating the budgets to carry over. Can we name them
> > accordingly? I don't know what "skipped" means.
> 
> Yeah, thanks for you advice, art of naming is a little hard for me...
> How do you think about these name: extended_bytes/io_budget?

How about carryover_{ios|bytes}?

Thanks.

-- 
tejun
